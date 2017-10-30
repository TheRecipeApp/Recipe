//
//  ProfileViewController.swift
//  RecipeApp
//
//  Created by Cesar Cavazos on 10/15/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Parse
import iCarousel

class ProfileViewController: UIViewController {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var displayScreen: UILabel!
    @IBOutlet var recipiesCountLabel: UILabel!
    @IBOutlet var complimentsCountLabel: UILabel!
    @IBOutlet var followersCountLabel: UILabel!
    @IBOutlet var cookbooksCountLabel: UILabel!
    @IBOutlet var noRecipiesLabel: UILabel!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var updateProfilePicture: UIButton!
    @IBOutlet var rightNavButton: UIBarButtonItem!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var recipiesCollectionView: UICollectionView!
    @IBOutlet var cookbooksCollectionView: UICollectionView!
    
    var recipies: [Recipe] = []
    var allCookbooks: [Cookbook] = []
    var filteredCookbooks: [Cookbook] = []
    var showAllCookbooks = true
    var userId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipiesCollectionView.register(UINib(nibName: "RecipeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecipeCollectionViewCell")
        recipiesCollectionView.dataSource = self
        recipiesCollectionView.delegate = self
        
        cookbooksCollectionView.dataSource = self
        cookbooksCollectionView.delegate = self
        
        if view.traitCollection.forceTouchCapability == .available {
            print("Force touch is enabled for this device")
            registerForPreviewing(with: self, sourceView: self.recipiesCollectionView)
            registerForPreviewing(with: self, sourceView: self.cookbooksCollectionView)
        }
        
        print("Profile User Id: \(userId ?? "nil")")
        if userId == nil {
            print("Using current user")
            userId = User.current()?.objectId
        }
        // If this is not the current user hide some actions
        if userId != User.current()?.objectId {
            print("This is another user")
            logoutButton.isHidden = true
            rightNavButton.title = ""
            rightNavButton.isEnabled = false
            updateProfilePicture.isEnabled = false
            updateProfilePicture.isHidden = true
        } else {
            print("This is the current user")
        }
        
        let userObject = User.fetchUser(by: userId!)
        populateUser(user: userObject!)
        
        let userImage = userObject?.profileImage
        if userImage != nil {
            userImage?.getDataInBackground(block: { (imageData: Data?, error: Error?) in
                if error == nil {
                    if let imageData = imageData {
                        self.displayProfilePicture(image: UIImage(data: imageData)!)
                    }
                }
            })
        }
        
        fetchTopRecipes(ownerId: userObject!.objectId!)
        
        for i in 1...10 {
            let cookbook = Cookbook()
            cookbook.name = "Summer BBQ"
            if i % 2 == 0 {
                cookbook.owner = userObject!
            }
            cookbook.likesAggregate = 150
            allCookbooks.append(cookbook)
            filteredCookbooks.append(cookbook)
        }
        cookbooksCollectionView.reloadData()
    }
    
