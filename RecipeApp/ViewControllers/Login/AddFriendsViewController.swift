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
    
    @IBOutlet weak var categoryView: UIView!
    var categories: [String] = []
    var categoryLabels = [UILabelCategory]()
    var indexed: Set<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.isNavigationBarHidden = false
        
        // set up the category labels
        let allCategories: [String] = Recipe.categories
        self.categoryView.subviews.forEach { (view: UIView) in
            let label = view as! UILabelCategory
            addCategoryTapRecognizer(to: label)
            label.sizeToFit()
            if label.isTruncated {
                label.isHidden = true
            }
            
            var index = random(0, allCategories.count - 1)
            while (indexed.contains(index)) {
                index = random(0, allCategories.count - 1)
            }
            
            label.text = allCategories[index]
            indexed.insert(index)
        }
        

    }

    private func random(_ lower: Int ,_ upper: Int) -> Int {
        return Int(lower + arc4random_uniform(upper - lower + 1))
    }
    
    func addCategoryTapRecognizer(to label: UILabel) {
        label.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddFriendsViewController.categoryTapped(tapGestureRecognizer:)))
        label.addGestureRecognizer(tapRecognizer)
    }
    
    func categoryTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        print("Category tapped")
        let label = tapGestureRecognizer.view as! UILabelCategory
        if label.isActive {
            let color = UIColor(named: "GraySmallHeader")
            label.backgroundColor = color
            let index = self.categories.index(where: { (key: String) -> Bool in
                return key == label.text!.lowercased()
            })
            if let index = index {
                categories.remove(at: index)
            }
        } else {
            let color = UIColor(named: "PrimaryColor")
            self.categories.append(label.text!.lowercased())
            label.backgroundColor = color
        }
        
        label.isActive = !label.isActive
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
        
        let settings = UserSettings(shareMyCooking: true, learnToCook: true, enablePushNotifications: true, favoriteCuisines: categories)
        
//        let currentUser = User.fetchUser(by: (PFUser.current()?.objectId!)!)
        settings["parent"] = PFUser.current()?.objectId!
        settings.saveInBackground()
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
