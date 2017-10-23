//
//  AddFriendsViewController.swift
//  RecipeApp
//
//  Created by Cesar Cavazos on 10/15/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import Parse

class AddFriendsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.isNavigationBarHidden = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onAddFriends(_ sender: UIButton) {
        let contactPickerVC = CNContactPickerViewController()
        contactPickerVC.delegate = self
        present(contactPickerVC, animated: true, completion: nil)
    }
    
    @IBAction func onDone(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()!
        self.present(vc, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation
 
    // TODO: Figure out if we need this
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddFriendsViewController: CNContactPickerDelegate {
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
