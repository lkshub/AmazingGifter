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
    init(id:String,profile:NSDictionary!){
        uid = id
        self.profile = profile 
    }
    func createNewOrUpdate(ref:FIRDatabaseReference!)  {
        ref.child("user").child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.value! is NSDictionary{
                ref.child("user").child(self.uid).child("name").setValue(self.profile["name"])
                ref.child("user").child(self.uid).child("email").setValue(self.profile["email"])
                ref.child("user").child(self.uid).child("picture_url").setValue(self.profile["picture_url"])
                self.profile = snapshot.value as! NSDictionary
                print(self.profile)
            }else{
                ref.child("user").child(self.uid).setValue(self.profile)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}