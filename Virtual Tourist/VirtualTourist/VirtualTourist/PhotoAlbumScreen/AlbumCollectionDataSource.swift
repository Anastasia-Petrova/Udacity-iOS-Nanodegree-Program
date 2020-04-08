//
//  AlbumCollectionDataSource.swift
//  VirtualTourist
//
//  Created by Anastasia Petrova on 04/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import CoreData
import EasyCoreData
import MapKit
import UIKit

final class AlbumCollectionDataSource: NSObject {
    typealias Controller = CoreDataController<Photo, PhotoViewModel>
    let controller: Controller
    private var pandingChanges: [Controller.Change] = []
    let pin: Pin
    let pinID: NSManagedObjectID
    var collectionView: UICollectionView
    var loadedImages: [UIImage] = []
    var savedImagesID: [UUID] = []
    
    let coordinate:  CLLocationCoordinate2D
    
    init(collectionView: UICollectionView, pinID: NSManagedObjectID) {
        self.collectionView = collectionView
        self.pinID = pinID
        pin = try! CoreDataStack.instance.context.existingObject(with: pinID) as! Pin
        coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        let predicate = NSPredicate(format: "%K == %@",
                                    #keyPath(Photo.pin), pin)
        controller = Controller(
            entityName: "Photo",
            predicate: predicate
        )
        super.init()
        
        controller.beginUpdate = { [weak self] in
            self?.pandingChanges.removeAll()
        }
        controller.endUpdate = { [weak self] in
            guard let self = self else { return }
            collectionView.performBatchUpdates({
                self.pandingChanges.forEach {
                    switch $0.type {
                    case let .row(rowChange):
                        switch rowChange {
                        case let .delete(indexPath):
                            self.collectionView.deleteItems(at: [indexPath])
                        case let .insert(indexPath):
                            self.collectionView.insertItems(at: [indexPath])
                        case let  .move(fromIndexPath, toIndexPath):
                            self.collectionView.moveItem(at: fromIndexPath, to: toIndexPath)
                        case let .update(indexPath):
                            self.collectionView.reloadItems(at: [indexPath])
                        case let .error(error):
                            print(error)
                        }
                    case .section: break
                    }
                }
            }, completion: nil)
        }
        controller.changeCallback = { [weak self] change in
            self?.pandingChanges.append(change)
        }
        controller.fetch()
        if let photos = pin.photos as? Set<Photo> {
            if photos.isEmpty {
                getPhotosUrls()
            } else {
                photos.forEach { photo in
                    if let url = photo.url {
                        loadImageFromDisk(url: url)
                    }
                }
            }
        }
    }
    
    func getPhotosUrls() {
        FlickrClient.getPhotos(
            latitude: "\(coordinate.latitude)",
            longitude: "\(coordinate.longitude)",
            page: 1
        ) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    response
                        .searchResults
                        .map {
                            let photo = Photo()
                            photo.url = $0.flickrImageURL()
                            return photo
                        }
                        .forEach { (photo: Photo) in
                            CoreDataStack.instance.context.insert(photo)
                            photo.pin = self.pin
                        }
                    CoreDataStack.instance.saveContext()
                    self.startImageDownload()
                }
            case .failure:
                print("EEEERRRROOOOOOORRRRR!!!!!!")
            }
        }
    }
    
    func startImageDownload() {
        let count = controller.numberOfItems(in: 0)
        for index in 0..<count {
            let indexPath = IndexPath(item: index, section: 0)
            let item = controller.getItem(at: indexPath)
            guard let url = item.url else { return }
            loadImage(url: url) { result in
                DispatchQueue.main.async {
                    switch result {
                    case let .success(image):
                        self.loadedImages.append(image)
                        self.updatePhotoURL(
                            url: self.saveImageOnDisk(image: image, indexPath: indexPath),
                            indexPath: indexPath
                        )
                    case .failure: break
                    }
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func saveImageOnDisk(image: UIImage, indexPath: IndexPath) -> URL {
        return try! ImageStore.saveImage(image: image)
    }
    
    func updatePhotoURL(url: URL, indexPath: IndexPath) {
        controller.updateModels(indexPaths: [indexPath]) { photo in
            photo.first?.url = url
        }
    }

    func loadImageFromDisk(url: URL) {
        let image = ImageStore.getImage(url: url)
        if let image = image {
            loadedImages.append(image)
        }
    }
    
    func deletePhoto(at indexPath: IndexPath) {
        controller.deleteItems(at: [indexPath])
        collectionView.reloadData()
    }
}

extension AlbumCollectionDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return controller.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controller.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
               let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MapCollectionHeader", for: indexPath)
               if let mapHeaderView = headerView as? MapCollectionHeader {
                let mapView = mapHeaderView.mapView
                mapView.delegate = self
                mapView.addAnnotation(setUpMapAnnotations(at: coordinate))
                mapView.setRegion(setUpZoomArea(coordinate), animated: true)
               }
               return headerView

        default:  fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionCell.identifier, for: indexPath) as! PhotosCollectionCell

        let cellImage: UIImage?
        if indexPath.row < loadedImages.count {
            cellImage = loadedImages[indexPath.row]
        } else {
            cellImage = UIImage(named: "placeholder")!.withRenderingMode(.alwaysTemplate)
        }
        cell.photoImageView.image = cellImage
        return cell
    }
}

extension AlbumCollectionDataSource: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        if let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView  {
            pinView.annotation = annotation
            return pinView
        } else {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView.pinTintColor = .red
            return pinView
        }
    }
    
    private func setUpMapAnnotations(at
        coordinate: CLLocationCoordinate2D) ->  MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        return annotation
    }
    
    private func setUpZoomArea(_ coordinate: CLLocationCoordinate2D) ->  MKCoordinateRegion {
        let span = MKCoordinateSpan(
            latitudeDelta: 0.5,
            longitudeDelta: 0.5
        )
        return MKCoordinateRegion(center: coordinate, span: span)
    }
    
    private func loadImage(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let loadRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: loadRequest) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(.failure(Error.taskError))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(Error.noData))
                }
                return
            }
            
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                if let image = image {
                    completion(.success(image))
                } else {
                    completion(.failure(Error.badData))
                }
            }
        }
        task.resume()
    }
}

extension AlbumCollectionDataSource {
    enum Error: Swift.Error {
        case badData
        case noData
        case taskError
    }
}
