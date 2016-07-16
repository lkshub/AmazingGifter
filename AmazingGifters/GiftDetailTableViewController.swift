//
//  GiftDetailTableViewController.swift
//  AmazingGifters
//
//  Created by Chong Wu Guo on 7/10/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//


import UIKit
import Firebase
import FBSDKShareKit
import FBSDKCoreKit
//import Social

class GiftDetailTableViewController: UITableViewController,PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate{
    
    //////////////////////paypal testing code
    

    
    #if HAS_CARDIO
    // You should use the PayPal-iOS-SDK+card-Sample-App target to enable this setting.
    // For your apps, you will need to link to the libCardIO and dependent libraries. Please read the README.md
    // for more details.
    var acceptCreditCards: Bool = true {
    didSet {
    payPalConfig.acceptCreditCards = acceptCreditCards
    }
    }
    #else
    var acceptCreditCards: Bool = false {
        didSet {
            payPalConfig.acceptCreditCards = acceptCreditCards
        }
    }
    #endif
    
    var brain = dataBrain.sharedDataBrain

    var gift: Gift?
    

    
    var payPalConfig = PayPalConfiguration()
    
    func payPalPaymentDidCancel(paymentViewController: PayPalPaymentViewController) {
     
        print("PayPal Payment Cancelled")
      //  resultText = ""
      //  successView.hidden = true
        paymentViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func payPalPaymentViewController(paymentViewController: PayPalPaymentViewController, didCompletePayment completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        paymentViewController.dismissViewControllerAnimated(true, completion: { () -> Void in
            // send completed confirmaion to your server
            
            let alertController = UIAlertController(title: "", message: "Thanks for your contribution", preferredStyle: .Alert)
            self.presentViewController(alertController, animated: true, completion: nil)
            let delay = 2.0 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue(), {
                alertController.dismissViewControllerAnimated(true, completion: nil)
            })
            self.contribute()
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            
       //     self.resultText = completedPayment.description
      //      self.showSuccess()
            print("testing!!")
        })
    }
    
    
    // MARK: Future Payments
    
