//
//  GiftDetailTableViewController.swift
//  AmazingGifters
//
//  Created by Chong Wu Guo on 7/10/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//


import UIKit
import Firebase
class GiftDetailTableViewController: UITableViewController {
    var brain = dataBrain.sharedDataBrain

    var gift: Gift?
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var itemIDLabel: UILabel!
    @IBOutlet weak var contributrTextField: UITextField!
    
 
    @IBAction func contributeAction(sender: UIButton) {
        contribute()
    }
    @IBOutlet weak var progressView: UIProgressView!
    @IBAction func viewWebsiteAction(sender: UIButton) {
                UIApplication.sharedApplication().openURL(NSURL(string: (gift?.itemURL!)!)!)
    }
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    
    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var itemProgressLabel: UILabel!
    
    @IBOutlet weak var PriceLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var receiverLabel: UILabel!
    @IBOutlet weak var initiatorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL(string: (gift?.pictureURL)!)
        let data = NSData(contentsOfURL: url!)
        giftImageView.contentMode = .ScaleAspectFit
        giftImageView.image = UIImage(data: data!)
        itemNameLabel.text = gift?.name
        itemIDLabel.text = gift?.itemID
        PriceLabel.text = String(gift!.price!)
              brain.ref.child("user").child(self.gift!.initiatorID!).child("name").observeSingleEventOfType(.Value, withBlock: { snapshot in
            self.initiatorLabel.text = snapshot.value! as? String
        })
        brain.ref.child("user").child(self.gift!.receiverID!).child("name").observeSingleEventOfType(.Value, withBlock: { snapshot in
            self.receiverLabel.text = snapshot.value! as? String
        })
        
        itemProgressLabel.text = String(gift!.progress!) + "/" + String(gift!.price!)
        postTimeLabel.text = gift?.postTime
        reasonLabel.text = gift?.reason
        dueDateLabel.text = gift?.dueDate
        progressView.transform = CGAffineTransformMakeScale( 1, 3)
        progressView.setProgress(Float((gift?.progress)!/(gift?.price)!), animated: true)
    }

 
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.min
        }
        return tableView.sectionHeaderHeight
    }
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.min
        }
        return tableView.sectionFooterHeight
    }
    func contribute(){
        print("test")
        let giftRef = brain.ref.child("gift")
        giftRef.queryOrderedByValue().observeEventType(.ChildAdded, withBlock: { snapshot in
        
            
            if (snapshot.value!["name"] as? String == self.gift?.name && snapshot.value!["post_time"] as? String == self.gift?.postTime && snapshot.value!["initiator_id"] as? String == self.gift?.initiatorID){
                print(snapshot.key)
                if(!(self.contributrTextField.text?.isEmpty)!){
                    let contribution = Float(self.contributrTextField.text!)!
                    let progress = snapshot.value!["progress"] as! Float
                    let newProgress = Float(contribution + progress)
                    giftRef.child(snapshot.key).child("progress").setValue(newProgress)
                    self.itemProgressLabel.text = String(newProgress) + "/" + String(self.gift!.price!)
                    self.progressView.setProgress(newProgress/Float(self.gift!.price!), animated: false)
                }
            }
            
        })
        let autoId = self.gift?.auto_id
        brain.ref.child("user").child(self.brain.user.uid).child("my_gift").child("gift_for_friends").updateChildValues([autoId! : true])
        goBack()
        

        /*
        giftRef.queryOrderedByChild("progress").observeEventType(.ChildAdded, withBlock: { snapshot in
             print(snapshot.childrenCount)
             let enumerator = snapshot.children
             while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                print(rest.key)
                print("!!!!!")
                              if (rest.value!["name"] as? String == self.gift?.name && rest.value!["postTime"] as? String == self.gift?.postTime && rest.value!["initiatorID"] as? String == self.gift?.initiatorID){
                    print("Found")
                    rest.setValue(Float(self.contributrTextField.text!), forKey: "progress")
                }
            }
        })
 */
    }
    override func tableView(tableView: UITableView,
                   didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print(indexPath.section)
        print(indexPath.row)
        if(indexPath.section == 0 && indexPath.row == 10){
            if(self.gift?.progress == 0){
                deleteGift(self.gift!)
                goBack()
            }
        }
    }
    func deleteGift(gift:Gift)  {
        brain.ref.child("gift").child(self.gift!.auto_id!).removeValue()
        if(self.gift!.receiverID! == self.gift!.initiatorID!){
            brain.ref.child("user").child(brain.visitedUser!.uid).child("my_gift").child("wish_list").child(self.gift!.auto_id!).removeValue()
        }else{
            brain.ref.child("user").child(brain.visitedUser!.uid).child("my_gift").child("from_friends").child(self.gift!.auto_id!).removeValue()
            brain.ref.child("user").child((self.gift?.initiatorID)!).child("gift_for_friend").child(self.gift!.auto_id!).removeValue()
        }
    }
    func goBack(){
        let n: Int! = self.navigationController?.viewControllers.count
        if let giftViewController = self.navigationController?.viewControllers[n-2] as? FirstViewController{
            //giftViewController.fetchGifts()
            self.navigationController?.popToViewController(giftViewController, animated: true)
        }
        if let secondViewController = self.navigationController?.viewControllers[n-2] as? SecondViewController{
            self.navigationController?.popToViewController(secondViewController, animated: true)
            
        }
    }

}