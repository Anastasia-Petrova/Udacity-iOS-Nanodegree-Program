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
    let photoView = UIImageView(frame: .zero)
    let cameraButton = UIBarButtonItem()
    let topTextField = UITextField()
    let bottomTextField = UITextField()
    var bottomTextFieldBottomConstraint = NSLayoutConstraint()
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: 0.1
    ]
    var meme: MemeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.delegate = self
        bottomTextField.delegate = self
        self.view.backgroundColor = .white
        self.view.addSubview(photoView)
        
        setUpNavigationBar()
        setUpImageView()
        setUpToolBar()
        setUpTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
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
    
    private func setUpToolBar() {
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.contentMode = .center
        cameraButton.image = UIImage(systemName: "camera.fill")
        cameraButton.style = .plain
        cameraButton.target = self
        cameraButton.action = #selector(openCamera)
        let albumButton = UIBarButtonItem(title: "Album", style: .plain, target: self, action: #selector(openPhotoLibrary))

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let items = [flexibleSpace, cameraButton, flexibleSpace, albumButton, flexibleSpace]
        self.toolbarItems = items
    }
    
    private func setUpImageView() {
        photoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        photoView.backgroundColor = .darkGray
        photoView.contentMode = .scaleAspectFit
    }
    
    private func setUpTextFields() {
        topTextField.translatesAutoresizingMaskIntoConstraints = false
        bottomTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topTextField)
        view.addSubview(bottomTextField)
        bottomTextFieldBottomConstraint = photoView.bottomAnchor.constraint(
            equalTo: bottomTextField.bottomAnchor,
            constant: 16
        )
        topTextField.setContentHuggingPriority(.required, for: .vertical)
        topTextField.setContentCompressionResistancePriority(.required, for: .vertical)
        bottomTextField.setContentHuggingPriority(.required, for: .vertical)
        bottomTextField.setContentCompressionResistancePriority(.required, for: .vertical)
        let topTextFieldTopConstraint = topTextField.topAnchor.constraint(
            equalTo: photoView.topAnchor,
            constant: 16
        )
        topTextFieldTopConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            topTextFieldTopConstraint,
            topTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topTextField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            view.trailingAnchor.constraint(
                equalTo: topTextField.trailingAnchor,
                constant: 16
            ),
            bottomTextField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            view.trailingAnchor.constraint(
                equalTo: bottomTextField.trailingAnchor,
                constant: 16
            ),
            bottomTextField.topAnchor.constraint(
                greaterThanOrEqualTo: topTextField.bottomAnchor,
                constant: 8
            ),
            bottomTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomTextFieldBottomConstraint
        ])
        topTextField.borderStyle = .none
        topTextField.text = "TOP"
        topTextField.isUserInteractionEnabled = false
        topTextField.adjustsFontSizeToFitWidth = true
        topTextField.minimumFontSize = 12
        topTextField.autocapitalizationType = .allCharacters
        bottomTextField.borderStyle = .none
        bottomTextField.text = "BOTTOM"
        bottomTextField.isUserInteractionEnabled = false
        bottomTextField.adjustsFontSizeToFitWidth = true
        if let font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40) {
            let memeTextAttributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.strokeColor: UIColor.black,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.strokeWidth: -3.0
            ]
            topTextField.defaultTextAttributes = memeTextAttributes
            bottomTextField.defaultTextAttributes = memeTextAttributes
        }
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
    }
    
    @objc func openPhotoLibrary() {
        VideoBrowser.startMediaBrowser(delegate: self, sourceType: .photoLibrary)
    }
    
    @objc func openCamera() {
        VideoBrowser.startMediaBrowser(delegate: self, sourceType: .camera)
    }
    
    @objc func openActivityView() {
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(controller, animated: true, completion: { [weak self] in
            self?.save()
        })
    }
    
    @objc func cancel() {
        photoView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.isEnabled = false
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard bottomTextField.isEditing else { return }
        let height = getKeyboardHight(notification)
        let duration = getKeyboardAnimationDuration(notification)
        let curve = getKeyboardAnimationCurve(notification)
        
        self.view.layoutIfNeeded()
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.animationOptions(for: curve),
            animations: {
                self.bottomTextFieldBottomConstraint.constant = height
                self.view.layoutIfNeeded()
        },
            completion: nil
        )
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let height: CGFloat = 16.0
        let duration = getKeyboardAnimationDuration(notification)
        let curve = getKeyboardAnimationCurve(notification)
        
        self.view.layoutIfNeeded()
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.animationOptions(for: curve),
            animations: {
                self.bottomTextFieldBottomConstraint.constant = height
                self.view.layoutIfNeeded()
        },
            completion: nil
        )
    }
    
    func getKeyboardAnimationCurve(_ notification: Notification) -> UIView.AnimationCurve {
        let userInfo = notification.userInfo
        let curve = userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber
        return UIView.AnimationCurve(rawValue: curve.intValue)!
    }
    
    func getKeyboardAnimationDuration(_ notification: Notification) -> TimeInterval {
        let userInfo = notification.userInfo
        let duration = userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        return duration.doubleValue
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
        meme = MemeModel(topTetx: topTextField.text!, bottomText: bottomTextField.text!, originalImage: photoView.image!, memedImage: memedImage)
    }
    
    func generateMemedImage() -> UIImage {
        // TODO: Hide toolbar and navbar
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = true

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = false

        return memedImage
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
            self.topTextField.isUserInteractionEnabled = true
            self.bottomTextField.isUserInteractionEnabled = true
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

extension UIView {
    class func animationOptions(for curve: UIView.AnimationCurve) -> UIView.AnimationOptions {
        switch (curve) {
        case .easeInOut: return .curveEaseInOut
        case .easeIn: return .curveEaseIn
        case .easeOut: return .curveEaseOut
        case .linear: return .curveLinear
        @unknown default: return .curveLinear
        }
    }
}

