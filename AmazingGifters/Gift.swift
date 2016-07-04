//
//  Gift.swift
//  AmazingGifters
//
//  Created by Chong Wu Guo on 7/4/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import Foundation
import Firebase

class Gift{
    /*
    private var giftID:String
    init(id:String){
        self.giftID = id
    }
    
    init(newID,dueDate,name,url,pictureUrl,postTime,price,reason,initiatorID,receiverID:String){
        giftID = newID
        let post = [
        
    }
     */
    var name: String?
    static let sharedInstance = Gift()
    private init() {
    }
    func changeName (newName:String){
        self.name = newName
    }
}