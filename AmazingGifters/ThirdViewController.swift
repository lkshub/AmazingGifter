//
//  ThirdViewController.swift
//  AmazingGifters
//
//  Created by 陆恺 on 6/18/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase


class ThirdViewController: UIViewController,FBSDKLoginButtonDelegate{
    
    fileprivate let brain = dataBrain.sharedDataBrain
    
    let btnFacebook = FBSDKLoginButton()
    @IBOutlet fileprivate weak var userProfilePicture: UIImageView!
    @IBOutlet fileprivate weak var coverPhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoutTableCell: UIView!
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = brain.user.profile!["picture_url"] {
            print("get picture url!")
            let thisURL = URL(string: url as! String)
            if let data = try? Data(contentsOf: thisURL!){
                userProfilePicture.image = UIImage(data:data)
            }
        }
        userProfilePicture.layer.cornerRadius = 8.0
        userProfilePicture.clipsToBounds = true
        userProfilePicture.layer.zPosition = 1;
        userProfilePicture.layer.borderColor = UIColor.white.cgColor
        userProfilePicture.layer.borderWidth = 2
        
        nameLabel.text  = (brain.user.profile!["name"] as! String)

        if let url = brain.user.coverUrl{
            print("get cover url!")
            let thisURL = URL(string: url)
            if let data = try? Data(contentsOf: thisURL!){
                coverPhoto.image = UIImage(data:data)
            }
        }
        
        btnFacebook.delegate = self
        container.layer.zPosition = 1
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("User Logged In")
        if ((error) != nil)
        {
            print(error.localizedDescription)
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        try! FIRAuth.auth()!.signOut()
        print("User Logged Out")
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        jumpToLogin()
        
    }
    fileprivate func jumpToLogin()  {
        print("back to login")
        self.performSegue(withIdentifier: "backToLogin", sender: self)
    }


}

