//
//  MemeViewController.swift
//  Meme
//
//  Created by Anastasia Petrova on 17/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit
import MobileCoreServices

final class MemeEditorViewController: UIViewController {
    let toolBar = UIToolbar(
        //This is a workaround for [apparently] UIToolbar bug where it breaks
        //contraints of private subviews (e.g. _UIModernBarButton: centerY)
        //https://forums.developer.apple.com/thread/121474
        frame: CGRect(origin: .zero, size: CGSize(width: 320, height: 44))
    )
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
    var meme: MemeModel?
    var keyboardHeight: CGFloat = 0.0
    let newMemeAddedCallback: () -> Void
    
    init(callback: @escaping () -> Void) {
        newMemeAddedCallback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.delegate = self
        bottomTextField.delegate = self
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        view.addSubview(photoView)
        view.addSubview(toolBar)
        
        setUpNavigationBar()
        setUpImageView()
        setUpToolBar()
        setUpTextFields()
        setUpPickImageLabel()
        setDefaultValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        topTextFieldTopConstraint.constant = countTextFieldsConstants().top
        bottomTextFieldBottomConstraint.constant = countTextFieldsConstants().bottom
        topTextFieldLeadingConstraint.constant = calculateHorizontalTextFieldOffset()
        topTextFieldTrailingConstraint.constant = calculateHorizontalTextFieldOffset()
        bottomTextFieldLeadingConstraint.constant = calculateHorizontalTextFieldOffset()
        bottomTextFieldTrailingConstraint.constant = calculateHorizontalTextFieldOffset()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsudcribeFromKeyboardNotifications()
    }
    
    func setDefaultValues() {
        self.label.isHidden = false
        topTextField.isHidden = true
        bottomTextField.isHidden = true
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        navigationItem.leftBarButtonItem?.isEnabled = false
    }
    
    private func setUpNavigationBar() {
        let actionItem = UIBarButtonItem(barButtonSystemItem: .action, target: self,  action: #selector(openActivityView))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
        navigationItem.leftBarButtonItem = actionItem
        navigationItem.rightBarButtonItem = cancelItem
    }
    
    private func setUpToolBar() {
        NSLayoutConstraint.activate([
            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: 44)
        ])
        cameraButton.image = UIImage(systemName: "camera.fill")
        cameraButton.style = .plain
        cameraButton.target = self
        cameraButton.action = #selector(openCamera)
        let albumButton = UIBarButtonItem(
            title: "Album",
            style: .plain,
            target: self,
            action: #selector(openPhotoLibrary)
        )
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let flexibleSpace2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let flexibleSpace3 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let items = [
            flexibleSpace2,
            cameraButton,
            flexibleSpace,
            albumButton,
            flexibleSpace3
        ]
        
        toolBar.setItems(items, animated: false)
    }
    
