//
//  ViewController.swift
//  KarmaPro
//
//  Created by Macbook Pro on 28/08/17.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

import UIKit


import FBSDKLoginKit
import FacebookLogin
import FacebookCore

import CoreLocation

import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseAnalytics
import FirebaseMessaging
import FirebaseDatabase
import FirebaseInstanceID


class HomeViewController: UIViewController , UITextFieldDelegate , UINavigationControllerDelegate,  UITabBarControllerDelegate , UINavigationBarDelegate, UIAlertViewDelegate , CLLocationManagerDelegate {

    
//    var emailFBStr
//    firstNameFBStr
//    lastNameFBStr
    
    var navigationTemp : HomeViewController!
    var  locationCor =  CLLocation()
    var  locationCorSend =  CLLocation()
    var  locationCorCheck =  CLLocation()
    
    var  locationManager = CLLocationManager()
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var loginUserId = String()
    //passwor and email
    let passS = "dipesh8680"
    let emailS = "ram@gmail.com"
    
      var window: UIWindow?
    var fireUseridapp = String()
    @IBOutlet weak var facebookViewbutton: UIView!
    @IBOutlet weak var proLabelOut: UILabel!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var karmaLabelOut: UILabel!
    var  ArrayAll = [UserStringHold]()
    @IBOutlet weak var passTF: UITextField!
    var  picTo = String()
    var  nameTo = String()
    var  emailStr = String()

    var  lastNameTo = String()

    var dict : [String : AnyObject]!
    
    
    var activeTextField: UITextField!
    var viewWasMoved: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
     

        //---------------Location of user ------------------------------------------------
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
        }
        

        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        if screenWidth < 330
        {
            var leftRight = screenWidth - 260
            leftRight = leftRight/2
            leftRight = leftRight-20
            
          
            
            karmaLabelOut.numberOfLines = 1;
            karmaLabelOut.minimumScaleFactor = 8.0
            karmaLabelOut.adjustsFontSizeToFitWidth = true
            karmaLabelOut.sizeToFit()
            karmaLabelOut.text = "K A R M A"
            
            proLabelOut.numberOfLines = 1;
            proLabelOut.minimumScaleFactor = 8.0
            proLabelOut.adjustsFontSizeToFitWidth = true
            proLabelOut.sizeToFit()
            proLabelOut.text = " P R O"
        }
        
       
       
        
        
        userNameTF.text = emailS
        passTF.text = passS
        
        self.navigationController?.isNavigationBarHidden = true
      // self.checkifUserIsLoggedIn()
        
       // let loginButton = LoginButton(readPermissions: [ .publicProfile ])
       // loginButton.center = view.center
        
        //facebookViewbutton.addSubview(loginButton)
        
         navigationController?.navigationBar.barTintColor = UIColor(red: 39/255, green: 108/255, blue: 173/255, alpha: 1.0)
        
        userNameTF.delegate = self
        passTF.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        self.Desinge()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    // MARK: Update user locatio to get in 20 miles.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.appLocationCurrent = locations.last!
        locationCor = locations.last!
        DispatchQueue.main.async
        {
            
           // self.sendUserLocationToUpdate()

        }
        //self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Errors: " + error.localizedDescription)
    }
    func sendUserLocationToUpdate()
    {
        
           // print("Post location of user ")
            
        
            let ref = Database.database().reference().child("Users")
            let FromuserID = Auth.auth().currentUser?.uid
            //let ch2  = ref.child(userID!)
            let timeSnap = Int(NSDate().timeIntervalSince1970)
            var myStringTime = String(timeSnap)
        
            let childRef = ref.child(FromuserID!)
        
            //let childRef = ref.childByAutoId()
        
            let values = [  "latitude" : "\(locationCor.coordinate.latitude)" , "longitude" : "\(locationCor.coordinate.longitude)"  ] as [String : Any]
            childRef.updateChildValues(values , withCompletionBlock: {(error , ref )in
                if error != nil
                {
                    self.container.removeFromSuperview()
                    self.actInd.stopAnimating()
                    print(error! )
                    
                    return
                }else
                {
                    self.container.removeFromSuperview()
                    self.actInd.stopAnimating()
                   // print("Saved sucess fully")
                   
                    
                }
            })
            
            
        
        
    }
    

    
    
    
    @IBAction func signUpKarmaAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SignUPKarmaViewController") as! SignUPKarmaViewController
        self.navigationController?.pushViewController(newViewController, animated: true)
        
      


        
//        let destVC = AppNavigator.getSignUpController()
//        destVC.locationCor = locationCor
//        AppNavigator.navigator.pushViewController(destVC, animated: true)
        

