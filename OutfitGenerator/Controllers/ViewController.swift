//
//  ViewController.swift
//  OutfitGenerator
//
//  Created by Jason on 10/14/22.
//

import FirebaseStorage
import UIKit

class ViewController: UIViewController {
    
    var stylesView = Styles()
    
    override func loadView() {
        stylesView.button.addTarget(self, action: #selector(launchCamera), for: .touchUpInside)
        
        view = stylesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @objc func launchCamera(sender: UIButton!) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    // Uploads images to Firebase Cloud Storage.
    func uploadImage(_ image: UIImage) {
        let storageReference = Storage.storage().reference()
        
        guard let imageData = image.pngData() else {
            return
        }
        
        // Each uploaded image gets a unique ID.
        let imagesReference = storageReference.child("images/\(UUID().uuidString).png")
        
        imagesReference.putData(imageData, metadata: nil) { (_, error) in
            guard error == nil else {
                print("Failed to upload")
                return
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate and UINavigationControllerDelegate methods

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        picker.dismiss(animated: true, completion: nil)

        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        uploadImage(image)
    }
}
