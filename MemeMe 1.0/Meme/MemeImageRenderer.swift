//
//  MemeImageRenderer.swift
//  Meme
//
//  Created by Anastasia Petrova on 08/03/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

struct MemeImageRenderer {
    let isPortrait: Bool
    let photoView: UIImageView
    let view: UIView
    let topTextField: UITextField
    let bottomTextField: UITextField
    
    func generateMemedImage() -> UIImage? {
        guard let renderingData = prepareRenderingData(),
            let finalImage = drawImage(with: renderingData) else {
            return nil
        }
        return finalImage
    }
    
    private func prepareRenderingData() -> RenderingData? {
        guard let image = photoView.image,
            let topFontSize = topTextField.font?.pointSize,
            let bottomFontSize = bottomTextField.font?.pointSize else {
                return nil
        }
        
        let topText = topTextField.text ?? ""
        let bottomText = bottomTextField.text ?? ""
        let contextSize = calculateContextSize(image: image)
        let contextRect = CGRect(origin: CGPoint.zero, size: contextSize)
        
        return RenderingData(
            contextRect: contextRect,
            image: image,
            topText: topText,
            bottomText: bottomText,
            topTextRect: prepareTextRect(contextRect: contextRect, textField: topTextField),
            bottomTextRect: prepareTextRect(contextRect: contextRect, textField: bottomTextField),
            topTextAttributes: textAttributes(for: topFontSize),
            bottomTextAttributes: textAttributes(for: bottomFontSize)
        )
    }
    
    private func calculateContextSize(image: UIImage) -> CGSize {
        let imageViewSize = photoView.frame.size
        let aspectRatio = image.aspectRatio(isPortrait: isPortrait)
        let smallerSide = isPortrait ? imageViewSize.width : imageViewSize.height
        return CGSize(
            width: smallerSide * (isPortrait ? 1 : aspectRatio),
            height: smallerSide * (isPortrait ? aspectRatio : 1)
        )
    }
    
    private func prepareTextRect(contextRect: CGRect, textField: UITextField) -> CGRect {
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
            attributes: textAttributes(for: fontSize)
        )
        
        return CGRect(
            origin: CGPoint(
                x: contextRect.midX.advanced(by: -actualSize.width/2.0),
                y: convertedFrame.origin.y - deltaY
            ),
            size: actualSize
        )
    }
    
    private func textAttributes(for size: CGFloat) -> [NSAttributedString.Key: Any] {
        let font = UIFont(name: "HelveticaNeue-CondensedBlack", size: size)
            ?? UIFont.systemFont(ofSize: size)
        return [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.strokeWidth: -3.0
        ]
    }
    
    private func calculateLabelSize(for text: String, thatFits size: CGSize, attributes: [NSAttributedString.Key : Any]) -> CGSize {
        let label = UILabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString(
            string: text,
            attributes: attributes
        )
        return label.sizeThatFits(size)
    }
    
    private func drawImage(with data: RenderingData) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(data.contextRect.size, false, UIScreen.main.scale)
        
        data.image.draw(in: data.contextRect)
        data.topText.draw(in: data.topTextRect, withAttributes: data.topTextAttributes)
        data.bottomText.draw(in: data.bottomTextRect, withAttributes: data.bottomTextAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension MemeImageRenderer {
    private struct RenderingData {
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
