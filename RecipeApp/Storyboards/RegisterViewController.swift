//
//  RegisterViewController.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/14/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import CryptoSwift

class RegisterViewController: UIViewController {
	@IBOutlet weak var username: UITextField!
	@IBOutlet weak var password: UITextField!
	@IBOutlet weak var confirmPassword: UITextField!
	let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)

	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		// create an OK action
		let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
			// handle response here.
		}
		// add the OK action to the alert controller
		alertController.addAction(OKAction)
		
		
		let width = CGFloat(2.0)
		
		username.textColor = UIColor.white
		let userNameBorder = CALayer()
		userNameBorder.borderColor = UIColor.white.cgColor
		userNameBorder.frame = CGRect(x: 0, y: username.frame.size.height - width, width:  username.frame.size.width, height: username.frame.size.height)
		userNameBorder.borderWidth = width
		username.layer.addSublayer(userNameBorder)
		username.layer.masksToBounds = true
		
		password.textColor = UIColor.white
		let passwordBorder = CALayer()
		passwordBorder.borderColor = UIColor.white.cgColor
		passwordBorder.frame = CGRect(x: 0, y: password.frame.size.height - width, width:  password.frame.size.width, height: password.frame.size.height)
		passwordBorder.borderWidth = width
		password.layer.addSublayer(passwordBorder)
		password.layer.masksToBounds = true

		confirmPassword.textColor = UIColor.white
		let confirmPasswordBorder = CALayer()
		confirmPasswordBorder.borderColor = UIColor.white.cgColor
		confirmPasswordBorder.frame = CGRect(x: 0, y: confirmPassword.frame.size.height - width, width:  confirmPassword.frame.size.width, height: confirmPassword.frame.size.height)
		confirmPasswordBorder.borderWidth = width
		confirmPassword.layer.addSublayer(confirmPasswordBorder)
		confirmPassword.layer.masksToBounds = true
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	@IBAction func onRegister(_ sender: UIButton) {
		registerUser()
	}
	
	private func registerUser() {
		// initialize a user object
		let newUser = User()
		
		// set user properties
		newUser.username = username.text
		newUser.email = username.text
		let pwd = password.text
		let confirmPwd = confirmPassword.text
		if pwd != nil {
			if (pwd != confirmPwd) {
				password.text = ""
				confirmPassword.text = ""
				alertController.title = "Password Confirmation Failed"
				self.password.becomeFirstResponder()
				present(alertController, animated: true, completion: nil)
				return
			}
		}
		newUser.password = password.text?.sha512()
		
		// call sign up function on the object
		newUser.signUpInBackground { (success: Bool, error: Error?) in
			if let error = error {
				print(error.localizedDescription)
				self.password.text = ""
				self.confirmPassword.text = ""
				self.alertController.title = "Unable to Register User"
				self.present(self.alertController, animated: true, completion: {
				})
			} else {
				print("User Registered successfully")
				// manually segue to logged in view
				self.dismiss(animated: true, completion: nil)
			}
		}
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
