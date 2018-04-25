//
//  SignUpEmailViewController.swift
//  KarmaPro
//
//  Created by Macbook Pro on 28/08/17.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

import UIKit

import CoreLocation

import SDWebImage

import FBSDKLoginKit
import FacebookLogin
import FacebookCore

import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseAnalytics
import FirebaseMessaging
import FirebaseDatabase
import FirebaseInstanceID

class PaidMessageViewController: UIViewController ,  UITableViewDelegate , UITableViewDataSource , CLLocationManagerDelegate {

    
    
    @IBOutlet weak var bottomTableViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var heightKarmaProView: NSLayoutConstraint!
    @IBOutlet weak var imageViewNOmessage:UIImageView!
    @IBOutlet weak var karmaProTitleLabel:UILabel!
   
    @IBOutlet weak var getButtonOut:UIButton!
    var FiresTimeSendMSG : Bool = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var  locationCor =  CLLocation()
    var  locationCorSend =  CLLocation()
    var  locationCorCheck =  CLLocation()
    var  locationManager = CLLocationManager()
    var  ArrayAll = [UserStringHold]()
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var loginUserId = String()
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    @IBOutlet weak var paidView : UIView!
    @IBOutlet weak var mytableView: UITableView!
    @IBOutlet weak var karmahhLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    let probhitedWordRes = ["too","dick"]//,"","","","","","","","","","",""
    var arrayMessageAll    = [MessageStringhold]()
    var arrayMessageFinal  = [MessageStringhold]()
    var arrayHelperMessageF  = [MessageStringhold]()
    var StrHoldTemp = String()
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        self.funcDesigne()
        imageViewNOmessage.isHidden = true
        
        //loading userTo identity
         self.fetchUserfromfirebase()
        
        
        
        
        if  appDelegate.paidkarmBool == true
        {
            paidView.isHidden = true
            heightKarmaProView.constant = 10
            bottomTableViewConstraint.constant = 0
        }
        
        
        
