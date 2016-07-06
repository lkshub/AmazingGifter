//
//  User.swift
//  AmazingGifters
//
//  Created by 陆恺 on 7/4/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import Foundation
import Firebase

class User {
    var profile:NSDictionary!
    var uid:String
    var contactsList:[Dictionary<String,String>?] = []
    var coverUrl:String? //user may do not have cover
    
    init(id:String,profile:NSDictionary!){
        uid = id
        self.profile = profile 
    }
    func getContacts(contactsList:[Dictionary<String,String>?]) {
        self.contactsList = contactsList
    }
    func setCover(cover:String?)  {
        self.coverUrl = cover
    }
    
    func createNewOrUpdate(ref:FIRDatabaseReference!)  {
        ref.child("user").child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.value! is NSDictionary{
                ref.child("user").child(self.uid).child("name").setValue(self.profile["name"])
                ref.child("user").child(self.uid).child("email").setValue(self.profile["email"])
                ref.child("user").child(self.uid).child("picture_url").setValue(self.profile["picture_url"])
                self.profile = snapshot.value as! NSDictionary
                print(self.profile["my_gift"]!["from_friends"] as? [Int])
            }else{
                ref.child("user").child(self.uid).setValue(self.profile)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}