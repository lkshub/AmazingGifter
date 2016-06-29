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
    //@IBOutlet var bbtnFacebook: FBSDKLoginButton!
    
    @IBOutlet weak var btnFacebook: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            print("allready logged in")
            //btnFacebook.hidden = true
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                // ...
            }
            print("asking for data")
            returnUserProfile()
        }
        else
        {
            //btnFacebook =  FBSDKLoginButton()
            //self.view.addSubview(btnFacebook)
            //btnFacebook.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.8)
            btnFacebook.readPermissions = ["public_profile", "email", "user_friends"]
            btnFacebook.delegate = self
        }
        
    }
    override func viewDidAppear(animated: Bool) {
        //btnFacebook.center = CGPointMake(0, 0)
        if(FBSDKAccessToken.currentAccessToken() != nil){
            btnFacebook.hidden = true
            print("jump to my gifts")
            jumpToMyGifts()
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
                // Do work
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                    // ...
                }

                returnUserProfile()
                jumpToMyGifts()
            }
        }
    }

        
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    
    func returnUserProfile()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name, last_name, email,picture.type(large),friends"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userFirstName : NSString = result.valueForKey("first_name") as! NSString
                let userLastName : NSString = result.valueForKey("last_name") as! NSString
                print("User First Name is: \(userFirstName)")
                print("User last Name is: \(userLastName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                print("User Email is: \(userEmail)")
                let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                print("User pic is: \(strPictureURL)")
                //self.userImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: strPictureURL)!)!)
                
            }
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func jumpToMyGifts()  {
        print("jumping...")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("Content")
        self.presentViewController(nextViewController, animated: true, completion: nil)
        //self.performSegueWithIdentifier("testJump", sender: self)

    }
    
}