//        let distination : SignUPKarmaViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUPKarmaViewController") as! SignUPKarmaViewController
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
//        transition.type = kCATransitionFade
//        transition.subtype = kCATransitionFromRight
//        navigationController?.view.layer.add(transition, forKey:kCATransitionFromRight)
//        //let _ = navigationController?.popViewController(animated: false)
//        
//        distination.locationCor = locationCor
//        self.navigationController?.pushViewController(distination, animated: true)
//      
        
       
        
            //self.navigationTemp.na.pushViewController(vc, animated: true)
        
        //pushViewController(distination, animated: true)
        
    }
    
//    @IBAction func signUpEmailAction(_ sender: UIButton)
//    {
//        let distination : PaidMessageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PaidMessageViewController") as! PaidMessageViewController
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        transition.type = kCATransitionFade
//        transition.subtype = kCATransitionFromBottom
//        navigationController?.view.layer.add(transition, forKey:kCATransition)
//        //let _ = navigationController?.popViewController(animated: false)
//        
//        self.navigationController?.pushViewController(distination, animated: true)
//    }
    

    
    
    // MARK: fetch firebase data to send loing Home
        func fetchUserfromfirebase()
        {
            
            
            //  Database.database().reference().child("Users").observe(.childAdded, with: (snapshot) -> Void, withCancel: ((Error) -> Void)?)
            
            let ref = Database.database().reference().child("Users")
            
            ref.observe(.childAdded, with: { firDataSnapshot in
                
                print(firDataSnapshot)
                if let firebaseDic = firDataSnapshot.value as? [String: AnyObject]
                {
                    
                    
                    if let checkUserId = firebaseDic["fireUserid"] as? String
                    {
                        if self.loginUserId == checkUserId
                        {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            
                            
                            if let firstName = firebaseDic["firstName"] as? String
                            {
                                 appDelegate.nameForProfile = firstName
                            }
                            if let lastName = firebaseDic["lastName"] as? String
                            {
                                appDelegate.LastnameForProfile = lastName
                            }
                            if let picUrl = firebaseDic["picUrl"] as? String
                            {
                                let defaults = UserDefaults.standard
                                defaults.set("true", forKey: "userLoginKey")
                                
                                self.dismiss(animated: true, completion: nil)
                                self.container.removeFromSuperview()
                                self.actInd.stopAnimating()
                                appDelegate.picForProfile = picUrl
                                
                                let distination : TabbarVC = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
                                let transition = CATransition()
                                transition.duration = 0.5
                                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                                transition.type = kCATransitionFade
                                transition.subtype = kCATransitionFromBottom
                                
                                
                                self.navigationController?.view.layer.add(transition, forKey:kCATransition)
                               
                                self.navigationController?.pushViewController(distination, animated: true)
                                
                           }
                            
                        }
                    }
                    else
                    {
                        self.container.removeFromSuperview()
                        self.actInd.stopAnimating()
                    }

                   // let userObj = UserStringHold()
                   // userObj.setValuesForKeys(firebaseDic)
                   // self.ArrayAll.append(userObj)
                  //  DispatchQueue.main.async{self.myCollectionView.reloadData()}
                    
                }
                else
                {
                    self.container.removeFromSuperview()
                    self.actInd.stopAnimating()
                }
                
            })
            
        }
    
    // MARK: sign in facebook Mathod action
    @IBAction func signUpFaceBook(_ sender: UIButton)
    {
        self.view.addSubview(self.container)
        self.actInd.startAnimating()
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile","user_birthday",  "user_education_history","user_friends","email","user_likes"], from: self) { (result, error) in
            if (error == nil)
            {
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil
                {
                    
                    
                 let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                    
                    print(credential)
                    
                    Auth.auth().signIn(with: credential)
                    { (user, error) in
                        if let error = error
                        {
                            self.container.removeFromSuperview()
                            self.actInd.stopAnimating()
                            return
                        }
                        let passUserid =  user?.uid
                        
                        DispatchQueue.main.async
                        {
                           // self.sendUserLocationToUpdate()
                            self.getFBUserData(userUid: passUserid!)
                        }
                    }
                
                   
                }
                else
                {
                    self.container.removeFromSuperview()
                    self.actInd.stopAnimating()
                }
            }
            else
            {
                self.container.removeFromSuperview()
                self.actInd.stopAnimating()
            }
        }
        
    }
    
    // MARK: Get facebook data for facebook login Mathod
    
    func getFBUserData( userUid :String )
    {
        
        
        if((FBSDKAccessToken.current()) != nil)
        {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large) , email , age_range , gender , verified,education , birthday  , likes"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil)
                {
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                    
                    
                    
                    if let likesDic  =  self.dict["likes"] as? AnyObject
                    {
                        print(likesDic)
                        
                        if let likeData  =  likesDic["data"] as? NSArray
                        {
                            print(likeData)
                            
                            for propInfo in likeData {
                                
                                let propObject = propInfo as! NSDictionary
                                print(propObject)
                                
                                
                                let idudate  =  propObject["created_time"] as? String
                                let likeItemName  =  propObject["name"] as? String
                                
                                
                               // self.biggerTagListView.addTag(likeItemName!)
                                //                                self.biggerTagListView.addTag("Pomotodo")
                                //                                self.biggerTagListView.addTag("Halo Word")
                                print(likeItemName as Any)
                                print(idudate as Any)
                            }
                        }
                        
                        
                        
                        //let dataArrayLike = likesDic
                    }
                    
                    
                    
                    if let email  =  self.dict["email"] as? String
                    {
                        self.emailStr = email
                        //self.passwordToFirebase = "123456"
                        print(email)
                        
                    }
                    if let ageR  =  self.dict["age_range"] as? String
                    {
                      //  self.ageRang = ageR
                        print(ageR)

                        
                        
                    }
                    
                    
                    if let education1  =  self.dict["education"] as? NSArray
                    {
                        print(education1)
                        
                        for propInfo in education1 {
                            
                            let propObject = propInfo as! NSDictionary
                            print(propObject)
                            
                            
                            let idu  =  propObject["school"] as? NSDictionary
                            let collegeName  =  idu?["name"] as? String
                            
                            print(collegeName as Any)
                            
                           // self.collegeStr = collegeName!
                           // self.universityLavel.text = self.collegeStr
                        }
                        
                        //                        for item in education1 {
                        //                            let content = item["id"] as! String
                        ////                            let identifier = item["identifier"] as! String
                        ////                            let title = item["title"] as! Int
                        ////                            let type = item["type"] as! String
                        ////                            print(content, identifier, title, type)
                        //                        }
                        
                        
                    }
                    
                    if let firstName  =  self.dict["first_name"] as? String
                    {
                       self.nameTo = firstName
                      
                        
                        if let lastNameTosa  =  self.dict["first_name"] as? String
                        {

                        self.lastNameTo = lastNameTosa
                        }
                      
                        
                        //  distination.nameString = firstName
                        //print(firesName)firstName
                    }
                    if let gender  =  self.dict["gender"] as? String
                    {
                       // self.genderToFirebase = gender
                        
                        // distination.genderString = gender
                        //print(firesName)firstName
                    }
                    if let picture = self.dict["picture"] as? NSDictionary ,   let data = picture ["data"] as? NSDictionary , let url1 = data["url"] as? String
                    {
                        print(url1)
                        
                        
                        self.picTo = url1

                        
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.picForProfile = self.picTo
                        appDelegate.nameForProfile = self.nameTo
                        appDelegate.LastnameForProfile = self.lastNameTo
                        

                            //   Sgin up and save Facebook login user
                                print("You have successfully signed up")
                                
                                
                                let ref = Database.database().reference()
                                let childRef = ref.child("Users").child(userUid)
                                // childRef = childRef.childByAutoId()
                                
                                let values = [ "fireUserid" : userUid , "firstName" : self.nameTo , "lastName" : self.lastNameTo ,  "picUrl" : self.picTo, "email" : self.emailStr ,  "password" : self.emailStr ,  "latitude" : "\(self.locationCor.coordinate.latitude)" , "longitude" : "\(self.locationCor.coordinate.longitude)" ] as [String : Any]
                                childRef.updateChildValues(values, withCompletionBlock: {(error , ref )in
                                    if error != nil
                                    {
                                        self.container.removeFromSuperview()
                                        self.actInd.stopAnimating()
                                        
                                        print(error! )
                                        return
                                    }else
                                    {
                                        
                                        let defaults = UserDefaults.standard
                                        defaults.set("true", forKey: "userLoginKey")
                                        
                                       // print("Saved sucess fully")
                                        self.container.removeFromSuperview()
                                        self.actInd.stopAnimating()
                                        
                                        let distination : TabbarVC = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
                                       
                                        let transition = CATransition()
                                        transition.duration = 0.5
                                        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                                        transition.type = kCATransitionFade
                                        transition.subtype = kCATransitionFromBottom
                                        self.navigationController?.view.layer.add(transition, forKey:kCATransition)
                                        
                                        //distination.picTo = self.picTo
                                        //distination.nameTo = self.nameTo
                                        self.navigationController?.pushViewController(distination, animated: true)
                                        
                                        
                                    }
                                })
                        
                        
                    }
                    
                }
                else
                {
                    self.container.removeFromSuperview()
                    self.actInd.stopAnimating()
                }
            })
        }
        else
        {
        self.container.removeFromSuperview()
        self.actInd.stopAnimating()
        }
    }
    
    // MARK: Sgin up Firebase login user

    
    @IBAction func loginAction(_ sender: UIButton)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
         appDelegate.tabCheckbool = true
        self.view.addSubview(self.container)
        self.actInd.startAnimating()
        
        if userNameTF?.text != "" && passTF?.text != ""
        {
            
            Auth.auth().signIn(withEmail: (userNameTF?.text)! , password: (passTF?.text)! ) { (user, error) in
                if let error = error
                {
                    print(error.localizedDescription)
                    self.container.removeFromSuperview()
                    self.actInd.stopAnimating()
                    let moreAlert=UIAlertView(title: "Error", message: error.localizedDescription, delegate: self, cancelButtonTitle: "Ok")
                    //  var moreAlert=UIAlertView(title: "Photo", message: "", delegate: self, cancelButtonTitle: "No Thanks!", otherButtonTitles: "Save Image", "Email", "Facebook", "Whatsapp" )
                    
                    moreAlert.tag=111;
                    moreAlert.show()
                }
                else if let user = user
                {
             
                    print(user)
                    
                    self.loginUserId = user.uid
                    
                    DispatchQueue.main.async
                    {
                    
                   // self.sendUserLocationToUpdate()
                    self.fetchUserfromfirebase()
                    }
                   
                }
                }
            
        }
        else
        {
            let moreAlert=UIAlertView(title: "Please enter all field", message: "", delegate: self, cancelButtonTitle: "Ok")
            //  var moreAlert=UIAlertView(title: "Photo", message: "", delegate: self, cancelButtonTitle: "No Thanks!", otherButtonTitles: "Save Image", "Email", "Facebook", "Whatsapp" )
            
            moreAlert.tag=111;
            moreAlert.show()
            
            

            self.container.removeFromSuperview()
            self.actInd.stopAnimating()
        }
