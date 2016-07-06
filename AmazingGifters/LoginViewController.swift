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
    private var facebookID: String?
    
    private var coverURL: String?
    private var pictureURL: String?
    private var myName: String?
    
    //private var ref : FIRDatabaseReference!
    
    @IBOutlet weak var btnFacebook: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            btnFacebook.hidden = true;
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                self.returnUserProfileAndJump()
            }
            btnFacebook.hidden = true
        }
        else
        {

            btnFacebook.readPermissions = ["public_profile", "email", "user_friends","user_birthday"]
            btnFacebook.delegate = self
        }
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
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
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                    self.returnUserProfileAndJump()
                }
                btnFacebook.hidden = true
                
            }
        }
    }

        
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        try! FIRAuth.auth()!.signOut()
        print("User Logged Out")
    }
    
    
    private func returnUserProfileAndJump()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name, email, picture.type(large), friends, birthday,cover"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                var pictureURL:String?
                var contactsList: [Dictionary<String,String>?] = []
                
                if let picture = result.valueForKey("picture"){//get picture url
                    if let data = picture.valueForKey("data"){
                        pictureURL = data.valueForKey("url") as? String
                    }
                }
                if let friends = result.valueForKey("friends"){ //get friends list
                    if let data = friends.valueForKey("data") as? [NSDictionary]{
                        for map in data{
                            contactsList.append(map as? Dictionary<String,String>)
                        }
                    }
                }
                
                let profile = [
                    "address_first":"",
                    "address_second":"",
                    "birthday":result.valueForKey("birthday") as? String ?? "",
                    "city":"",
                    "country":"",
                    "email":result.valueForKey("email") as? String ?? "",
                    "gift_for_friend": "",
                    "my_gift":["from_friends":"","wish_list":""],
                    "name":result.valueForKey("name") as? String ?? "",
                    "payment":"",
                    "phone":"",
                    "picture_url":pictureURL ?? "",
                    "state":"",
                    "zipcode":""
                ]
                
                if let uid = result.valueForKey("id") as? String {
                    let brain = dataBrain.sharedDataBrain
                    brain.setUid(uid)
                    brain.login(profile)
                    if let cover = result.valueForKey("cover"){
                        brain.user.setCover(cover.valueForKey("source") as? String)
                    }
                    brain.user.getContacts(contactsList)
                }
                self.jumpToContent()
            }
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func jumpToContent()  {
        print("jumping...")
        self.performSegueWithIdentifier("showContent", sender: self)

    }
    
}