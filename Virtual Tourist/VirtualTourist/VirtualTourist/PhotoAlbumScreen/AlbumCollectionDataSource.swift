//
//  AlbumCollectionDataSource.swift
//  VirtualTourist
//
//  Created by Anastasia Petrova on 04/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit
import MapKit

final class AlbumCollectionDataSource: NSObject, UICollectionViewDataSource {
    let coordinate:  CLLocationCoordinate2D
    
    init(coordinate:  CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
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
        cell.photoImageView.image = UIImage(named: "launchScreen")
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
}
