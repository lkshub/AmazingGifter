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
import FBSDKLoginKit
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
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
     
       
    print("PayPal Payment Cancelled")
      //  resultText = ""
      //  successView.hidden = true
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            
            let alertController = UIAlertController(title: "", message: "Thanks for your contribution", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            let delay = 2.0 * Double(NSEC_PER_SEC)
            let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: time, execute: {
                alertController.dismiss(animated: true, completion: nil)
            })
            self.contribute()
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            
       //     self.resultText = completedPayment.description
      //      self.showSuccess()
            print("testing!!")
        })
    }
    
    
    // MARK: Future Payments
    
    @IBAction func authorizeFuturePaymentsAction(_ sender: AnyObject) {
        let futurePaymentViewController = PayPalFuturePaymentViewController(configuration: payPalConfig, delegate: self)
        present(futurePaymentViewController!, animated: true, completion: nil)
    }
    
    
    func payPalFuturePaymentDidCancel(_ futurePaymentViewController: PayPalFuturePaymentViewController) {
        print("PayPal Future Payment Authorization Canceled")
     //   successView.hidden = true
        futurePaymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalFuturePaymentViewController(_ futurePaymentViewController: PayPalFuturePaymentViewController, didAuthorizeFuturePayment futurePaymentAuthorization: [AnyHashable: Any]) {
        print("PayPal Future Payment Authorization Success!")
        // send authorization to your server to get refresh token.
        futurePaymentViewController.dismiss(animated: true, completion: { () -> Void in
          //  self.resultText = futurePaymentAuthorization.description
           // self.showSuccess()
        })
    }
    
    // MARK: Profile Sharing
    
    @IBAction func authorizeProfileSharingAction(_ sender: AnyObject) {
        let scopes = [kPayPalOAuth2ScopeOpenId, kPayPalOAuth2ScopeEmail, kPayPalOAuth2ScopeAddress, kPayPalOAuth2ScopePhone]
        let profileSharingViewController = PayPalProfileSharingViewController(scopeValues: NSSet(array: scopes) as Set<NSObject>, configuration: payPalConfig, delegate: self)
        present(profileSharingViewController!, animated: true, completion: nil)
    }
    
    // PayPalProfileSharingDelegate
    
    func userDidCancel(_ profileSharingViewController: PayPalProfileSharingViewController) {
        print("PayPal Profile Sharing Authorization Canceled")
        //successView.hidden = true
        profileSharingViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalProfileSharingViewController(_ profileSharingViewController: PayPalProfileSharingViewController, userDidLogInWithAuthorization profileSharingAuthorization: [AnyHashable: Any]) {
        print("PayPal Profile Sharing Authorization Success!")
        
        // send authorization to your server
        
        profileSharingViewController.dismiss(animated: true, completion: { () -> Void in
       //     self.resultText = profileSharingAuthorization.description
        //    self.showSuccess()
        })
        
    }


    
    //////////////////////paypal testing code
    
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var itemIDLabel: UILabel!
    @IBOutlet weak var contributrTextField: UITextField!
    
    @IBOutlet weak var contributionDetailsOutlet: UIButton!
 
    @IBAction func contributeAction(_ sender: UIButton) {
        
        //paypal testing
      if(self.contributrTextField.text != ""){
            
        
        let item1 = PayPalItem(name: "demo", withQuantity: 1, withPrice:   NSDecimalNumber(string: self.contributrTextField.text), withCurrency: "USD", withSku: "Hip-0037")

        let items = [item1]
        let subtotal = PayPalItem.totalPrice(forItems: items)
        
        // Optional: include payment details
        
        let shipping = NSDecimalNumber(string: "0")
        let tax = NSDecimalNumber(string: "0")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        
        let total = subtotal.adding(shipping).adding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Demo Contribution", intent: .sale)
        
        payment.items = items
        payment.paymentDetails = paymentDetails
        
        if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)
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
    @IBAction func viewWebsiteAction(_ sender: UIButton) {
                UIApplication.shared.openURL(URL(string: (gift?.itemURL!)!)!)
    }
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    
    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var itemProgressLabel: UILabel!
    
    @IBOutlet weak var PriceLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var receiverLabel: UILabel!
    @IBOutlet weak var initiatorLabel: UILabel!
    
    //@IBOutlet weak var facebookShare: FBSDKShareButton!

    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //paypal testing
        
        payPalConfig.acceptCreditCards = acceptCreditCards;
        payPalConfig.merchantName = "AmazingGifter Testing."
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.payPalShippingAddressOption = .none;
//paypal testing
        
        
        let url = URL(string: (gift?.pictureURL)!)
        let data = try? Data(contentsOf: url!)
        giftImageView.contentMode = .scaleAspectFit
        giftImageView.image = UIImage(data: data!)
        itemNameLabel.text = gift?.name
        itemIDLabel.text = gift?.itemID
        PriceLabel.text = String(gift!.price!)
              brain.ref.child("user").child(self.gift!.initiatorID!).child("name").observeSingleEvent(of: .value, with: { snapshot in
            self.initiatorLabel.text = snapshot.value! as? String
        })
        brain.ref.child("user").child(self.gift!.receiverID!).child("name").observeSingleEvent(of: .value, with: { snapshot in
            self.receiverLabel.text = snapshot.value! as? String
            self.gift?.receiverName = snapshot.value! as? String
            
        })
        
        itemProgressLabel.text = String(gift!.progress!) + "/" + String(gift!.price!)
        postTimeLabel.text = gift?.postTime
        reasonLabel.text = gift?.reason
        dueDateLabel.text = gift?.dueDate
        progressView.transform = CGAffineTransform( scaleX: 1, y: 3)
        progressView.setProgress(Float((gift?.progress)!/(gift?.price)!), animated: true)
    }
    
    @IBAction func shareBtnClicked(_ sender: AnyObject) {
        let loginResult: FBSDKAccessToken = FBSDKAccessToken.current()
        //print(loginResult.permissions)
        if !loginResult.permissions.contains("publish_actions")
        {
            //print(loginResult.permissions)
            
            let manager : FBSDKLoginManager = FBSDKLoginManager()
            manager.logIn(withPublishPermissions: ["publish_actions"], from: self, handler: { (result, error) in
                //print(result.grantedPermissions)
                if (error != nil) {
                    print(error?.localizedDescription as Any)
                }
                else if (result?.isCancelled)! {
                    // Handle cancellations
                }
                else {
                    if (result?.grantedPermissions.contains("publish_actions"))!  {
                        self.shareGift()

                    }
                }

            })
            
        }else{
            shareGift()
        }
        
    }
    @IBAction func deleteBtnClicked(_ sender: UIButton) {
        if (self.gift?.progress == 0 && self.gift?.initiatorID == brain.user.uid){
            deleteGift(self.gift!)
        }else{
            let alertController = UIAlertController(title: "", message:
                "Gift cannot be deleted!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func shareGift(){
        let photoContent: FBSDKSharePhotoContent = FBSDKSharePhotoContent()
        let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
        //content.contentURL = NSURL(string: "https://www.facebook.com/FacebookDevelopers")
        content.contentTitle = "An amazing gift for \(self.gift!.receiverName!)"
        content.contentDescription = self.gift?.name!
        //let photo : FBSDKSharePhoto = FBSDKSharePhoto()
        content.imageURL = URL(string: (self.gift?.pictureURL)!)
        let thisURL = URL(string: (self.gift?.pictureURL)!)
        let data = try? Data(contentsOf: thisURL!)
        let photo = FBSDKSharePhoto()
        photo.image = UIImage(data:data!)
        photoContent.photos = [photo]
        photo.caption = "Test"
        //facebookShare.enabled = true
        FBSDKShareDialog.show(from: self, with: photoContent, delegate: nil)
    }
 
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }
        return tableView.sectionHeaderHeight
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }
        return tableView.sectionFooterHeight
    }
    func contribute(){
        let autoId = self.gift!.auto_id!
        if(!(self.contributrTextField.text?.isEmpty)!){
            let contribution = Float(self.contributrTextField.text!)!
            if contribution > 0{
                self.brain.ref.child("gift").child(autoId).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let value = snapshot.value as? [String : Any]
                    let progress = value!["progress"] as! Float
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
        
        let todaysDate:Date = Date()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let DateInFormat:String = dateFormatter.string(from: todaysDate)

        let contributionDic = ["amount" : Double(self.contributrTextField.text!)! as Double,
                               "contributor_id" : brain.user.uid as String,
                               "contributor_name" : brain.user.profile!["name"] as! String,
                               "time" : DateInFormat,
                               ] as [String : Any]
        
 

        contri1Ref.setValue(contributionDic)
        contributrTextField.text = nil
    }
    
    func deleteGift(_ gift:Gift)  {
        brain.ref.child("gift").child(self.gift!.auto_id!).removeValue()
        if(self.gift!.receiverID! == self.gift!.initiatorID!){
            brain.ref.child("user").child(brain.visitedUser!.uid).child("my_gift").child("wish_list").child(self.gift!.auto_id!).removeValue()
        }else{
            brain.ref.child("user").child(brain.visitedUser!.uid).child("my_gift").child("from_friends").child(self.gift!.auto_id!).removeValue()
            brain.ref.child("user").child((self.gift?.initiatorID)!).child("gift_for_friend").child(self.gift!.auto_id!).removeValue()
        }
        goBack()
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contributionDetailsSegue"
        {
        
            if let destinationVC = segue.destination as? ContributionDetailsUITableViewController {
               
                    destinationVC.gift = self.gift
                    
            }
        }
    }

}
