//
//  LoginViewController.swift
//  AmazingGifters
//
//  Created by 陆恺 on 6/19/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase


class LoginViewController: UIViewController,FBSDKLoginButtonDelegate{
    
    
    
    // Facebook Delegate Methods
    fileprivate var facebookID: String?
    
    fileprivate var coverURL: String?
    fileprivate var pictureURL: String?
    fileprivate var myName: String?
    //private var jumped = false
    
    //private var ref : FIRDatabaseReference!
    
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    
    @IBOutlet weak var btnFacebook: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (FBSDKAccessToken.current() != nil)
        {
            btnFacebook.isHidden = true
            //loadingIcon.hidden = false
            loadingIcon.startAnimating()
        }else{
            loadingIcon.isHidden = true
            btnFacebook.readPermissions = ["public_profile", "email", "user_friends","user_birthday"]
            btnFacebook.delegate = self

        }
    }
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(true)
        // Do any additional setup after loading the view, typically from a nib.
        
        if (FBSDKAccessToken.current() != nil)
        {
            let loginResult: FBSDKAccessToken = FBSDKAccessToken.current()
            //print(loginResult)
            if !loginResult.permissions.contains("email"){
                btnFacebook.isHidden = false
                loadingIcon.isHidden = true
            }else{
                loadingIcon.isHidden = false
                loadingIcon.startAnimating()
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    self.returnUserProfileAndJump()
                }
            }
        }
        else{
            btnFacebook.isHidden = false
            loadingIcon.isHidden = true
        }
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if ((error) != nil)
        {
            // Process error
            print(error.localizedDescription)
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                btnFacebook.isHidden = true
                
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    self.returnUserProfileAndJump()
                }
                loadingIcon.isHidden = false
                loadingIcon.startAnimating()
            }
        }
    }

        
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        try! FIRAuth.auth()!.signOut()
        print("User Logged Out")
    }
    
    
    fileprivate func returnUserProfileAndJump()
    {
        
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name, email, picture.type(large), friends, birthday,cover"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                var pictureURL:String?
                var contactsList = [User]()
                print(result)
                if let data = result as? [String:Any]{
                    if let picture = data["picture"] as? [String : Any]{//get picture url
                        if let picData = picture["data"] as? [String : Any]{
                            pictureURL = picData["url"] as? String
                        }
                    }
                    if let friends = data["friends"]  as? [String : Any]{ //get friends list
                        if let friendsList = friends["data"] as? [Any]{
                            for info in friendsList {
                                let user = User(id: (info as? [String : Any])!["id"] as! String)
                                contactsList.append(user)
                            }
                        }
                    }
                
                    let profile = [
                        "address_first":"",
                        "address_second":"",
                        "birthday":data["birthday"] as? String ?? "",
                        "city":"",
                        "country":"",
                        "email": data["email"] as? String ?? "",
                        "gift_for_friend": "",
                        "my_gift":["from_friends":"","wish_list":""],
                        "name":data["name"] as? String ?? "",
                        "payment":"",
                        "phone":"",
                        "picture_url":pictureURL ?? "",
                        "state":"",
                        "zipcode":""
                    ] as [String : Any]
                
                    if let uid = data["id"] as? String {
                        let brain = dataBrain.sharedDataBrain
                        print(uid)
                        brain.login(uid,profile: profile as NSDictionary!)
                        if let cover = data["cover"] as? [String : Any]{
                            brain.user.setCover(cover["source"] as? String)
                        }
                        brain.setContacts(contactsList)
                    }
                    self.jumpToContent()
                }
            }
        })
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    fileprivate func jumpToContent()  {
        //jumped = true
        print("jumping...")
        self.performSegue(withIdentifier: "showContent", sender: self)

    }
    
}
