//
//  ViewController.swift
//  OutfitGenerator
//
//  Created by Jason on 10/14/22.
//

import FirebaseStorage
import UIKit

class ViewController: UIViewController {
    
//    var stylesView = Styles()
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
//    override func loadView() {
//        stylesView.button.addTarget(self, action: #selector(launchCamera), for: .touchUpInside)
//
//        view = stylesView
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(
            ClothingCollectionViewCell.self,
            forCellWithReuseIdentifier: ClothingCollectionViewCell.identifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }

    @objc func launchCamera(sender: UIButton!) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    // Uploads images to Firebase Cloud Storage.
    func uploadImage(_ imageData: NSData) {
        let storageReference = Storage.storage().reference()
        
        // Each uploaded image gets a unique ID.
        let imagesReference = storageReference.child("images/\(UUID().uuidString).png")
        
        imagesReference.putData(imageData as Data, metadata: nil) { (_, error) in
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
        
        let backgroundRemoval = BackgroundRemoval()
        backgroundRemoval.removeBackground(for: image) { (segmentedImageData) in
            self.uploadImage(segmentedImageData!)
        }
    }
}

// MARK: - Collection view protocol methods

extension ViewController:
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 30
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ClothingCollectionViewCell.identifier,
            for: indexPath
        )
        cell.backgroundColor = .systemGreen // Helps visualize the collection view cells. Delete later.
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: (view.frame.size.width / 3) - 3, height: (view.frame.size.width / 3) - 3)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
