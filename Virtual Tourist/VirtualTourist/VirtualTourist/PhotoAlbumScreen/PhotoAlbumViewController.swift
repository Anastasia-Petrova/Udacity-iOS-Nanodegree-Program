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
    let activityIndicator = UIActivityIndicatorView()
    let addNewCollectionButton = UIButton()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: AlbumCollectionLayout())
    let dataSource: AlbumCollectionDataSource
    let coordinate:  CLLocationCoordinate2D
    var page = 1
    
    init(coordinate:  CLLocationCoordinate2D, photos: [FlickrPhoto]) {
        self.coordinate = coordinate
        self.dataSource = AlbumCollectionDataSource(collectionView: collectionView, coordinate: coordinate, photos: photos)
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
        dataSource.startImageDownload()
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
        let stackView = UIStackView(arrangedSubviews: [addNewCollectionButton, activityIndicator])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate ([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        addNewCollectionButton.backgroundColor = .white
        addNewCollectionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        addNewCollectionButton.setTitleColor(.systemBlue, for: .normal)
        addNewCollectionButton.setTitle("New Collection", for: .normal)
        addNewCollectionButton.addTarget(self, action: #selector(addNewCollection), for: .touchUpInside)
        
        activityIndicator.color = .systemBlue
        activityIndicator.hidesWhenStopped = true
    }
    
    private func setActivityIndicatorOn(_ isOn: Bool) {
        addNewCollectionButton.isHidden = isOn
        if isOn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    @objc func addNewCollection() {
        setActivityIndicatorOn(true)
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
            self.setActivityIndicatorOn(false)
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

