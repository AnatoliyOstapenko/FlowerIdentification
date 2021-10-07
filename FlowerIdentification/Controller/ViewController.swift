//
//  ViewController.swift
//  FlowerIdentification
//
//  Created by MacBook on 04.10.2021.
//

import UIKit

import CoreML
import Vision

import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    let pickerController = UIImagePickerController()
    
    //
    let urlWiki = "https://en.wikipedia.org/w/api.php"
    
    
    
    @IBOutlet weak var flowerImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerController.delegate = self // delegate UIImagePickerController
        pickerController.allowsEditing = false // not allow edit image
        pickerController.sourceType = .photoLibrary // only photo library use
        
    }

    @IBAction func cameraBarButton(_ sender: UIBarButtonItem) {
        
        // activate imagePickerController
        present(pickerController, animated: true, completion: nil)
        
    }
    
    // MARK: - Identification
    func identification(_ image: UIImage) {
        
        // convert image to ciimage
        guard let ciImage = CIImage(image: image) else { return }
        
        // get model
        guard let model = try? VNCoreMLModel(for: FlowerClassifier(configuration: MLModelConfiguration()).model) else { return }
        
        // add request
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            // get all results
            guard let results = request.results as? [VNClassificationObservation] else { return }
            // get first, most confident result
            guard let first = results.first?.identifier else { return }
            
            // show first as a title
            self.navigationItem.title = first
            self.request(first)
        }
        
        // create handler for ciImage
        let handler = VNImageRequestHandler(ciImage: ciImage)
        
        // perform Vision
        do {
            try handler.perform([request])
        } catch { print(error)}
    }
    
    // Alamofire - SwiftyJSON shit stuff
    func request(_ flowerName: String) {
        
        // create parameters
        let parameters: [String: String] = [
            
            "format": "json",
            "action": "query",
            "prop": "extracts",
            "explaintext": "",
            "titles": flowerName,
            "indexpagesids": "",
            "redirects": "1"

        ]
        
        
        AF.request(urlWiki, method: .get, parameters: parameters).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print("operation with wiki succeed")
                print(response)
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // get an image
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        // show chosen image on the screen
        flowerImageView.image = image
        
        // dispatch image to identificate
        identification(image)
        
        // dismiss picker
        pickerController.dismiss(animated: true, completion: nil)
        
        
        
    }
    
}







