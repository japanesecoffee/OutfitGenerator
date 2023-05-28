//
//  ClothingItemViewController.swift
//  OutfitGenerator
//
//  Created by Jason on 5/7/23.
//

import FirebaseStorage
import SDWebImage
import UIKit

class ClothingItemViewController: UIViewController {
    
    var clothingItemView = ClothingItem()

    var imageReference = Storage.storage().reference()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Back",
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        
        navigationController?.isToolbarHidden = false
        
        var toolbarItemsArray = [UIBarButtonItem]()
        toolbarItemsArray.append(
            UIBarButtonItem(
                title: "Retake",
                style: .plain,
                target: self,
                action: #selector(retakeButtonTapped)
            )
        )
        toolbarItems = toolbarItemsArray
        
        view = clothingItemView
    }
    
    // MARK: - Action methods

    @objc private func backButtonTapped() {
        guard let closetViewController = presentingViewController as? ClosetViewController else {
            return
        }

        dismiss(animated: true)
        closetViewController.collectionView.reloadData()
    }

    @objc private func retakeButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }

    // MARK: - Image saving methods

    // Replaces images in Firebase Cloud Storage.
    private func replaceImage(_ imageData: NSData) {
        imageReference.putData(imageData as Data, metadata: nil) { (_, error) in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            
            self.updateViews()
        }
    }
    
    // MARK: - View update methods
    
    // Allows the image view and collection view to show the new image.
    private func updateViews() {
        // Removes image from memory and disk cache.
        SDImageCache.shared.removeImage(forKey: imageReference.description)

        let placeholderImage = UIImage(
            systemName: "photo"
        )?.withTintColor(
            .systemGray6,
            renderingMode: .alwaysOriginal
        )

        DispatchQueue.main.async {
            self.clothingItemView.imageView.sd_setImage(
                with: self.imageReference,
                placeholderImage: placeholderImage
            )
        }
    }
}

// MARK: - Image picker controller protocol methods

extension ClothingItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true, completion: nil)

        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }

        let backgroundRemoval = BackgroundRemoval()
        backgroundRemoval.removeBackground(for: image.resize(by: 0.1)) { (segmentedImageData) in
            self.replaceImage(segmentedImageData!)
        }
    }
}
