//
//  ViewControllerFaceDetection.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/06.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit
import Vision

class ViewControllerFaceDetection: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        guard let image = UIImage(named: "profile_2") else { return }
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        view.addSubview(imageView)
        imageView.fillSuperview()
        
        DispatchQueue(label: "FaceDetection", qos: .userInteractive).asyncAfter(deadline: .now() + 0.05) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.setupVisionRequest(image: image, imageView: imageView)
        }
        
    }
    
    func setupVisionRequest(image: UIImage, imageView: UIImageView) {
        let request = VNDetectFaceRectanglesRequest { [weak self] (request, error) in
            if let error = error {
                print("failed to detect faces:", error)
                self?.view.backgroundColor = .red
                return
            }
            
            request.results?.forEach { [weak self] result in
                guard let faceObservation = result as? VNFaceObservation else { return }
                
                print(faceObservation.boundingBox)
                
                self?.drawRectangleOnFace(image: image, imageView: imageView, boundingBox: faceObservation.boundingBox)
            }
        }
        guard let cgImage = image.cgImage else { return }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
        } catch let requestError {
            print("failed to perform request:", requestError)
        }
    }
    
    func drawRectangleOnFace(image: UIImage, imageView: UIImageView, boundingBox: CGRect) {
        DispatchQueue.main.async {
            
            // to draw a box on the screen use the following:
            let view = UIView()
            imageView.addSubview(view)
            view.backgroundColor = .red
            let scaledHeight = imageView.frame.width / image.size.width * image.size.height

            let translationY = imageView.center.y - scaledHeight / 2

            let width = boundingBox.width * imageView.frame.width * 1.4
            let height = boundingBox.height * scaledHeight * 1.4

            let x = boundingBox.origin.x * imageView.frame.width - width * 0.2
            let y = (1 - boundingBox.origin.y) * scaledHeight - height + translationY

            let faceBoundingRect = CGRect(x: x, y: y, width: width, height: height)
            view.frame = faceBoundingRect

            
            // to crop the image use the following:
            /*
            let width = boundingBox.width * image.size.width * 1.4
            let height = boundingBox.height * image.size.height * 1.4

            let x = boundingBox.origin.x * image.size.width - width * 0.2
            let y = (1 - boundingBox.origin.y) * image.size.height - height

            let croppingRect = CGRect(x: x, y: y, width: width, height: height)

            if let croppedCGImage = image.cgImage?.cropping(to: croppingRect) {
                let croppedImage = UIImage(cgImage: croppedCGImage)
                imageView.image = croppedImage
            }
            */
        }
    }
}
