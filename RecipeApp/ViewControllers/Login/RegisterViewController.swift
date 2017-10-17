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
	@IBOutlet weak var email: UITextField!
	
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
		
		let navigationController = self.navigationController
		navigationController?.isNavigationBarHidden = true
		
		setupTextFieldAtributes(field: email, string: "Email")
		setupTextFieldAtributes(field: username, string: "Username")
		setupTextFieldAtributes(field: password, string: "Password")
		setupTextFieldAtributes(field: confirmPassword, string: "Confirm Password")
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
		newUser.email = email.text
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
				self.performSegue(withIdentifier: "SelectPreferenceNavigationSegue", sender: nil)
			}
		}
	}
	
	@IBAction func onCancel(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	private func setupTextFieldAtributes(field: UITextField, string: String) {
		let width = CGFloat(2.0)
		field.textColor = UIColor.white
		let fieldBorder = CALayer()
		fieldBorder.borderColor = UIColor.white.cgColor
		fieldBorder.frame = CGRect(x: 0, y: field.frame.size.height - width, width:  field.frame.size.width, height: field.frame.size.height)
		fieldBorder.borderWidth = width
		field.layer.addSublayer(fieldBorder)
		field.layer.masksToBounds = true
		field.attributedPlaceholder = NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName: UIColor.white])
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
