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
    let tabBar = UITabBar()
    let photoView = UIImageView(frame: .zero)
    let cameraBarItem = UITabBarItem()
    let albumBarItem = UITabBarItem()
    let topTextField = UITextField()
    let bottomTextField = UITextField()
    var topTextFieldTopConstraint = NSLayoutConstraint()
    var bottomTextFieldBottomConstraint = NSLayoutConstraint()
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
        topTextField.delegate = self
        bottomTextField.delegate = self
        self.view.backgroundColor = .white
        self.view.addSubview(photoView)
        self.view.addSubview(tabBar)
        
        setUpNavigationBar()
        setUpImageView()
        setUpCustomTabBar()
        setUpTextFields()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        topTextFieldTopConstraint.constant = view.frame.height * 0.09
        bottomTextFieldBottomConstraint.constant = view.frame.height * 0.09
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraBarItem.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        sudcribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsudcribeToKeyboardNotifications()
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
        topTextFieldTopConstraint = topTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height * 0.01)
        bottomTextFieldBottomConstraint = tabBar.topAnchor.constraint(equalTo: bottomTextField.bottomAnchor, constant: view.frame.height * 0.01)
        NSLayoutConstraint.activate([
            topTextFieldTopConstraint,
            bottomTextFieldBottomConstraint,
            topTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        topTextField.borderStyle = .none
        topTextField.textAlignment = .center
        topTextField.textColor = .white
        topTextField.font = .systemFont(ofSize: 32, weight: .heavy)
        topTextField.text = "TOP"
        topTextField.isUserInteractionEnabled = true
        bottomTextField.borderStyle = .none
        bottomTextField.textAlignment = .center
        bottomTextField.textColor = .white
        bottomTextField.font = .systemFont(ofSize: 32, weight: .heavy)
        bottomTextField.text = "BOTTOM"
        bottomTextField.isUserInteractionEnabled = true
        //        if let font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40) {
        //            let memeTextAttributes: [NSAttributedString.Key: Any] = [
        //                NSAttributedString.Key.strokeColor: UIColor.black,
        //                NSAttributedString.Key.foregroundColor: UIColor.white,
        //                NSAttributedString.Key.font: font,
        //                NSAttributedString.Key.strokeWidth: 0.1
        //            ]
        //            topTextField.defaultTextAttributes = memeTextAttributes
        //            bottomTextField.defaultTextAttributes = memeTextAttributes
        //        }
    }
    
    func setUpCustomTabBar() {
        tabBar.delegate = self
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabBar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tabBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        tabBar.tintColor = .white
        tabBar.itemPositioning = .centered
        cameraBarItem.image = UIImage(systemName: "camera.fill")
//        cameraBarItem.imageInsets = UIEdgeInsets(top: 20, left: 0, bottom: -20, right: 0)
        albumBarItem.title = "Album"
        albumBarItem.setTitleTextAttributes(
            [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .semibold),
                NSAttributedString.Key.foregroundColor : UIColor.systemGray
            ],
            for: .normal
        )
//        albumBarItem.titlePositionAdjustment = .init(horizontal: 0, vertical: -15)
        tabBar.setItems([cameraBarItem, albumBarItem], animated: false)
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
        let image = generateMemedImage()
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
    
    @objc func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y = -getKeyboardHight(notification)
    }
    
    @objc func keyboardWillHide() {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func sudcribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsudcribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func save() {
        let memedImage = generateMemedImage()
        let meme = MemeModel(topTetx: topTextField.text!, bottomText: bottomTextField.text!, originalImage: photoView.image!, memedImage: memedImage)
    }
    
    func generateMemedImage() -> UIImage {
        // TODO: Hide toolbar and navbar

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar

        return memedImage
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
        return true
    }
}
