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
    let label = UILabel()
    let cameraButton = UIBarButtonItem()
    let topTextField = UITextField()
    let bottomTextField = UITextField()
    var bottomTextFieldBottomConstraint = NSLayoutConstraint()
    var topTextFieldTopConstraint = NSLayoutConstraint()
    var topTextFieldLeadingConstraint = NSLayoutConstraint()
    var topTextFieldTrailingConstraint = NSLayoutConstraint()
    var bottomTextFieldLeadingConstraint = NSLayoutConstraint()
    var bottomTextFieldTrailingConstraint = NSLayoutConstraint()
    var memeTextAttributes: [NSAttributedString.Key: Any] {
        let font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)
            ?? UIFont.systemFont(ofSize: 40)
        return [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.strokeWidth: -3.0
        ]
    }
    var meme: MemeModel?
    var keyboardHeight: CGFloat = 0.0
    
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
        setUpPickImageLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        sudcribeToKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topTextFieldTopConstraint.constant = countTextFieldsConstants().top
        bottomTextFieldBottomConstraint.constant = countTextFieldsConstants().bottom
        topTextFieldLeadingConstraint.constant = countTextFieldLeadingConstants()
        topTextFieldTrailingConstraint.constant = countTextFieldLeadingConstants()
        bottomTextFieldLeadingConstraint.constant = countTextFieldLeadingConstants()
        bottomTextFieldTrailingConstraint.constant = countTextFieldLeadingConstants()
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
    
    func setUpPickImageLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)
        label.font = .systemFont(ofSize: 30, weight: .medium)
        label.numberOfLines = 0
        label.text = "Pick an image"
        label.textColor = .white
        label.textAlignment = .center
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
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
        topTextFieldTopConstraint =
            topTextField.topAnchor.constraint(
            equalTo: photoView.topAnchor,
            constant: 16
        )
        topTextFieldLeadingConstraint =
            topTextField.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 16
        )
        topTextFieldTrailingConstraint =
                view.trailingAnchor.constraint(
                equalTo: topTextField.trailingAnchor,
                constant: 16
        )
        bottomTextFieldLeadingConstraint = bottomTextField.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 16
        )
        bottomTextFieldTrailingConstraint =             view.trailingAnchor.constraint(
            equalTo: bottomTextField.trailingAnchor,
            constant: 16
        )
        
        topTextFieldTopConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            topTextFieldTopConstraint,
            topTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topTextFieldLeadingConstraint,
            topTextFieldTrailingConstraint,
            bottomTextFieldLeadingConstraint,
            bottomTextFieldTrailingConstraint,
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
        bottomTextField.text = "TOP"
        bottomTextField.autocapitalizationType = .allCharacters
        bottomTextField.isUserInteractionEnabled = false
        bottomTextField.adjustsFontSizeToFitWidth = true
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        
        topTextField.isHidden = true
        bottomTextField.isHidden = true
    }
    
    func countTextFieldsConstants() -> (top: CGFloat, bottom: CGFloat) {
        var topConstant: CGFloat = 0.0
        var bottomConstant: CGFloat = 0.0
        guard let image = photoView.image else { return (topConstant, bottomConstant)}
        
        let imageViewHeight = photoView.frame.height
        let aspectRatio = image.size.height/image.size.width
        
        let smallerSide =
            photoView.frame.height > photoView.frame.width
            ? photoView.frame.width
            : photoView.frame.height
        
        let contextSize = CGSize(
            width: smallerSide,
            height: smallerSide * aspectRatio
        )
        let keyboardOffset = max(0, keyboardHeight - view.safeAreaInsets.bottom)
        if photoView.frame.height > photoView.frame.width {
            topConstant = ((imageViewHeight - contextSize.height) / 2 + 8)
            let baseOffset = max((imageViewHeight - contextSize.height) / 2, keyboardOffset)
            bottomConstant = baseOffset + 8
        } else {
            topConstant = 8
            bottomConstant = 8 + keyboardOffset
        }
        return (topConstant, bottomConstant)
    }
    
    func countTextFieldLeadingConstants() -> CGFloat {
//        return 16
        var leadingConstant: CGFloat = 0.0
        
        guard let image = photoView.image else { return (leadingConstant)}
        
        let imageViewWidth = photoView.frame.width
        let aspectRatio = image.size.width/image.size.height
        
        let smallerSide =
            photoView.frame.height > photoView.frame.width
            ? photoView.frame.width
            : photoView.frame.height
        
        let contextSize = CGSize(
            width: smallerSide * aspectRatio,
            height: smallerSide
        )
        
        if photoView.frame.width > photoView.frame.height {
            leadingConstant = ((imageViewWidth - contextSize.width) / 2 + 16)
        } else {
            leadingConstant = 16
        }
        return leadingConstant
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
        self.label.isHidden = false
        topTextField.isHidden = true
        bottomTextField.isHidden = true
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.isEnabled = false
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard bottomTextField.isEditing else {
            return
        }
        keyboardHeight = getKeyboardHight(notification)
        let duration = getKeyboardAnimationDuration(notification)
        let curve = getKeyboardAnimationCurve(notification)
        
        self.view.layoutIfNeeded()
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.animationOptions(for: curve),
            animations: {
                //We call setNeedsLayout to work around edge case when we rotate
                //device with keyboard visible. In which case viewDidLayoutSubviews is
                //called before keyboardWillShow and layoutIfNeeded in this animation block
                //does not trigger another layout cycle.
                self.view.setNeedsLayout()
        },
            completion: nil
        )
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        keyboardHeight = 0.0
        let duration = getKeyboardAnimationDuration(notification)
        let curve = getKeyboardAnimationCurve(notification)
        
        self.view.layoutIfNeeded()
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.animationOptions(for: curve),
            animations: {
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
    
    func textAttributes(fontSize size: CGFloat) -> [NSAttributedString.Key: Any] {
        let font = UIFont(name: "HelveticaNeue-CondensedBlack", size: size)
            ?? UIFont.systemFont(ofSize: 40)
        return [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.strokeWidth: -3.0
        ]
    }
    
    func generateMemedImage() -> UIImage {
        guard let imageMeme = photoView.image,
        let topText = topTextField.text,
        let bottomText = bottomTextField.text,
        let topFontSize = topTextField.font?.pointSize,
        let bottomFontSize = bottomTextField.font?.pointSize else {
            return UIImage()
        }
        let topTextAttributes = textAttributes(fontSize: topFontSize)
        let bottomTextAttributes = textAttributes(fontSize: bottomFontSize)
        
        let topTextFieldSize = topTextField.frame.size
        
        let bottomTextFieldSize = bottomTextField.frame.size
        
        let imageViewSize = photoView.frame.size
        
        let isPortrait = imageViewSize.height > imageViewSize.width
        let aspectRatio = isPortrait ?
            (imageMeme.size.height/imageMeme.size.width)
            : (imageMeme.size.width/imageMeme.size.height)
        let smallerSide = isPortrait ? imageViewSize.width : imageViewSize.height
        
        let contextSize = CGSize(
            width: smallerSide * (isPortrait ? 1 : aspectRatio),
            height: smallerSide * (isPortrait ? aspectRatio : 1)
        )
        let topLabel = UILabel()
        topLabel.textAlignment = .center
        topLabel.attributedText = NSAttributedString(
            string: topText,
            attributes: topTextAttributes
        )
        
        let bottomLabel = UILabel()
        bottomLabel.textAlignment = .center
        bottomLabel.attributedText = NSAttributedString(
            string: bottomText,
            attributes: bottomTextAttributes
        )
        
        let actualTopSize = topLabel.sizeThatFits(topTextFieldSize)
        let actualBottomSize = bottomLabel.sizeThatFits(bottomTextFieldSize)
        
        let convertedRectTop = self.view.convert(topTextField.frame, to: photoView)
        let convertedRectBottom = self.view.convert(bottomTextField.frame, to: photoView)
        
        UIGraphicsBeginImageContextWithOptions(contextSize, false, UIScreen.main.scale)
        let topTextOnImageViewY = convertedRectTop.origin.y
        let bottomTextOnImageViewY = convertedRectBottom.origin.y
        let deltaY = (imageViewSize.height - contextSize.height)/2
        let topTextOnImageY = topTextOnImageViewY - deltaY
        let bottomTextOnImageY = bottomTextOnImageViewY - deltaY
        
        let contextRect = CGRect(origin: CGPoint.zero, size: contextSize)
        imageMeme.draw(in: contextRect)
        let topTextRect = CGRect(
            origin: CGPoint(
                x: contextRect.midX.advanced(by: -actualTopSize.width/2.0),
                y: topTextOnImageY
            ),
            size: actualTopSize
        )
        let bottomTextRect = CGRect(
            origin: CGPoint(
                x: contextRect.midX.advanced(by: -actualBottomSize.width/2.0),
                y: bottomTextOnImageY
            ),
            size: actualBottomSize
        )
        
        topText.draw(in: topTextRect, withAttributes: topTextAttributes)
        bottomText.draw(in: bottomTextRect, withAttributes: bottomTextAttributes)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
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
            self.label.isHidden = true
            self.photoView.image = image
            self.topTextField.isHidden = false
            self.bottomTextField.isHidden = false
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

