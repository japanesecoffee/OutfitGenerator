//
//  ViewController.swift
//  OutfitGenerator
//
//  Created by Jason on 10/14/22.
//

import FirebaseDatabase
import FirebaseStorage
import FirebaseStorageUI
import UIKit

class ViewController: UIViewController {
    
    private var topSectionIsExpanded = true
    private var bottomSectionIsExpanded = true
    private var shoeSectionIsExpanded = true
    
    private var topsImageReferencesArray = [String]()
    private var bottomsImageReferencesArray = [String]()
    private var shoesImageReferencesArray = [String]()
    
    private var queue = Queue<Int>()
    
    private let databaseReference = Database.database().reference()
    private let storageReference = Storage.storage().reference()
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(
            ClothingCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ClothingCollectionReusableView.identifier
        )
        collectionView.register(
            ClothingCollectionViewCell.self,
            forCellWithReuseIdentifier: ClothingCollectionViewCell.identifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        addDatabaseListeners()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    // Uploads images to Firebase Cloud Storage.
    func uploadImage(_ imageData: NSData) {
        // Each uploaded image gets a unique ID.
        let imagesReference = storageReference.child("images/\(UUID().uuidString).png")
        
        imagesReference.putData(imageData as Data, metadata: nil) { (_, error) in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            
            self.saveImage(imagesReference.fullPath)
        }
    }
    
    // Saves image references to Firebase Realtime Database
    func saveImage(_ reference: String) {
        if queue.peek == 0 {
            databaseReference.child("tops").childByAutoId().setValue(reference)
        } else if queue.peek == 1 {
            databaseReference.child("bottoms").childByAutoId().setValue(reference)
        } else {
            databaseReference.child("shoes").childByAutoId().setValue(reference)
        }
        
        // Dequeues the queue after saving the reference
        queue.dequeue()
    }
    
    // Adds listeners to the tops, bottoms, and shoes nodes.
    // The listener triggers once when attached and again every time the data changes.
    private func addDatabaseListeners() {
        databaseReference.child("tops").observe(DataEventType.childAdded) { (snapshot) in
            guard let value = snapshot.value as? String else {
                return
            }
            self.topsImageReferencesArray.append(value)
            
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
        
        databaseReference.child("bottoms").observe(DataEventType.childAdded) { (snapshot) in
            guard let value = snapshot.value as? String else {
                return
            }
            self.bottomsImageReferencesArray.append(value)
            
            self.collectionView.reloadSections(IndexSet(integer: 1))
        }
        
        databaseReference.child("shoes").observe(DataEventType.childAdded) { (snapshot) in
            guard let value = snapshot.value as? String else {
                return
            }
            self.shoesImageReferencesArray.append(value)
            
            self.collectionView.reloadSections(IndexSet(integer: 2))
        }
    }
}

// MARK: - Image picker controller protocol methods

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
        // Dequeues the queue when the user cancels out of the camera
        queue.dequeue()
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        let numberOfItems: Int

        if section == 0 {
            numberOfItems = topSectionIsExpanded ? topsImageReferencesArray.count : 0
        } else if section == 1 {
            numberOfItems = bottomSectionIsExpanded ? bottomsImageReferencesArray.count : 0
        } else {
            numberOfItems = shoeSectionIsExpanded ? shoesImageReferencesArray.count : 0
        }

        return numberOfItems
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ClothingCollectionViewCell.identifier,
            for: indexPath
        ) as! ClothingCollectionViewCell
        
        let imageReference: StorageReference
        
        if indexPath.section == 0 {
            imageReference = storageReference.child(topsImageReferencesArray[indexPath.row])
        } else if indexPath.section == 1 {
            imageReference = storageReference.child(bottomsImageReferencesArray[indexPath.row])
        } else {
            imageReference = storageReference.child(shoesImageReferencesArray[indexPath.row])
        }
        
        let placeholderImage = UIImage(
            systemName: "photo"
        )?.withTintColor(
            .systemGray6,
            renderingMode: .alwaysOriginal
        )

        cell.imageView.sd_setImage(with: imageReference, placeholderImage: placeholderImage)
        
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
    
    // Methods for header.
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ClothingCollectionReusableView.identifier,
            for: indexPath
        ) as! ClothingCollectionReusableView
        
        header.delegate = self
        header.addButton.tag = indexPath.section
        header.toggleButton.tag = indexPath.section
        
        if indexPath.section == 0 {
            header.addButton.setTitle("Tops +", for: .normal)
            // Sections are expanded by default. If a section collapses, the button is selected.
            header.toggleButton.isSelected = topSectionIsExpanded ? false : true
        } else if indexPath.section == 1 {
            header.addButton.setTitle("Bottoms +", for: .normal)
            header.toggleButton.isSelected = bottomSectionIsExpanded ? false : true
        } else {
            header.addButton.setTitle("Shoes +", for: .normal)
            header.toggleButton.isSelected = shoeSectionIsExpanded ? false : true
        }
        
        return header
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: view.frame.size.width, height: view.frame.size.width / 9)
    }
}

// MARK: - Header protocol methods

extension ViewController: HeaderDelegate {
    func launchCamera(inSection: Int) {
        // Using a queue to track which node each image reference gets saved to
        // A global variable does not work here because launchCamera(inSection:) may be called again
        // before saveImage(_:) executes, changing the variable before it can be used in saveImage(_:)
        queue.enqueue(inSection)
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func toggleNumberOfItems(inSection: Int) {
        if inSection == 0 {
            topSectionIsExpanded = !topSectionIsExpanded
        } else if inSection == 1 {
            bottomSectionIsExpanded = !bottomSectionIsExpanded
        } else {
            shoeSectionIsExpanded = !shoeSectionIsExpanded
        }

        collectionView.reloadSections(IndexSet(integer: inSection))
    }
}
