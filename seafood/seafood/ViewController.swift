//
//  ViewController.swift
//  seafood
//
//  Created by Chiranjeevi Saride on 3/24/18.
//  Copyright © 2018 Chiranjeevi Saride. All rights reserved.
//

import UIKit
import VisualRecognitionV3
import SVProgressHUD
import Social

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var topBarImageView: UIImageView!
    
    let imagePicker  = UIImagePickerController()
    var classificationResults : [String] = []

    let apiKey = "220fee0aaa72a942df5a33478bfd0e59155b40ca"
    let version = "2017-05-19"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        shareButton.isHidden = true
       
        setNavBarProps()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        cameraButton.isEnabled = false
        SVProgressHUD.show()
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageView.image = image
            self.topBarImageView.image = nil
            setNavBarProps()
            
            imagePicker.dismiss(animated: true, completion: nil)
            
            let visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
    
            
            let failue = {(error: Error) in print(error)}
            
            
            visualRecognition.classify(image: image, failure: failue) { classifiedImages in
               let classes = classifiedImages.images.first!.classifiers.first!.classes
                self.classificationResults = []
                
                
                for index in 0..<classes.count {
                    let classResult = classes[index]
                    self.classificationResults.append(classResult.className)
                }
                
                
                DispatchQueue.main.async {
                    self.cameraButton.isEnabled = true
                    SVProgressHUD.dismiss()
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Arial", size: 35) as Any, NSAttributedStringKey.foregroundColor: UIColor.yellow]
                }
                
                if self.classificationResults.contains("hotdog") {
                    DispatchQueue.main.sync {
                        self.navigationItem.title = "Hotdog!"
                        self.navigationController?.navigationBar.barTintColor = UIColor.green
                        self.navigationController?.navigationBar.isTranslucent = false
                        self.topBarImageView.image = UIImage(named: "hotdog")
                    }
                } else {
                    DispatchQueue.main.sync {
                         self.navigationItem.title = "Not Hotdog!"
                         self.navigationController?.navigationBar.barTintColor = UIColor.red
                         self.navigationController?.navigationBar.isTranslucent = false
                        self.topBarImageView.image = UIImage(named: "not-hotdog")
                    }
                }
            }
            
        } else {
            print("Error picking the Image")
        }
    }
    
   
    func setNavBarProps(){
        self.navigationController?.navigationBar.topItem?.title = "SEE FOOD"
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Arial", size: 35) as Any, NSAttributedStringKey.foregroundColor: UIColor.brown]
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = nil
    }
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        print("Camera Tapped")
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func sharePressed(_ sender: Any) {
            print("Share Pressed")
        
    }
    
}

