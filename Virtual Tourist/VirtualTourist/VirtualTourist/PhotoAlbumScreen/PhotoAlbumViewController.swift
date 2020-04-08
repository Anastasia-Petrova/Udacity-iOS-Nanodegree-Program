//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Anastasia Petrova on 03/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import CoreData
import UIKit
import MapKit

final class PhotoAlbumViewController: UIViewController {
    let activityIndicator = UIActivityIndicatorView()
    let addNewCollectionButton = UIButton()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: AlbumCollectionLayout())
    let dataSource: AlbumCollectionDataSource
    let coordinate:  CLLocationCoordinate2D
    var page = 1
    
    init(coordinate:  CLLocationCoordinate2D, pinID: NSManagedObjectID) {
        self.coordinate = coordinate
        self.dataSource = AlbumCollectionDataSource(
            collectionView: collectionView,
            pinID: pinID
        )
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
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        
        let stackView = UIStackView(arrangedSubviews: [addNewCollectionButton, activityIndicator])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        containerView.addSubview(stackView)
        
        addNewCollectionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        addNewCollectionButton.setTitleColor(.systemBlue, for: .normal)
        addNewCollectionButton.setTitle("New Collection", for: .normal)
        addNewCollectionButton.addTarget(self, action: #selector(addNewCollection), for: .touchUpInside)
        
        activityIndicator.color = .systemBlue
        activityIndicator.hidesWhenStopped = true
        
        NSLayoutConstraint.activate ([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 50),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
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
        page = Int(dataSource.pin.page) + 1
        dataSource.deleteAllPhotos()
        dataSource.getPhotosUrls(page: page)
        self.setActivityIndicatorOn(false)
    }
}

extension PhotoAlbumViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataSource.deletePhoto(at: indexPath)
        collectionView.deleteItems(at: [indexPath])
    }
}


extension PhotoAlbumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
}

