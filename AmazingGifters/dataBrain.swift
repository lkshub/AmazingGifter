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
    var user:User!
    private var ref : FIRDatabaseReference!
    var uid:String!
    
    
    private init(){
        self.ref = FIRDatabase.database().reference()
    }
    func setUid(uid:String){
        self.uid = uid
    }
    
    func login(profile:NSDictionary!){
        self.user  = User(id: self.uid,profile: profile)
        self.user.createNewOrUpdate(self.ref)
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