    private func setUpImageView() {
        photoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoView.bottomAnchor.constraint(equalTo: toolBar.topAnchor),
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
        
        topTextFieldTopConstraint = topTextField.topAnchor.constraint(
            equalTo: photoView.topAnchor,
            constant: 16
        )
        topTextFieldLeadingConstraint = topTextField.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 16
        )
        topTextFieldTrailingConstraint = view.trailingAnchor.constraint(
            equalTo: topTextField.trailingAnchor,
            constant: 16
        )
        bottomTextFieldLeadingConstraint = bottomTextField.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 16
        )
        bottomTextFieldTrailingConstraint = view.trailingAnchor.constraint(
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
        topTextField.isUserInteractionEnabled = false
        topTextField.adjustsFontSizeToFitWidth = true
        topTextField.minimumFontSize = 12
        topTextField.autocapitalizationType = .allCharacters
        bottomTextField.borderStyle = .none
        bottomTextField.autocapitalizationType = .allCharacters
        bottomTextField.isUserInteractionEnabled = false
        bottomTextField.adjustsFontSizeToFitWidth = true
        
        topTextField.defaultTextAttributes = memeTextAttributes(fontSize: 40)
        bottomTextField.defaultTextAttributes = memeTextAttributes(fontSize: 40)
        
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
    }
    
    func memeTextAttributes(fontSize size: CGFloat) -> [NSAttributedString.Key: Any] {
        let font = UIFont(name: "HelveticaNeue-CondensedBlack", size: size)
            ?? UIFont.systemFont(ofSize: size)
        return [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.strokeWidth: -3.0
        ]
    }
    
    func calculateContextSize(image: UIImage) -> CGSize {
        let imageViewSize = photoView.frame.size
        let aspectRatio = image.aspectRatio(isPortrait: isPortrait)
        let smallerSide = isPortrait ? imageViewSize.width : imageViewSize.height
        return CGSize(
            width: smallerSide * (isPortrait ? 1 : aspectRatio),
            height: smallerSide * (isPortrait ? aspectRatio : 1)
        )
    }
    
    func countTextFieldsConstants() -> (top: CGFloat, bottom: CGFloat) {
        var topConstant: CGFloat = 0.0
        var bottomConstant: CGFloat = 0.0
        guard let image = photoView.image else { return (topConstant, bottomConstant)}
        
        let keyboardOffset = max(0, keyboardHeight - view.safeAreaInsets.bottom)
        if isPortrait {
            let imageViewHeight = photoView.frame.height
            let contextSize = calculateContextSize(image: image)
            topConstant = ((imageViewHeight - contextSize.height) / 2 + 16)
            let baseOffset = max((imageViewHeight - contextSize.height) / 2, keyboardOffset)
            bottomConstant = baseOffset + 16
        } else {
            topConstant = 16
            bottomConstant = 16 + keyboardOffset
        }
        return (topConstant, bottomConstant)
    }
    
    func calculateHorizontalTextFieldOffset() -> CGFloat {
        guard let image = photoView.image else { return 0.0 }
        let contextSize = calculateContextSize(image: image)
        return isPortrait ? 16 : ((photoView.frame.width - contextSize.width) / 2 + 16)
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
        self.dismiss(animated: true, completion: nil)
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
                //device with a keyboard visible. In which case viewDidLayoutSubviews is
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
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsudcribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func save() {
        let memedImage = generateMemedImage()
        let date = Date()
        let id = UUID()
        try? ImageStorage.saveImage(image: memedImage, id: id)
        meme = MemeModel(
            id: id,
            topText: topTextField.text!,
            bottomText: bottomTextField.text!,
            date: date
        )
        guard let meme = meme else {
            return
        }
        var memes: [MemeModel] = []
        let existingMemes = (try? MemesStorage.loadMemes()) ?? []
        memes.append(contentsOf: existingMemes)
        memes.append(meme)
        do {
            try MemesStorage.save(memes: memes)
            newMemeAddedCallback()
        } catch {
            //FIX ME
            print(error)
        }
    }
    
    func calculateLabelSize(for text: String, thatFits size: CGSize, attributes: [NSAttributedString.Key : Any]) -> CGSize {
        let label = UILabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString(
            string: text,
            attributes: attributes
        )
        return label.sizeThatFits(size)
    }
    
    func generateMemedImage() -> UIImage {
        // Step 1
        let renderingData = prepareRenderingData()!
        // Step 2
        let finalImage = drawImage(with: renderingData)! //FIXME: remove optionality
        return finalImage
    }
    
    func prepareRenderingData() -> RenderingData? {
        guard let image = photoView.image,
            let topText = topTextField.text,
            let bottomText = bottomTextField.text,
            let topFontSize = topTextField.font?.pointSize,
            let bottomFontSize = bottomTextField.font?.pointSize else {
                return nil
        }
        
        let contextSize = calculateContextSize(image: image)
        let contextRect = CGRect(origin: CGPoint.zero, size: contextSize)
        
        return RenderingData(
            contextRect: contextRect,
            image: image,
            topText: topText,
            bottomText: bottomText,
            topTextRect: prepareTextRect(contextRect: contextRect, textField: topTextField),
            bottomTextRect: prepareTextRect(contextRect: contextRect, textField: bottomTextField),
            topTextAttributes: memeTextAttributes(fontSize: topFontSize),
            bottomTextAttributes: memeTextAttributes(fontSize: bottomFontSize)
        )
    }
    
    var isPortrait: Bool {
        return view.frame.height > view.frame.width
    }
    
    func prepareTextRect(contextRect: CGRect, textField: UITextField) -> CGRect {
        guard let text = textField.text,
            let fontSize = textField.font?.pointSize else {
            return .zero
        }
        
        let imageViewSize = photoView.frame.size
        let convertedFrame = view.convert(textField.frame, to: photoView)
        let deltaY = (imageViewSize.height - contextRect.size.height)/2
        
        let actualSize = calculateLabelSize(
            for: text,
            thatFits: textField.frame.size,
            attributes: memeTextAttributes(fontSize: fontSize)
        )
        
        return CGRect(
            origin: CGPoint(
                x: contextRect.midX.advanced(by: -actualSize.width/2.0),
                y: convertedFrame.origin.y - deltaY
            ),
            size: actualSize
        )
    }
    
    func drawImage(with data: RenderingData) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(data.contextRect.size, false, UIScreen.main.scale)
        
        data.image.draw(in: data.contextRect)
        data.topText.draw(in: data.topTextRect, withAttributes: data.topTextAttributes)
        data.bottomText.draw(in: data.bottomTextRect, withAttributes: data.bottomTextAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
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
        switch curve {
        case .easeInOut: return .curveEaseInOut
        case .easeIn: return .curveEaseIn
        case .easeOut: return .curveEaseOut
        case .linear: return .curveLinear
        @unknown default: return .curveLinear
        }
    }
}

extension MemeEditorViewController {
    struct RenderingData {
        let contextRect: CGRect
        let image: UIImage
        let topText: String
        let bottomText: String
        let topTextRect: CGRect
        let bottomTextRect: CGRect
        let topTextAttributes: [NSAttributedString.Key : Any]
        let bottomTextAttributes: [NSAttributedString.Key : Any]
    }
}

extension UIImage {
    func aspectRatio(isPortrait: Bool) -> CGFloat {
        let dividend = isPortrait ? size.height : size.width
        let denominator = isPortrait ? size.width : size.height
        guard denominator > 0 else {
            return 0
        }
        return dividend/denominator
    }
}