        //---------------Location of user ------------------------------------------------
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
        }
        //If User not logout app
        if !(UserDefaults.standard.object(forKey: "userLoginKey") != nil)
        {
            
            let defaults = UserDefaults.standard
            defaults.set("false", forKey: "userLoginKey")
        }
        else
        {
            let defaults = UserDefaults.standard
            let loginBool = defaults.string(forKey: "userLoginKey")
            print(loginBool)
            
            if  loginBool == "true"
            {
                
                self.checkifUserIsLoggedIn()
                
            }
            
            
        }

        self.sendUserLocationToUpdate()


        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        self.navigationItem.title = "KarmaPro"
        
        mytableView.register(UINib(nibName: "RestrictionMSGTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        self.automaticallyAdjustsScrollViewInsets = false
        mytableView.delegate = self
        mytableView.dataSource = self
        
        
        // reloade data from firebase 
        
        
        
        // Label fit with string.
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        if screenWidth < 330
        {
            var leftRight = screenWidth - 260
            leftRight = leftRight/2
            leftRight = leftRight-20
            
            
            
//            karmahhLabel.numberOfLines = 1;
//            karmahhLabel.minimumScaleFactor = 8.0
//            karmahhLabel.adjustsFontSizeToFitWidth = true
//            karmahhLabel.sizeToFit()
//            karmahhLabel.text = "KARMAHHPRO"
//            
//            descLabel.numberOfLines = 0;
//            descLabel.minimumScaleFactor = 8.0
//            descLabel.adjustsFontSizeToFitWidth = true
//            descLabel.sizeToFit()
//            descLabel.text = "Sign up today for pro edition and respond to your messages and give them the chance to reveal themselves "
        }
        

   }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        self.fetchUserfromfirebase()
        self.observeMessage()
        DispatchQueue.main.async
        {
                self.mytableView.reloadData()
        }
        imageViewNOmessage.isHidden = true
       // self.getButtonOut.isHidden = false
        //descLabel.text = "Sign up today for pro edition and respond to your messages and give them the chance to reveal themselves"
        if  appDelegate.paidkarmBool == true
        {
            paidView.isHidden = true
            heightKarmaProView.constant = 10
            bottomTableViewConstraint.constant = 0
            
            
            
        }
        
    }
    override func viewWillDisappear(_ animated: Bool)
    {
         super.viewWillDisappear(animated) // No need for semicolon
        self.fetchUserfromfirebase()
        self.observeMessage()
        DispatchQueue.main.async
        {
                self.mytableView.reloadData()
        }
        
    }
    
    // MARK: Update user locatio to get in 20 miles.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.appLocationCurrent = locations.last!
        locationCor = locations.last!
        DispatchQueue.main.async
            {
                self.sendUserLocationToUpdate()
                
        }
        //self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Errors: " + error.localizedDescription)
    }
    func sendUserLocationToUpdate()
    {
        
        //print("Post location of user ")
        Auth.auth().addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
            
        
        let ref = Database.database().reference().child("Users")
        let FromuserID = Auth.auth().currentUser?.uid
        //let ch2  = ref.child(userID!)
        let timeSnap = Int(NSDate().timeIntervalSince1970)
        var myStringTime = String(timeSnap)
       // let childRef = ref.childByAutoId()
        let childRef = ref.child(FromuserID!)
        
        let values = [  "latitude" : "\(self.locationCor.coordinate.latitude)" , "longitude" : "\(self.locationCor.coordinate.longitude)"  ] as [String : Any]
        childRef.updateChildValues(values , withCompletionBlock: {(error , ref )in
            if error != nil
            {
                self.container.removeFromSuperview()
                self.actInd.stopAnimating()
                print(error!)
                
                return
            }else
            {
                self.container.removeFromSuperview()
                self.actInd.stopAnimating()
               // print("Saved sucess fully")
                
                
            }
        })
        
        
        
            }
        }
        
        
        
    }
    
    
    // Mark: check if user olerdy login So fetch data from firebase and Facebook
    
    func checkifUserIsLoggedIn()
    {
        
        
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
                
                self.view.addSubview(self.container)
                self.actInd.startAnimating()
                
                self.loginUserId = (user?.uid)!
                self.sendUserLocationToUpdate()
                self.fetchUserfromfirebase()
            }
        }
        
        
        //        if let loggedInUsingFBTokenCheck = FBSDKAccessToken.current()
        //        {
        //
        //
        //
        //
        //            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        //            fbLoginManager.logIn(withReadPermissions: ["public_profile","user_birthday",  "user_education_history","user_friends","email","user_likes"], from: self) { (result, error) in
        //                if (error == nil){
        //                    let fbloginresult : FBSDKLoginManagerLoginResult = result!
        //                    if fbloginresult.grantedPermissions != nil
        //                    {
        //
        //                        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        //
        //
        //
        //                        Auth.auth().signIn(with: credential) { (user, error) in
        //                            if let error = error {
        //                                // ...
        //                                return
        //                            }
        //                            let passUserid =  user?.uid
        //                            // User is signed in
        //                            // ...
        //                            self.getFBUserData(userUid: passUserid!)
        //                        }
        //                        
        //                        
        //                    }
        //                }
        //            }
        //            
        //        }
    }
    // MARK: fetch firebase data to send loing Home
    
    func fetchUserfromfirebase()
    {
        //  Database.database().reference().child("Users").observe(.childAdded, with: (snapshot) -> Void, withCancel: ((Error) -> Void)?)
        self.view.addSubview(self.container)
        self.actInd.startAnimating()
        
        ArrayAll.removeAll()
        appDelegate.allUserArray.removeAll()
        
        let ref = Database.database().reference().child("Users")
        
        ref.observe(.childAdded, with: { firDataSnapshot in
            
            print(firDataSnapshot)
            if let firebaseDic = firDataSnapshot.value as? [String: AnyObject]
            {
                //geting data to show usaer idnetification
                let userObj = UserStringHold()
                userObj.setValuesForKeys(firebaseDic)
                self.ArrayAll.append(userObj)
                self.appDelegate.allUserArray.append(userObj)
                
                DispatchQueue.main.async
                {
                        
                        self.mytableView.reloadData()
                        // self.boolBottom = false
                }
                
                
                if let checkUserId = firebaseDic["fireUserid"] as? String
                {
                    if self.loginUserId == checkUserId
                    {
                        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        
                        
                        self.container.removeFromSuperview()
                        self.actInd.stopAnimating()
                        
                        if let firstName = firebaseDic["firstName"] as? String
                        {
                            self.appDelegate.nameForProfile = firstName
                        }
                        if let lastName = firebaseDic["lastName"] as? String
                        {
                            self.appDelegate.LastnameForProfile = lastName
                        }
                        if let picUrl = firebaseDic["picUrl"] as? String
                        {
                            let defaults = UserDefaults.standard
                            defaults.set("true", forKey: "userLoginKey")
                            
                            self.container.removeFromSuperview()
                            self.actInd.stopAnimating()
                            self.appDelegate.picForProfile = picUrl
                            
                          
                            
                        }
                        
                    }
                }
                else
                {
                    self.container.removeFromSuperview()
                    self.actInd.stopAnimating()
                }
                
                //let userObj = UserStringHold()
                //userObj.setValuesForKeys(firebaseDic)
                //self.ArrayAll.append(userObj)
                //  DispatchQueue.main.async{self.myCollectionView.reloadData()}
                
            }
            else
            {
                self.container.removeFromSuperview()
                self.actInd.stopAnimating()
            }
            
        })
        
    }
    
    // MARK: get message to show
    func observeMessage()
    {
       
        self.view.addSubview(self.container)
        self.actInd.startAnimating()
        
        arrayMessageAll.removeAll()
        
        let ref = Database.database().reference().child("Message")
        
        ref.observe(.childAdded, with: { firDataSnapshot in
            
            self.view.addSubview(self.container)
            self.actInd.startAnimating()
            
            print(firDataSnapshot)
            if let firebaseDic = firDataSnapshot.value as? [String: AnyObject]
            {
                if firebaseDic.count > 0
                {

                    
                    
                }
                
                self.imageViewNOmessage.isHidden = true
                //self.descLabel.text = "Sign up today for pro edition and respond to your messages and give them the chance to reveal themselves"
                
                
                
                let userObj = MessageStringhold()
                userObj.setValuesForKeys(firebaseDic)
                self.arrayMessageAll.append(userObj)
                
                if  self.appDelegate.paidkarmBool == true
                {
                self.paidView.isHidden = true
                self.heightKarmaProView.constant = 10
                self.bottomTableViewConstraint.constant = 0
                }
                else
                {
                    self.paidView.isHidden = false
                    self.heightKarmaProView.constant = 190
                    self.bottomTableViewConstraint.constant = 100
                    //self.getButtonOut.isHidden = false
                }
                
                self.container.removeFromSuperview()
                self.actInd.stopAnimating()
                
                DispatchQueue.main.async
                {
                        
                        self.mytableView.reloadData()
                       // self.boolBottom = false
                }
                
            }
            
        }, withCancel: nil )
    }
    
   
    func helperMathodToLoadArray()
    {
        
        
     
    }
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let FromuserID = Auth.auth().currentUser?.uid
        
        arrayMessageFinal.removeAll()
        
        ArrayAll = uniq(source: ArrayAll)
        if ArrayAll.count > 0
        {
            
            
            for var i in (0..<ArrayAll.count)
            {
                self.view.addSubview(self.container)
                self.actInd.startAnimating()
                
                FiresTimeSendMSG = false
                arrayHelperMessageF.removeAll()
                if ArrayAll.count > i
                {
                    let printVal = ArrayAll[i]
                    
                    var intCount = 0
                    
                    for item in arrayMessageAll
                    {
                        arrayMessageAll = uniq(source: arrayMessageAll)
                        
                        if arrayMessageAll.count > intCount
                        {
                            let messageShow   = arrayMessageAll[intCount];
                            
                            //print("Item \(intCount): \(messageShow.MUid)\(messageShow.FromuserID)\("MUid")")
                            
                            
                            
                            if  messageShow.MUid == FromuserID && messageShow.FromuserID == printVal.fireUserid
                            {
                                if messageShow.checkOrNotMSG == "false"
                                {
                                    if FiresTimeSendMSG == false
                                    {
                                        self.arrayHelperMessageF.append(messageShow)
                                    }
                                }
                                else
                                {
                                    if messageShow.checkOrNotMSG == "true"
                                    {
                                        FiresTimeSendMSG = true
                                    }
                                }
                                if FiresTimeSendMSG == true
                                {
                                    arrayHelperMessageF.removeAll()
                                }
                                
                                
                            }
                            else
                            {
                                
                                // arrayMessageAll.remove(at: intCount)
                            }
                            intCount = intCount + 1
                        }
                    }
                    if FiresTimeSendMSG == false
                    {
                        for var i in (0..<arrayHelperMessageF.count)
                        {
                            
                            if arrayHelperMessageF.count > i
                            {
                                let printVal = arrayHelperMessageF[i]
                                self.arrayMessageFinal.append(printVal)
                                arrayMessageFinal = uniq(source: arrayMessageFinal)
                                
                            }
                        }
                    }
                    
                    
                    
                }
                self.container.removeFromSuperview()
                self.actInd.stopAnimating()
                
            }
            
            
        }
        
        let uniqueVals = uniq(source: arrayMessageFinal)
        if uniqueVals.count == 0
        {
            self.showNoMessage()
        }
        return uniqueVals.count;
    }
    
    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }

    func showNoMessage()
    {
        imageViewNOmessage.isHidden = false
        //descLabel.text = "NO Message"
        paidView.isHidden = false
        
       
        self.paidView.isHidden = false
        self.heightKarmaProView.constant = 190
        self.bottomTableViewConstraint.constant = 100
       // self.getButtonOut.isHidden = true
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as! RestrictionMSGTableViewCell;
        
        self.view.addSubview(self.container)
        self.actInd.startAnimating()
        
        arrayMessageFinal = uniq(source: arrayMessageFinal)
        
        if arrayMessageFinal.count > indexPath.row
        {
        
        let messageShow   = arrayMessageFinal[indexPath.row];
        let FromuserID = Auth.auth().currentUser?.uid
        
       
        
        if messageShow.MUid == FromuserID
        {
         
            
            cell.messageLabel?.text = ProfanityFilter.sharedInstance.cleanUp(messageShow.messageText!)
            //cell.messageLabel?.text = messageShow.messageText
            if  appDelegate.paidkarmBool == true
            {
                cell.sendCellButto.addTarget(self, action: #selector(PaidMessageViewController.sendCellAction(_:)), for:.touchUpInside)
                cell.sendCellButto.tag = indexPath.row
                if ArrayAll.count > 0
                {
                    for var i in (0..<ArrayAll.count)
                    {
                        if ArrayAll.count > i
                        {
                            let printVal = ArrayAll[i]
                            
                                    if printVal.fireUserid == messageShow.FromuserID
                                    {
                                           cell.identyLabel?.text  = "From: " + printVal.firstName!
                                    }
                            
                                }
                        
                    }
                    
                    
                }
                
              
            }
            else
            {
              cell.identyLabel?.text  = "From: " + "Anonymous"
            }
           
            
        }
    }
        self.container.removeFromSuperview()
        self.actInd.stopAnimating()
        return cell;
        
    }
    // select cell action
    @IBAction func sendCellAction(_ sender : UIButton)
    {
        
        if arrayMessageFinal.count > sender.tag
        {
            self.view.addSubview(self.container)
            self.actInd.startAnimating()
            
            
            let messageShow   = arrayMessageFinal[sender.tag];
            
            let FromuserID = Auth.auth().currentUser?.uid
            
            //self.mytableView.reloadData()
            
            if messageShow.MUid == FromuserID
            {
                //  cell.messageLabel?.text = messageShow.messageText!//ProfanityFilter.sharedInstance.cleanUp(messageShow.messageText!)
                //cell.messageLabel?.text = messageShow.messageText
                if  self.appDelegate.paidkarmBool == true
                {
                    if self.ArrayAll.count > 0
                    {
                        for var i in (0..<self.ArrayAll.count)
                        {
                            if self.ArrayAll.count > i
                            {
                                let printVal = self.ArrayAll[i]
                                
                                if printVal.fireUserid == messageShow.FromuserID
                                {
                                    let ref = Database.database().reference().child("Message")
                                    let FromuserID = Auth.auth().currentUser?.uid
                                    
                                    let childRef = ref.child(messageShow.strKeyMSG!)
                                    let values = [  "checkOrNotMSG" : "true"    ] as [String : Any]
                                    childRef.updateChildValues(values , withCompletionBlock: {(error , ref )in
                                        if error != nil
                                        {
                                            print(error! )
                                            
                                            return
                                        }
                                        else
                                        {
                                            let distination : ChatLogViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatLogViewController") as! ChatLogViewController
                                            //let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                            //dis.nameTo = appDelegate.nameToSend
                                            distination.picTo   =  printVal.picUrl!
                                            distination.nameTo  = printVal.firstName!//appDelegate.nameToSend
                                            distination.lastNameTo  = printVal.lastName!
                                            distination.MUid    = printVal.fireUserid!//appDelegate.MUid
                                            
                                            let transition = CATransition()
                                            transition.duration = 0.0
                                            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
                                            transition.type = kCATransitionPush
                                            transition.subtype = kCATransitionFromRight
                                            self.navigationController?.view.layer.add(transition, forKey:kCATransitionFromRight)
                                            self.navigationController?.pushViewController(distination, animated: true)
                                            
                                        }
                                        
                                    })
                                    
                                    
                                }
                                
                            }
                            
                        }
                    }
                    
                    
                }
                
                
            }
            
            self.container.removeFromSuperview()
            self.actInd.stopAnimating()
        }
        
    }
    
    

  
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 75
    }

    // MARK: paid for new user @IBAction func chatAction(_ sender: UIButton)
    @IBAction func sendToPaidVC(_ sender: UIButton )
    {
        let distination : PaidKarmaProViewController = self.storyboard?.instantiateViewController(withIdentifier: "PaidKarmaProViewController") as! PaidKarmaProViewController
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        transition.type = kCATransitionFade
        transition.subtype = kCATransitionFromRight
        navigationController?.view.layer.add(transition, forKey:kCATransitionFromRight)
        self.navigationController?.pushViewController(distination, animated: true)
    }

    // MARK: Designe
    func funcDesigne()
    {
        
        
        // --------------------loading view---------------------
        container.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)//self.view.frame
        container.center = self.view.center
        container.backgroundColor = UIColor( red: 00, green: 0.0, blue:00, alpha: 0.4 )//UIColor.brown
        
        loadingView.frame =  CGRect(x: 0, y: 0, width: 100, height: 100)
        loadingView.center = self.view.center
        loadingView.backgroundColor = UIColor.gray
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        actInd.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        actInd.center = CGPoint(x:loadingView.frame.size.width / 2,  y: loadingView.frame.size.height / 2)
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        
        
        //---------------------------------------------------------------
    }


}
extension Array {
    
    func filterDuplicates( includeElement: @escaping (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        var results = [Element]()
        
        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        
        return results
    }
}

