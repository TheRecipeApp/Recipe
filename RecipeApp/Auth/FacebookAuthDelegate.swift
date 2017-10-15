//
//  FacebookAuthDelegate.swift
//  RecipeApp
//
//  Created by Alexander Doan on 10/15/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import Parse

class FacebookAuthDelegate: NSObject, PFUserAuthenticationDelegate {
    
    func restoreAuthentication(withAuthData authData: [String : String]?) -> Bool {
        return true
    }

}
