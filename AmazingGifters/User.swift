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
    var profile:NSDictionary?
    var uid:String
    var contactsList=[User]()
    var coverUrl:String? //user may do not have cover
    
    init(id:String){
        uid = id
    }
    
    func setCover(cover:String?)  {
        self.coverUrl = cover
    }
    
    func getProgress(ref:FIRDatabaseReference!) -> [Gift]{
        let data:[Gift] = []
        
        return data
    }
    
    func getProfile(ref:FIRDatabaseReference) {
        ref.child("user").child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.value! is NSDictionary{
                self.profile = (snapshot.value as! NSDictionary)
                //print(self.profile!["name"])
            }
        }) { (error) in
            print(error.localizedDescription)

        }
    }
    
    func createNewOrUpdate(ref:FIRDatabaseReference!)  {
        ref.child("user").child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.value! is NSDictionary{
                ref.child("user").child(self.uid).child("name").setValue(self.profile!["name"])
                ref.child("user").child(self.uid).child("email").setValue(self.profile!["email"])
                ref.child("user").child(self.uid).child("picture_url").setValue(self.profile!["picture_url"])
                self.profile = (snapshot.value as! NSDictionary)
                //print(self.profile!["my_gift"]!["from_friends"] as? [Int])
            }else{
                ref.child("user").child(self.uid).setValue(self.profile)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}