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
    private var contactsList: [Dictionary<String,String>?] = []
    private var coverURL: String?
    private var pictureURL: String?
    private var myName: String?
    private var brain:dataBrain!
    
    //private var ref : FIRDatabaseReference!
    
    @IBOutlet weak var btnFacebook: FBSDKLoginButton!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController
        print("calling the prepareForSegue")
        //print(myName)
        if let contentVC = destinationVC as? UITabBarController{
            let myGiftNav = contentVC.viewControllers![0] as? UINavigationController
            let myGiftVC = myGiftNav?.viewControllers[0] as? FirstViewController
            let friendsVC = contentVC.viewControllers![1] as? SecondViewController
            let meNav = contentVC.viewControllers![2] as? UINavigationController
            let meVC = meNav?.viewControllers[0] as? ThirdViewController
            
            if let identifier = segue.identifier{
                switch identifier {
                case "showContent":
                    if let friends = friendsVC{
                        friends.facebookID = self.facebookID
                        friends.contactsList = self.contactsList
                    }
                    if let me = meVC{
                        me.coverURL = self.coverURL
                        me.pictureURL = self.pictureURL
                        me.myName = self.myName
                        me.facebookID = self.facebookID
                    }
                    if let myGift = myGiftVC{
                        myGift.facebookID = self.facebookID
                    }
                    
                default:
                    break
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let test1 = Gift.sharedInstance
        print ("testing")
        print (test1.name)
        test1.changeName("aaa")
        print ("test1 name")
        print (test1.name)
        let test2 = Gift.sharedInstance
        print("test2 name")
        print(test2.name)
        
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            print("allready logged in")
            btnFacebook.hidden = true;
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                
            }
            //print("asking for data")
        }
        else
        {

            btnFacebook.readPermissions = ["public_profile", "email", "user_friends","user_birthday"]
            btnFacebook.delegate = self
        }
        
    }
    override func viewDidAppear(animated: Bool) {
            if(FBSDKAccessToken.currentAccessToken() != nil){
            returnUserProfileAndJump()
            btnFacebook.hidden = true
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
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
                    
                }
                btnFacebook.hidden = true
                returnUserProfileAndJump()
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
                print("fetched user: \(result)")
                self.facebookID  = result.valueForKey("id") as? String
                //print(self.facebookID)
                if let cover = result.valueForKey("cover"){
                    self.coverURL = cover.valueForKey("source") as? String
                }
                if let picture = result.valueForKey("picture"){
                    if let data = picture.valueForKey("data"){
                        self.pictureURL = data.valueForKey("url") as? String
                    }
                }
                self.myName = result.valueForKey("name") as? String
                if let friends = result.valueForKey("friends"){
                    if let data = friends.valueForKey("data") as? [NSDictionary]{
                        for map in data{
                            self.contactsList.append(map as? Dictionary<String,String>)
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
                    "name":self.myName ?? "",
                    "payment":"",
                    "phone":"",
                    "picture_url":self.pictureURL ?? "",
                    "state":"",
                    "zipcode":""
                ]
                
                if let uid = self.facebookID{
                    let databrain1 = dataBrain.sharedDataBrain
                    databrain1.setUid(uid)
                    databrain1.login(profile)
                    //  self.brain = dataBrain(id: uid)
                  //  self.brain.login(profile)
                }
                self.jumpToContent()
                if (FIRAuth.auth()?.currentUser) != nil {
                    print("user authed")
                    //
                } else {
                    print("user not authed")
                }
                
                
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