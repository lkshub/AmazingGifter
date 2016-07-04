//
//  dataBrain.swift
//  AmazingGifters
//
//  Created by 陆恺 on 7/3/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import Foundation
import Firebase

class dataBrain{
    static let sharedDataBrain = dataBrain()
    private init(){
        self.ref = FIRDatabase.database().reference()
    }
    func setUid(uid:String){
        self.uid = uid
    }
    private var ref : FIRDatabaseReference!
    private var uid:String!
    private init(id:String!){
        self.uid  = id
        self.ref = FIRDatabase.database().reference()
    }
    
    func login(profile:Dictionary<String,String>){
        UserRegistrationOrUpdate(self.uid, profile: profile)
    }
    
    
    private func UserRegistrationOrUpdate(uid:String,profile:Dictionary<String,String>){
        
        self.ref.child("user").child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.value! is NSDictionary{
                self.ref.child("user").child(uid).child("name").setValue(profile["name"])
                self.ref.child("user").child(uid).child("email").setValue(profile["email"])
                self.ref.child("user").child(uid).child("picture_url").setValue(profile["picture_url"])
            }else{
                self.ref.child("user").child(uid).setValue(profile)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    //func getGifts()->[Gift]{
    //    return getGiftsAccordingToFBID()
    //}
    
    func getProgress() {
        
    }
    
    //private func getGiftsAccordingToFBID()->[Gift]{
    //    return
    //}
 
}