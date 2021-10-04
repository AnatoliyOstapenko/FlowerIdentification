//
//  ViewController.swift
//  FlowerIdentification
//
//  Created by MacBook on 04.10.2021.
//

import UIKit

import CoreML
import Vision

class ViewController: UIViewController {
    
    let pickerController = UIImagePickerController()
    
    
    
    @IBOutlet weak var flowerImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerController.delegate = self // delegate UIImagePickerController
        pickerController.allowsEditing = false // not allow edit image
        pickerController.sourceType = .photoLibrary // only photo library use
        
    }
    
    
    
    
    // MARK: - Identification
    func identification(_ image: UIImage) {
        
    }

    @IBAction func cameraBarButton(_ sender: UIBarButtonItem) {
        
        // activate imagePickerController
        present(pickerController, animated: true, completion: nil)
        
    }
    
}

// MARK: -

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // get an image
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        // show chosen image on the screen
        flowerImageView.image = image
        
        // dismiss picker
        pickerController.dismiss(animated: true, completion: nil)
        
        
        
    }
    
}







