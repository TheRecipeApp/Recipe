//
//  SelectPreferenceViewController.swift
//  RecipeApp
//
//  Created by Cesar Cavazos on 10/15/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Parse

class SelectPreferenceViewController: UIViewController {

    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var preferenceSegmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.isNavigationBarHidden = false

        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 0
        
        setupTextFieldAtributes(field: firstNameTextField)
        setupTextFieldAtributes(field: lastNameTextField)
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
        profileImageView.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: View controller functions
    
    private func setupTextFieldAtributes(field: UITextField) {
        let width = CGFloat(2.0)
        field.textColor = UIColor.black
        let fieldBorder = CALayer()
        fieldBorder.borderColor = UIColor.gray.cgColor
        fieldBorder.frame = CGRect(x: 0, y: field.frame.size.height - width, width:  field.frame.size.width, height: field.frame.size.height)
        fieldBorder.borderWidth = width
        field.layer.addSublayer(fieldBorder)
        field.layer.masksToBounds = true
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
    
    // MARK: Actions

    @IBAction func onAddProfilePicture(_ sender: Any) {
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
    
    @IBAction func onSkip(_ sender: Any) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateInitialViewController()!
		self.present(vc, animated: true, completion: nil)
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nextSegue" {
            let firstName = firstNameTextField.text
            let lastName = lastNameTextField.text
            let preference = preferenceSegmentedControl.selectedSegmentIndex
            if firstName != "" || lastName != "" || preference != -1 {
                let currentUser = PFUser.current()
                currentUser?["firstName"] = firstName
                currentUser?["lastName"] = lastName
                if preference != -1 {
                    currentUser?["preference"] = preference
                }
                currentUser?.saveInBackground()
            }
        }
    }
    
}

extension SelectPreferenceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        displayProfilePicture(image: editedImage)
        saveProfilePicture(image: editedImage)
        dismiss(animated: true, completion: nil)
    }
}

extension SelectPreferenceViewController: UITextFieldDelegate {
    // TODO: Add the navigation between text fields
}
