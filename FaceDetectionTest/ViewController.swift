//
//  ViewController.swift
//  FaceDetectionTest
//
//  Created by Bizet Rodriguez-Velez on 5/28/19.
//  Copyright © 2019 Bizet Rodriguez-Velez. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = UIImage(named: "three_faces") else { fatalError() }
        let imageView = UIImageView(image: image)
        
        imageView.contentMode = .scaleAspectFit
        
        let scaledHeight = view.frame.width / image.size.width * image.size.height
        
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: scaledHeight)
        
        
        view.addSubview(imageView)
        
        let request = VNDetectFaceRectanglesRequest { (request, error) in
            if error != nil {
                fatalError(error?.localizedDescription ?? "Request failed")
            }
            
            
            request.results?.forEach({ (res) in
                
                DispatchQueue.main.async {
                    guard let faceObservation = res as? VNFaceObservation else { fatalError() }
                    let redView = UIView()
                    redView.backgroundColor = .red
                    
                    
                    let width = self.view.frame.width * faceObservation.boundingBox.width
                    let height = scaledHeight * faceObservation.boundingBox.height
                    
                    let y = scaledHeight * ( 1 - faceObservation.boundingBox.origin.y) - height
                    let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                    
                    redView.frame = CGRect(x: x, y: y, width: width, height: height)
                    redView.alpha = 0.4
                    self.view.addSubview(redView)
                }
                
            })
        }
        
        guard let cgImage = image.cgImage else { fatalError() }

        DispatchQueue.global(qos: .background).async {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
        
    }

    // New Comment
}

