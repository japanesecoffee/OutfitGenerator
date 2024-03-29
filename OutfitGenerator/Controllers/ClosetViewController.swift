//
//  ClosetViewController.swift
//  OutfitGenerator
//
//  Created by Jason on 10/14/22.
//

import FirebaseDatabase
import FirebaseStorage
import FirebaseStorageUI
import UIKit

class ClosetViewController: UIViewController {
    
    // MARK: - Properties
    
    private var topSectionIsExpanded = true
    private var bottomSectionIsExpanded = true
    private var shoeSectionIsExpanded = true
    
    private var topsImageReferencesArray = [String]()
    private var bottomsImageReferencesArray = [String]()
    private var shoesImageReferencesArray = [String]()
    
    private var topsDatabaseReferencesArray = [String]()
    private var bottomsDatabaseReferencesArray = [String]()
    private var shoesDatabaseReferencesArray = [String]()
    
    private var topsDatabaseHandle: UInt!
    private var bottomsDatabaseHandle: UInt!
    private var shoesDatabaseHandle: UInt!
    
    private var topsDatabaseReference: DatabaseReference!
    private var bottomsDatabaseReference: DatabaseReference!
    private var shoesDatabaseReference: DatabaseReference!
    
    private var queue = Queue<Int>()
    
    private let storageReference = Storage.storage().reference()
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: - View controller lifecycle methods

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
        
        topsDatabaseReference = Database.database().reference().child("tops")
        bottomsDatabaseReference = Database.database().reference().child("bottoms")
        shoesDatabaseReference = Database.database().reference().child("shoes")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addDatabaseListeners()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        topsDatabaseReference.removeObserver(withHandle: topsDatabaseHandle)
        bottomsDatabaseReference.removeObserver(withHandle: bottomsDatabaseHandle)
        shoesDatabaseReference.removeObserver(withHandle: shoesDatabaseHandle)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    // MARK: - Image saving methods
    
    // Uploads images to Firebase Cloud Storage.
    private func uploadImage(_ imageData: NSData) {
        // Each uploaded image gets a unique ID.
        let imagesReference = storageReference.child("images/\(UUID().uuidString).jpeg")
        
        imagesReference.putData(imageData as Data, metadata: nil) { (_, error) in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            
            self.saveImage(imagesReference.fullPath)
        }
    }
    
    // Saves image references to Firebase Realtime Database
    private func saveImage(_ reference: String) {
        if queue.peek == 0 {
            topsDatabaseReference.childByAutoId().setValue(reference)
        } else if queue.peek == 1 {
            bottomsDatabaseReference.childByAutoId().setValue(reference)
        } else {
            shoesDatabaseReference.childByAutoId().setValue(reference)
        }
        
        // Dequeues the queue after saving the reference
        queue.dequeue()
    }
    
    // MARK: - Data source methods
    
    // Clears out data source arrays and adds listeners to the tops, bottoms, and shoes nodes.
    // The listener triggers once when attached and again every time the data changes.
    private func addDatabaseListeners() {
        topsDatabaseHandle = topsDatabaseReference.observe(.value) { (snapshot) in
            self.topsImageReferencesArray = []
            self.topsDatabaseReferencesArray = []
            
            if snapshot.exists() {
                for childNode in snapshot.children.allObjects as! [DataSnapshot] {
                    // If the value is not nil, the key is not nil.
                    guard let value = childNode.value as? String else {
                        return
                    }
                    self.topsImageReferencesArray.append(value)
                    self.topsDatabaseReferencesArray.append(childNode.key)
                }
            }
            
            // Calling reloadData() instead of reloadSections(_:) to prevent invalid batch updates.
            // Firebase Database callbacks are invoked on the main thread, so
            // DispatchQueue.main.async is not needed.
            self.collectionView.reloadData()
        }
        
        bottomsDatabaseHandle = bottomsDatabaseReference.observe(.value) { (snapshot) in
            self.bottomsImageReferencesArray = []
            self.bottomsDatabaseReferencesArray = []
            
            if snapshot.exists() {
                for childNode in snapshot.children.allObjects as! [DataSnapshot] {
                    guard let value = childNode.value as? String else {
                        return
                    }
                    self.bottomsImageReferencesArray.append(value)
                    self.bottomsDatabaseReferencesArray.append(childNode.key)
                }
            }
            
            self.collectionView.reloadData()
        }
        
        shoesDatabaseHandle = shoesDatabaseReference.observe(.value) { (snapshot) in
            self.shoesImageReferencesArray = []
            self.shoesDatabaseReferencesArray = []
            
            if snapshot.exists() {
                for childNode in snapshot.children.allObjects as! [DataSnapshot] {
                    guard let value = childNode.value as? String else {
                        return
                    }
                    self.shoesImageReferencesArray.append(value)
                    self.shoesDatabaseReferencesArray.append(childNode.key)
                }
            }
            
            self.collectionView.reloadData()
        }
    }
}

// MARK: - Image picker controller protocol methods

extension ClosetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
        backgroundRemoval.removeBackground(for: image.resize(by: 0.1)) { (segmentedImageData) in
            self.uploadImage(segmentedImageData!)
        }
    }
}

// MARK: - Collection view protocol methods

extension ClosetViewController:
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
        
        let imageReference: StorageReference
        let databaseReference: DatabaseReference
        
        if indexPath.section == 0 {
            imageReference = storageReference.child(topsImageReferencesArray[indexPath.row])
            databaseReference = topsDatabaseReference.child(topsDatabaseReferencesArray[indexPath.row])
        } else if indexPath.section == 1 {
            imageReference = storageReference.child(bottomsImageReferencesArray[indexPath.row])
            databaseReference = bottomsDatabaseReference.child(bottomsDatabaseReferencesArray[indexPath.row])
        } else {
            imageReference = storageReference.child(shoesImageReferencesArray[indexPath.row])
            databaseReference = shoesDatabaseReference.child(shoesDatabaseReferencesArray[indexPath.row])
        }
        
        let placeholderImage = UIImage(
            systemName: "photo"
        )?.withTintColor(
            .systemGray6,
            renderingMode: .alwaysOriginal
        )
        
        let clothingItemViewController = ClothingItemViewController()
        clothingItemViewController.clothingItemView.imageView.sd_setImage(
            with: imageReference,
            placeholderImage: placeholderImage
        )
        clothingItemViewController.imageReference = imageReference
        clothingItemViewController.databaseReference = databaseReference
        
        let navigationController = UINavigationController(
            rootViewController: clothingItemViewController
        )
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
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

extension ClosetViewController: HeaderDelegate {
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
