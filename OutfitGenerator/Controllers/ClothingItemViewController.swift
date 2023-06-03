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
    
    private let placeholderImage = UIImage(
        systemName: "photo"
    )?.withTintColor(
        .systemGray6,
        renderingMode: .alwaysOriginal
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance

        let backButtonConfiguration = UIImage.SymbolConfiguration(weight: .bold)
        let backButtonImage = UIImage(
            systemName: "chevron.left",
            withConfiguration: backButtonConfiguration
        )?.withTintColor(
            .systemGreen,
            renderingMode: .alwaysOriginal
        )
        let backButton = UIButton(type: .system)
        backButton.setImage(backButtonImage, for: .normal)
        backButton.setTitle(" Back", for: .normal)
        backButton.setTitleColor(.systemGreen, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        let toolbarAppearance = UIToolbarAppearance()
        toolbarAppearance.configureWithDefaultBackground()
        navigationController?.toolbar.standardAppearance = toolbarAppearance
        navigationController?.toolbar.scrollEdgeAppearance = toolbarAppearance
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
        dismiss(animated: true)
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

        DispatchQueue.main.async {
            self.clothingItemView.imageView.sd_setImage(
                with: self.imageReference,
                placeholderImage: self.placeholderImage
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
        
        // Shows a placeholder image while the new image gets processed and uploaded.
        clothingItemView.imageView.sd_setImage(with: nil, placeholderImage: placeholderImage)

        let backgroundRemoval = BackgroundRemoval()
        backgroundRemoval.removeBackground(for: image.resize(by: 0.1)) { (segmentedImageData) in
            self.replaceImage(segmentedImageData!)
        }
    }
}
