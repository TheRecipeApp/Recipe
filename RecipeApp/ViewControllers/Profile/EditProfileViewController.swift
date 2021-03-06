//
//  EditProfileViewController.swift
//  RecipeApp
//
//  Created by Cesar Cavazos on 10/15/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Parse
import Contacts
import ContactsUI

@objc protocol EditProfileViewControllerDelegate {
    @objc optional func editProfileViewController(editProfileViewController: EditProfileViewController, didUpdateUser user: User?)
}


class EditProfileViewController: UIViewController {

    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var preferenceSegmentedControl: UISegmentedControl!
    
    var userObject: User?
    
    weak var delegate: EditProfileViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 0
        
        setupTextFieldAtributes(field: firstNameTextField)
        setupTextFieldAtributes(field: lastNameTextField)
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
        let currentUser = User.current()
        userObject = User.fetchUser(by: (currentUser?.objectId)!)
        firstNameTextField.text = userObject?.firstName
        lastNameTextField.text = userObject?.lastName
        if let preference = userObject?.preference {
            if preference == 1 || preference == 0 {
                preferenceSegmentedControl.selectedSegmentIndex = preference
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
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
    
    @IBAction func onSave(_ sender: UIBarButtonItem) {
        let firstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        let selectedPreference = preferenceSegmentedControl.selectedSegmentIndex
        userObject?.firstName = firstName
        userObject?.lastName = lastName
        userObject?.preference = selectedPreference
        userObject?.saveInBackground()
        delegate?.editProfileViewController?(editProfileViewController: self, didUpdateUser: userObject)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func inviteFriendsTapped(_ sender: UIButton) {
        let contactPickerVC = RPContactPickerViewController()
        contactPickerVC.delegate = self
        present(contactPickerVC, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EditProfileViewController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        print("Contacts Selected")
        print(contacts.count)
        if contacts.count > 0 {
            let currentUser = PFUser.current()
            for contact in contacts {
                for email in contact.emailAddresses {
                    let invite = PFObject(className: "FriendInvite")
                    invite["sourceUser"] = currentUser
                    invite["label"] = email.label!
                    invite["email"] = email.value
                    invite.saveInBackground()
                }
            }
            let alertController = UIAlertController(title: "Thank you! Your friends have been invited.", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // handle response here.
            }
            alertController.addAction(okAction)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.present(alertController, animated: true, completion: nil)
            })
        }
        // TODO: Sprint 3, wire this to parse to send emails
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    // TODO: Add the navigation between text fields
}


