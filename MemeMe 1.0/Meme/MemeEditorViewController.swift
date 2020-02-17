//
//  MemeViewController.swift
//  Meme
//
//  Created by Anastasia Petrova on 17/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit
import MobileCoreServices

class MemeEditorViewController: UIViewController {
    let tabBar = TabBar(items: "Camera", "Album")
    let photoView = UIImageView(frame: .zero)
    let topTextField = UITextField()
    let bottomTextField = UITextField()
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: 0.1
    ]
    
    var isCameraButtonSelected: Bool = false {
        didSet {
            if isCameraButtonSelected {
                openCamera()
            }
        }
    }
    
    var isAlbumButtonSelected: Bool = false {
        didSet {
            if isAlbumButtonSelected {
                handleAddPhoto()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        topTextField.delegate = self
//        bottomTextField.delegate = self
        self.view.backgroundColor = .white
        self.view.addSubview(photoView)
        self.view.addSubview(tabBar)
        
        setUpNavigationBar()
        setUpImageView()
        setUpTabBar()
        setUpTextFields()
    }
    
    private func setUpNavigationBar() {
        let actionItem = UIBarButtonItem(barButtonSystemItem: .action, target: self,  action: #selector(openActivityView))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
        navigationItem.leftBarButtonItem = actionItem
        navigationItem.rightBarButtonItem = cancelItem
        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func setUpImageView() {
        photoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoView.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        photoView.backgroundColor = .darkGray
        photoView.contentMode = .scaleAspectFit
    }
    
    func setUpTextFields() {
        topTextField.translatesAutoresizingMaskIntoConstraints = false
        bottomTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topTextField)
        view.addSubview(bottomTextField)
        //FIXME: assign top and botton constratints to properties and chance constant in viewDidLayoutSubviews
        NSLayoutConstraint.activate([
            topTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height * 0.01),
            tabBar.topAnchor.constraint(equalTo: bottomTextField.bottomAnchor, constant: view.frame.height * 0.01),
            topTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        topTextField.borderStyle = .none
        topTextField.textAlignment = .center
        topTextField.textColor = .white
        topTextField.font = .systemFont(ofSize: 32, weight: .heavy)
        topTextField.text = "TOP"
        topTextField.isUserInteractionEnabled = true
//        topTextField.defaultTextAttributes = memeTextAttributes
//        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.borderStyle = .none
        bottomTextField.textAlignment = .center
        bottomTextField.textColor = .white
        bottomTextField.font = .systemFont(ofSize: 32, weight: .heavy)
        bottomTextField.text = "BOTTOM"
        bottomTextField.isUserInteractionEnabled = true
    }
    
    private func setUpTabBar() {
        tabBar.delegate = self
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabBar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tabBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func handleAddPhoto() {
        tabBar.selectedItem = nil
        VideoBrowser.startMediaBrowser(delegate: self, sourceType: .photoLibrary)
    }
    
    func openCamera() {
        VideoBrowser.startMediaBrowser(delegate: self, sourceType: .camera)
        tabBar.selectedItem = nil
    }
    
    @objc func openActivityView() {
        let image = UIImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
    }
    
    @objc func cancel() {
        photoView.image = nil
        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.isEnabled = false
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension MemeEditorViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let selectedIndex = tabBar.items?.firstIndex(of: item) else { return }
        
        isCameraButtonSelected = selectedIndex == 0
        isAlbumButtonSelected = selectedIndex == 1
    }
}

extension MemeEditorViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
            mediaType == (kUTTypeImage as String),
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                return
        }
        
        dismiss(animated: true) {
            self.photoView.image = image
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}

extension MemeEditorViewController: UINavigationControllerDelegate {}

extension MemeEditorViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//      textField.resignFirstResponder()
//        return true
//    }
}
