//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Anastasia Petrova on 03/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit
import MapKit

final class PhotoAlbumViewController: UIViewController {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: AlbumCollectionLayout())
    let dataSource: AlbumCollectionDataSource
    let coordinate:  CLLocationCoordinate2D
    let photos: [FlickrPhoto]
    var page = 1
    
    init(coordinate:  CLLocationCoordinate2D, photos: [FlickrPhoto]) {
        self.coordinate = coordinate
        self.photos = photos
        self.dataSource = AlbumCollectionDataSource(coordinate: coordinate, photos: photos)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .white
        collectionView.register(MapCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MapCollectionHeader")
        collectionView.register(
            PhotosCollectionCell.self,
            forCellWithReuseIdentifier: PhotosCollectionCell.identifier
        )

        collectionView.dataSource = dataSource
        collectionView.delegate = self
        setUpCollectionView()
        setUpAddCollectionButton()
    }
    
    override func viewDidLayoutSubviews() {
        if let layout = collectionView.collectionViewLayout as? AlbumCollectionLayout {
            layout.setWidth(width: view.frame.width)
        }
    }
    
    private func setUpCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        collectionView.backgroundColor = .white
    }
    
    private func setUpAddCollectionButton() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate ([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("New Collection", for: .normal)
        button.addTarget(self, action: #selector(addNewCollection), for: .touchUpInside)
    }
    
    @objc func addNewCollection() {
        page += 1
        FlickrClient.getPhotos(latitude: "\(coordinate.latitude)", longitude: "\(coordinate.longitude)", page: page) { result in
            switch result {
            case .success(let photos):
                print("SUUCCEESSS!!!!!!")
                if self.dataSource.photos == photos.searchResults {
                    print("SAAAMEEE PHOOOTOOOS!!!!!")
                } else {
                    print("DIFFERENT PHOOOTOOOS!!!!!")
                }
                self.dataSource.photos = photos.searchResults
                self.collectionView.reloadData()
            case .failure:
                print("EEEERRRROOOOOOORRRRR!!!!!!")
            }
        }
    }
}

extension PhotoAlbumViewController: UICollectionViewDelegate {
    
}


extension PhotoAlbumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
}