    @IBAction func authorizeFuturePaymentsAction(sender: AnyObject) {
        let futurePaymentViewController = PayPalFuturePaymentViewController(configuration: payPalConfig, delegate: self)
        presentViewController(futurePaymentViewController!, animated: true, completion: nil)
    }
    
    
    func payPalFuturePaymentDidCancel(futurePaymentViewController: PayPalFuturePaymentViewController) {
        print("PayPal Future Payment Authorization Canceled")
     //   successView.hidden = true
        futurePaymentViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func payPalFuturePaymentViewController(futurePaymentViewController: PayPalFuturePaymentViewController, didAuthorizeFuturePayment futurePaymentAuthorization: [NSObject : AnyObject]) {
        print("PayPal Future Payment Authorization Success!")
        // send authorization to your server to get refresh token.
        futurePaymentViewController.dismissViewControllerAnimated(true, completion: { () -> Void in
          //  self.resultText = futurePaymentAuthorization.description
           // self.showSuccess()
        })
    }
    
    // MARK: Profile Sharing
    
    @IBAction func authorizeProfileSharingAction(sender: AnyObject) {
        let scopes = [kPayPalOAuth2ScopeOpenId, kPayPalOAuth2ScopeEmail, kPayPalOAuth2ScopeAddress, kPayPalOAuth2ScopePhone]
        let profileSharingViewController = PayPalProfileSharingViewController(scopeValues: NSSet(array: scopes) as Set<NSObject>, configuration: payPalConfig, delegate: self)
        presentViewController(profileSharingViewController!, animated: true, completion: nil)
    }
    
    // PayPalProfileSharingDelegate
    
    func userDidCancelPayPalProfileSharingViewController(profileSharingViewController: PayPalProfileSharingViewController) {
        print("PayPal Profile Sharing Authorization Canceled")
        //successView.hidden = true
        profileSharingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func payPalProfileSharingViewController(profileSharingViewController: PayPalProfileSharingViewController, userDidLogInWithAuthorization profileSharingAuthorization: [NSObject : AnyObject]) {
        print("PayPal Profile Sharing Authorization Success!")
        
        // send authorization to your server
        
        profileSharingViewController.dismissViewControllerAnimated(true, completion: { () -> Void in
       //     self.resultText = profileSharingAuthorization.description
        //    self.showSuccess()
        })
        
    }


    
    //////////////////////paypal testing code
    
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var itemIDLabel: UILabel!
    @IBOutlet weak var contributrTextField: UITextField!
    
    @IBOutlet weak var contributionDetailsOutlet: UIButton!
 
    @IBAction func contributeAction(sender: UIButton) {
        
        //paypal testing
      if(self.contributrTextField.text != ""){
            
        
        let item1 = PayPalItem(name: "demo", withQuantity: 1, withPrice:   NSDecimalNumber(string: self.contributrTextField.text), withCurrency: "USD", withSku: "Hip-0037")

        let items = [item1]
        let subtotal = PayPalItem.totalPriceForItems(items)
        
        // Optional: include payment details
        
        let shipping = NSDecimalNumber(string: "0")
        let tax = NSDecimalNumber(string: "0")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        
        let total = subtotal.decimalNumberByAdding(shipping).decimalNumberByAdding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Demo Contribution", intent: .Sale)
        
        payment.items = items
        payment.paymentDetails = paymentDetails
        
        if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            presentViewController(paymentViewController!, animated: true, completion: nil)
        }
        else {
            // This particular payment will always be processable. If, for
            // example, the amount was negative or the shortDescription was
            // empty, this payment wouldn't be processable, and you'd want
            // to handle that here.
            print("Payment not processalbe: \(payment)")
        }

        
        //contribute()
        }
        
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
    
    @IBOutlet weak var facebookShare: FBSDKShareButton!
    /*
    @IBAction func facebookShareBtn(sender: AnyObject) {
                FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: nil)
    }
 */
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnectWithEnvironment(newEnvironment)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
        //content.contentURL = NSURL(string: "https://www.facebook.com/FacebookDevelopers")
        content.contentTitle = "An amazing gift for \(self.gift?.receiverName)"
        content.contentDescription = self.gift?.name
        content.imageURL = NSURL(string: (self.gift?.pictureURL)!)
        facebookShare.shareContent = content
        //facebookShare.
//paypal testing
        
        payPalConfig.acceptCreditCards = acceptCreditCards;
        payPalConfig.merchantName = "AmazingGifter Testing."
        payPalConfig.merchantPrivacyPolicyURL = NSURL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = NSURL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.payPalShippingAddressOption = .None;
//paypal testing
        
        
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
        let autoId = self.gift!.auto_id!
        if(!(self.contributrTextField.text?.isEmpty)!){
            let contribution = Float(self.contributrTextField.text!)!
            if contribution > 0{
                self.brain.ref.child("gift").child(autoId).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    let progress = snapshot.value!["progress"] as! Float
                    let newProgress = Float(contribution + progress)
                    self.brain.ref.child("gift").child(autoId).child("progress").setValue(newProgress)
                    self.itemProgressLabel.text = String(newProgress) + "/" + String(self.gift!.price!)
                    self.progressView.setProgress(newProgress/Float(self.gift!.price!), animated: false)

                })
            }
        }
        if (brain.user.uid != brain.visitedUser.uid){
            brain.ref.child("user").child(self.brain.user.uid).child("gift_for_friend").updateChildValues([autoId : true])
        }
        
        //  goBack()
        
        // add to firebase contribution table
        let contributionRef = brain.ref.child("contribution").child((gift?.auto_id)!)
        let contri1Ref = contributionRef.childByAutoId()
        
        let todaysDate:NSDate = NSDate()
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let DateInFormat:String = dateFormatter.stringFromDate(todaysDate)

        let contributionDic = ["amount" : Double(self.contributrTextField.text!)! as Double,
                               "contributor_id" : brain.user.uid as String,
                               "contributor_name" : brain.user.profile!["name"] as! String,
                               "time" : DateInFormat,
                               ]
        
 

        contri1Ref.setValue(contributionDic)

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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "contributionDetailsSegue"
        {
        
            if let destinationVC = segue.destinationViewController as? ContributionDetailsUITableViewController {
               
                    destinationVC.gift = self.gift
                    
            }
        }
    }

}