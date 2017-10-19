//
//  LoginViewController.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/14/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Parse
import CryptoSwift
import FacebookCore
import FacebookLogin
import ParseFacebookUtilsV4


class LoginViewController: UIViewController {

	@IBOutlet weak var username: UITextField!
	@IBOutlet weak var password: UITextField!
    
	let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
	
	override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        // Override point for customization after application launch.
      
//        // Facebook Swift SDK example below
//        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
//        loginButton.center = view.center
//        view.addSubview(loginButton)

        // Do any additional setup after loading the view.
        
		// create an OK action
		let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
			// handle response here.
		}
		// add the OK action to the alert controller
		alertController.addAction(OKAction)
		
		setupTextFieldAtributes(field: username, string: "Username")
		setupTextFieldAtributes(field: password, string: "Enter Password")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func onSignUp(_ sender: UIButton) {
		performSegue(withIdentifier: "RegisterNavigationSegue", sender: sender)
	}
	
	@IBAction func onLogin(_ sender: UIButton) {
		loginUser()
	}
	
    @IBAction func onFacebookLogin(_ sender: UIButton) {
        print("User tapped on login with facebook")
        // Parse-Facebook Swift SDK below
        let permissions: [String] = ["public_profile", "email", "user_friends"]
        PFFacebookUtils.logInInBackground(withReadPermissions: permissions) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("There was an error with fb login: \(error.localizedDescription)")
            }
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                } else {
                    print("User logged in through Facebook!")
                }
				let currentUser = user
				currentUser.saveInBackground(block: { (success, error) in
					if (success) {
						// The object has been saved.
						print("User: " + currentUser.username! + " saved with additional attributes")
					} else {
						// There was a problem, check error.description
						print("Unable to save User attributes for User: " + currentUser.username!)
						print("error: " + (error?.localizedDescription)!)
					}
				})
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        }
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

    private func loginUser() {		
		let user = username.text ?? ""
		let passwd = password.text ?? ""
		let passwdHash = passwd.sha512()

		User.logInWithUsername(inBackground: user, password: passwdHash) { (user: PFUser?, error: Error?) in
            if let error = error {
				print("User log in failed: \(error.localizedDescription)")
				self.alertController.title = "Invalid Login"
				self.password.text = ""
				self.present(self.alertController, animated: true, completion: nil)
			} else {
				print("User logged in successfully")
				let currentUser = user
				currentUser?.saveInBackground(block: { (success, error) in
					if (success) {
						// The object has been saved.
						print("User: " + (currentUser?.username)! + " saved")
					} else {
						// There was a problem, check error.description
						print("Unable to save User: " + (currentUser?.username)!)
						print("error: " + (error?.localizedDescription)!)
					}
				})
				// display view controller that needs to shown after successful login
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! UITabBarController
				self.show(vc, sender: self)
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

//extension LoginViewController: LoginButtonDelegate {
//    func loginButtonDidLogOut(_ loginButton: LoginButton) {
//        print("User logged in")
//    }
//
//    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
//        print("User just completed the login")
//        print("user id \(AccessToken.current?.userId)")
//        print(UserProfile.current?.fullName)
//    }
//}

