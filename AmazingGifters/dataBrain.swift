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
    var searchText:String?
    static let sharedDataBrain = dataBrain()
    var user:User!
    var ref : FIRDatabaseReference!
    var uid:String!
    var visitedUser:User!
    
    
    private init(){
        self.ref = FIRDatabase.database().reference()
    }
    
    func login(uid:String,profile:NSDictionary!){
        self.uid = uid
        self.user  = User(id: self.uid)
        self.user.profile = profile
        self.user.createNewOrUpdate(self.ref)
    }
    
    /*
    func setTimeout(delay:NSTimeInterval, block:()->Void) -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(delay, target: NSBlockOperation(block: block), selector: #selector(NSOperation.main), userInfo: nil, repeats: false)
    }
*/
    func addNewGift(newGift: Gift){
        //add gift to gift list
        let giftRef = ref.child("gift")
        let newGiftDic = ["itemID": newGift.itemID! as String,
                          "itemURL":newGift.itemURL! as String,
                          "dueDate": newGift.dueDate! as String,
                          "initiatorID": newGift.initiatorID! as String,
                          "name": newGift.name! as String,
                          "pictureURL": newGift.pictureURL! as String,
                          "postTime": newGift.postTime! as String,
                          "price":newGift.price! as Double,
                          "reason":newGift.reason! as String,
                          "receiverID":newGift.receiverID! as String,
                          "progress": 0.0]
        let gift1Ref = giftRef.childByAutoId()
        let autoId = gift1Ref.key
        gift1Ref.setValue(newGiftDic)
        
        //add gift to user's my_wish_list
        if self.user.uid == visitedUser.uid{
            ref.child("user").child(self.user.uid).child("my_gift").child("wish_list").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                
                let giftListItem = [autoId: true]
                self.ref.child("user").child(self.user.uid).child("my_gift").child("wish_list").updateChildValues(giftListItem)
                
            })
        }else{
            ref.child("user").child(visitedUser.uid).child("my_gift").child("from_friends").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                
                let giftListItem = [autoId: true]
                self.ref.child("user").child(self.visitedUser.uid).child("my_gift").child("from_friends").updateChildValues(giftListItem)
                
            })
            ref.child("user").child(self.user.uid).child("gift_for_friend").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                
                let giftListItem = [autoId: true]
                self.ref.child("user").child(self.user.uid).child("gift_for_friend").updateChildValues(giftListItem)
                
            })
        }
        
    }
    /*
    func getMyWishListDetail(wishList:[String]) ->[Gift]{

        var gifts:[Gift] = []
        for element in wishList{
    
            self.ref.child("gift").child(element).observeEventType(.Value, withBlock: { (snapshot) in
                let gift : Gift = Gift(
                    itemID: (snapshot.value!["itemID"] as? String)!,
                    itemURL: (snapshot.value!["itemURL"] as? String)!,
                    dueDate: (snapshot.value!["dueDate"] as? String)!,
                    initiatorID: (snapshot.value!["initiatorID"] as? String)!,
                    name: (snapshot.value!["name"] as? String)!,
                    pictureURL: (snapshot.value!["pictureURL"] as? String)!,
                    postTime: (snapshot.value!["postTime"] as? String)!,
                    price: (snapshot.value!["price"] as? Double)!,
                    reason: (snapshot.value!["reason"] as? String)!,
                    receiverID: (snapshot.value!["receiverID"] as? String)!,
                    progress: (snapshot.value!["progress"] as? Double)!
                )
                gifts.append(gift)
                print("==first==")
                print(gifts.count)
            })
        }
    
        return gifts
    }
 */
 
    func setContacts(contactsList:[User]) {
        for friend in contactsList{
            friend.getProfile(self.ref)
            self.user.contactsList.append(friend)
        }
    }

    
    //private func getGiftsAccordingToFBID()->[Gift]{
    //    return
    //}
 
}