//        else
//        {
//        
//    
//        if userNameTF?.text != "" { // 1
//          Auth.auth().signInAnonymously(completion: { (user, error) in // 2
//                if let err = error { // 3
//                    print(err.localizedDescription)
//                    return
//                }
//            let isAnonymous = user!.isAnonymous  // true
//            let uid = user!.uid
//            
//            print(isAnonymous)
//            print(uid)
//          
//            
//            let distination : TabbarVC = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
//            let transition = CATransition()
//            transition.duration = 0.5
//            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//            transition.type = kCATransitionFade
//            transition.subtype = kCATransitionFromBottom
//            self.navigationController?.view.layer.add(transition, forKey:kCATransition)
//            self.navigationController?.pushViewController(distination, animated: true)
//
//          })
//        }
//        }

        
    }

    // alertHendle button
    func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int)
    {
        if alertView.tag==111
        {
            if buttonIndex==0
            {
                print("No Thanks!")
            }
            else if buttonIndex==1
            {
                print("Save Image")
            }
            else if buttonIndex == 2
            {
                print("Email")
            }
            else if buttonIndex == 3
            {
                print("Facebook")
            }
            else if buttonIndex == 4
            {
                print("Whatsapp")
            }
        }
    }
    
    
    
    // MARK: keyboard up delegate mathod
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        
        
        var aRect: CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        
        
        var activeTextFieldOrigin: CGPoint!
        if  let activeTextFieldRect: CGRect? = activeTextField?.frame {
            activeTextFieldOrigin  = activeTextFieldRect?.origin
        }
        
        if activeTextFieldOrigin != nil {
            
            
            
            if (!aRect.contains(activeTextFieldOrigin!)) {
                self.viewWasMoved = true
                self.view.frame.origin.y = 0
                self.view.frame.origin.y -= keyboardSize!.height
            } else {
                self.viewWasMoved = false
            }
        }
    }
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

 
    func Desinge()
    {
        
        
        
        let color = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        userNameTF.attributedPlaceholder = NSAttributedString(string:" Username " , attributes: [NSForegroundColorAttributeName : color])
        passTF.attributedPlaceholder = NSAttributedString(string:" Password " , attributes: [NSForegroundColorAttributeName : color])

        

        
        // UIColor(red: 0/255, green: 159/255, blue: 184/255, alpha: 1.0).cgColor
        let border = CALayer()
        let width = CGFloat(1.5)
        border.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5).cgColor
        border.frame = CGRect(x: 0, y: userNameTF.frame.size.height - width, width:  userNameTF.frame.size.width, height: userNameTF.frame.size.height)
        
        border.borderWidth = width
        userNameTF.layer.addSublayer(border)
        userNameTF.layer.masksToBounds = true
        
        let borderpassTextF = CALayer()
        borderpassTextF.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5).cgColor
        borderpassTextF.frame = CGRect(x: 0, y: passTF.frame.size.height - width, width:  passTF.frame.size.width, height: passTF.frame.size.height)
        
        borderpassTextF.borderWidth = width
        passTF.layer.addSublayer(borderpassTextF)
        passTF.layer.masksToBounds = true
    }


}