    func fetchTopRecipes(ownerId: String) {
        let query = PFQuery(className: "Recipe")
        query.order(byDescending: "likes")
        query.limit = 5
        query.whereKey("owner", equalTo: ownerId)
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                // Recipies found
                print("Successfully retrieved \(objects!.count) recipes.")
                self.recipies = objects as! [Recipe]
                if self.recipies.count > 0 {
                    self.noRecipiesLabel.isHidden = true
                    self.recipiesCollectionView.isHidden = false
                    self.recipiesCollectionView.reloadData()
                } else {
                    self.noRecipiesLabel.isHidden = false
                    self.recipiesCollectionView.isHidden = true
                }
            }
        })
    }
    
    func populateUser(user: User) {
        displayScreen.text = "@\(user.username ?? "username")"
        recipiesCountLabel.text = "12"
        complimentsCountLabel.text = "1000"
        followersCountLabel.text = "188"
        cookbooksCountLabel.text = "12"
        if user.firstName == nil {
            if user.lastName == nil {
                nameLabel.text = "@\(user.username!)"
            } else {
                nameLabel.text = "\(user.lastName!)"
            }
        } else {
            if user.lastName == nil {
                nameLabel.text = "\(user.firstName!)"
            } else {
                nameLabel.text = "\(user.firstName!) \(user.lastName!)"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showPhotoPicker(type: UIImagePickerControllerSourceType) {
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        imagePickerViewController.allowsEditing = true
        imagePickerViewController.sourceType = type
        present(imagePickerViewController, animated: true, completion: nil)
    }
    
    func displayProfilePicture(image: UIImage) {
        
        let resizeRenderImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        resizeRenderImageView.layer.cornerRadius = 60
        resizeRenderImageView.layer.borderColor = UIColor.white.cgColor
        resizeRenderImageView.layer.borderWidth = 1.0
        resizeRenderImageView.contentMode = .scaleAspectFit
        resizeRenderImageView.image = image
        
        UIGraphicsBeginImageContext(resizeRenderImageView.frame.size)
        resizeRenderImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        profileImageView.layer.cornerRadius = 60
        profileImageView.image = thumbnail
        profileImageView.clipsToBounds = true
        profileImageView.isHidden = false
        // TODO: Add a little animation to show the profile picture
    }
    
    func saveProfilePicture(image: UIImage) {
        let imageFile = PFFile(data: UIImagePNGRepresentation(image)!)
        imageFile?.saveInBackground()
        let currentUser = PFUser.current()
        currentUser?["profileImage"] = imageFile
        currentUser?.saveInBackground()
    }
    
    func recipeTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let recipeDetailVC = storyboard.instantiateViewController(withIdentifier: "RecipeViewController") as! RecipeViewController
        let recipeView = tapGestureRecognizer.view as! RecipeBlockView
        recipeDetailVC.recipeId = recipeView.recipeId
        self.navigationController?.pushViewController(recipeDetailVC, animated: true)
    }
    
    @IBAction func onClose(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onLogout(_ sender: UIButton) {
        PFUser.logOut()
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! UINavigationController
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func onFilterChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            showAllCookbooks = true
        } else {
            showAllCookbooks = false
        }
        cookbooksCollectionView.reloadData()
    }
    
    @IBAction func onAddProfilePicture(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Set your profile picture", message: nil, preferredStyle: .actionSheet)
        
        // Make sure the simulator does not show the camera option
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                self.showPhotoPicker(type: UIImagePickerControllerSourceType.camera)
            }
            actionSheet.addAction(cameraAction)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.showPhotoPicker(type: UIImagePickerControllerSourceType.photoLibrary)
        }
        actionSheet.addAction(photoLibraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue" {
            let editProfileViewController = segue.destination as! EditProfileViewController
            editProfileViewController.delegate = self
        }
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            // Cell for Top 5 recipies
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCollectionViewCell", for: indexPath) as! RecipeCollectionViewCell
            let recipe = self.recipies[indexPath.row]
            
            let recipeImageFile = recipe.image
            if recipeImageFile != nil {
                recipeImageFile?.getDataInBackground(block: { (imageData: Data?, error: Error?) in
                    if error == nil {
                        if let imageData = imageData {
                            cell.recipeImage.image = UIImage(data: imageData)
                        }
                    }
                })
            }
            cell.recipeId = recipe.objectId
            cell.categoryLabel.text = recipe.category
            cell.createdByLabel.isHidden = true
            // Commented out since we don't want to show the owner in this screen
//            if let owner = User.fetchUser(by: recipe.owner!) {
//                cell.createdByLabel.text = "by @\(owner.username!)"
//            } else {
//                cell.createdByLabel.text = ""
//            }
            cell.recipeTitle.text = recipe.name
            
            return cell
        } else {
            // Cell for Cookbooks
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CookbookCollectionViewCell", for: indexPath) as! CookbookCollectionViewCell
            var cookbook: Cookbook
            if showAllCookbooks {
                cookbook = allCookbooks[indexPath.row]
            } else {
                cookbook = filteredCookbooks[indexPath.row]
            }
            if cookbook.owner.objectId == userId {
                cell.authorLabel.isHidden = true
            } else {
                if let username = cookbook.owner.username {
                    cell.authorLabel.text = "by @\(username)"
                }
            }
            var complimentsLabel = "\(cookbook.likesAggregate)"
            // TODO: Find a fine
            if cookbook.likesAggregate > 1000 {
                complimentsLabel = "1K"
            }
            cell.complimentLabel.text = "\(complimentsLabel) compliments"
            cell.cookbookLabel.text = cookbook.name
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return recipies.count
        } else {
            if showAllCookbooks {
                return allCookbooks.count
            } else {
                return filteredCookbooks.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let recipeVC = storyboard.instantiateViewController(withIdentifier: "RecipeViewController") as! RecipeViewController
            recipeVC.recipeId = recipies[indexPath.row].objectId
            show(recipeVC, sender: self)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let cookbookVC = storyboard.instantiateViewController(withIdentifier: "CookbookViewController") as! CookbookViewController
            if showAllCookbooks {
                // TODO: Add reference to the cookbook
            } else {
                // TODO: Add reference to the cookbook
            }
            self.navigationController?.pushViewController(cookbookVC, animated: true)
        }
    }
}

extension ProfileViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let collectionView = previewingContext.sourceView as! UICollectionView
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) as? RecipeCollectionViewCell else { return nil }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if collectionView.tag == 0 {
            let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            // in order to initialize the outlets on the view
            let view = detailVC.view
            
            detailVC.recipeId = cell.recipeId
            detailVC.recipeImage.image = cell.recipeImage?.image
            
            detailVC.preferredContentSize = CGSize(width: 0.0, height: 500)
            previewingContext.sourceRect = cell.frame
            
            return detailVC
        } else {
            // TODO: Figure out how to open the correctly
            let detailVC = storyboard.instantiateViewController(withIdentifier: "CookbookViewController") as! CookbookViewController
            // TODO: Add missing parameter
            detailVC.preferredContentSize = CGSize(width: 0.0, height: 500)
            previewingContext.sourceRect = cell.frame
            
            return detailVC
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        let collectionView = previewingContext.sourceView as! UICollectionView
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if collectionView.tag == 0 {
            let recipeVC = storyboard.instantiateViewController(withIdentifier: "RecipeViewController") as! RecipeViewController
            let detailVC = viewControllerToCommit as! DetailViewController
            recipeVC.recipeId = detailVC.recipeId
            show(recipeVC, sender: self)
        } else {
            // TODO: Figure out how to open the correctly
            let recipeVC = storyboard.instantiateViewController(withIdentifier: "RecipeViewController") as! RecipeViewController
//            let detailVC = viewControllerToCommit as! CookbookViewController
            // TODO: Add missing parameter
            show(recipeVC, sender: self)
        }
    }
}

extension ProfileViewController: EditProfileViewControllerDelegate {
    func editProfileViewController(editProfileViewController: EditProfileViewController, didUpdateUser user: User?) {
        populateUser(user: user!)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        displayProfilePicture(image: editedImage)
        saveProfilePicture(image: editedImage)
        dismiss(animated: true, completion: nil)
    }
}
