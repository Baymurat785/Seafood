//
//  ViewController.swift
//  SeaFood
//
//  Created by Baymurat Abdumuratov on 21/02/24.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
    }
    
    
    
    //It's called when the user finishes picking media with the image picker.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            //here we will captured image, and replace it with the empty imageView
            imageView.image = userPickedImage
            
            
            //CIImage is specialized for image processing tasks using Core Image
            guard let ciimage = CIImage(image: userPickedImage) else{
                fatalError("Coudl not convert UIImage into CIImage")
            }
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true)
    }

    
    
    func detect(image: CIImage){
        
        // Loading Core ML model
        guard let model = try? VNCoreMLModel(for: MLModel(contentsOf: Inceptionv3.urlOfModelInThisBundle)) else{
            fatalError("Can't load ML model")
        }
        
        
        
        // Creating a request to run the model
        let request = VNCoreMLRequest(model: model) { request , error in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("Model failed to process the image")
            }
            
        
            print(results)
            if let firstResult = results.first{
                if firstResult.identifier.contains("hotdog"){
                    self.navigationItem.title = "hotdog"
                }else{
                    self.navigationItem.title = "not hotdog"
                }
            }
        }
        
        
        //VNImageRequestHandler is a class provided by the Vision framework in iOS. It is used to process images through the Vision framework
        let handler = VNImageRequestHandler(ciImage: image)
        do{
            try! handler.perform([request])
        }catch{
            print(error)
        }
    }
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true)
        
    }
    
}

