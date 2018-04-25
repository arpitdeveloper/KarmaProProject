//
//  FacebookViewController.swift
//  KarmaPro
//
//  Created by Macbook Pro on 28/08/17.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

import UIKit

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

class FacebookViewController: UIViewController , FloatRatingViewDelegate {

    
    var starAvrg = 0.0
    var avrgCounter = 0.0
    
    //var avrgCounter = 0.0
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var  arrayMessageFinal = [PostStringHold]()
    var fireUseridapp = String()
    
    @IBOutlet weak var starpageSendButton: UIButton!
    
    @IBOutlet weak var giveKarmaButtonOut: UIButton!
    @IBOutlet weak var ratingAvrgLabel: UILabel!
   
    @IBOutlet weak var karmaView: UIView!
    
    var  picTo  = String()
    var  timeLineGetMUid   = String()
    var  nameTo = String()
    var dict : [String : AnyObject]!
    var  emailStr = String()
    var  lastNameTo = String()
    
    var  myTabbarController: TabbarVC!
    
    var isShown:Bool = false
    
    @IBOutlet weak var checkLogOut: UIButton!
    @IBOutlet weak var chatActionImage: UIImageView!
    @IBOutlet weak var chatButtonOutLet: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageProfileView: UIImageView!
    @IBOutlet weak var loyaltyLabel: UILabel!
    @IBOutlet weak var honestyLabel: UILabel!
    @IBOutlet weak var caringLabel: UILabel!
    @IBOutlet var floatRatingView: FloatRatingView!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.funcDesigne()
        
        
      
       


        
        

        
        // Do any additional setup after loading the view.
    
        
//        Auth.auth().addStateDidChangeListener() { auth, user in
//            // 2
//            if user != nil {
//                // 3
//                self.fetchUser()
//            }
//        }
    }
    
    
  
    

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        karmaView.isHidden = true
         chatButtonOutLet.isHidden = true
        
        //   var viewKarmaBool:Bool? = false
        
        
        /** Note: With the exception of contentMode, all of these
         properties can be set directly in Interface builder **/
        
        // Required float rating view params
        self.floatRatingView.emptyImage = UIImage(named: "StarEmpty")
        self.floatRatingView.fullImage = UIImage(named: "StarFull")
        // Optional params
        self.floatRatingView.delegate       = self
        self.floatRatingView.contentMode    = UIViewContentMode.scaleAspectFit
        self.floatRatingView.maxRating      = 5
        self.floatRatingView.minRating      = 0
        self.floatRatingView.rating         = 0
        self.floatRatingView.editable       = false
        self.floatRatingView.halfRatings    = true
        self.floatRatingView.floatRatings   = false
       // starpageSendButton.isHidden = true
        giveKarmaButtonOut.isHidden = true
        
        DispatchQueue.main.async
        {
                //user public post karma data fetch
                self.observeMessage()
        }
        
       
        
        if isShown == true
        {
            checkLogOut.isHidden = true
            
            
            
            chatButtonOutLet.isHidden = false
            starpageSendButton.isHidden = false
            giveKarmaButtonOut.isHidden = false
            
            //self.floatRatingView.rating = 3.5
            chatActionImage.image = UIImage(named: "speech-bubble-with-text-lines(1).png")
            
            let testUIBarButtonItemL = UIBarButtonItem(image: UIImage(named: "left-arrow.png"), style: .plain, target: self, action: #selector(FacebookViewController.clickButtonL))
            self.navigationItem.leftBarButtonItem  = testUIBarButtonItemL
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.picTo      = appDelegate.picToSend
            self.nameTo     = appDelegate.nameToSend
            self.lastNameTo = appDelegate.lastNameToSend
            timeLineGetMUid = appDelegate.MUid
            
        }
        else
        {
            Auth.auth().addStateDidChangeListener()
        { auth, user in
             if user != nil
             {
            }
            }
            
           if  let FromuserID = Auth.auth().currentUser?.uid
           {
              self.timeLineGetMUid = FromuserID
            
            }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.picTo      = appDelegate.picForProfile
            self.nameTo     = appDelegate.nameForProfile
            self.lastNameTo = appDelegate.LastnameForProfile
           
            
            
        
          
        }
        
        
        
        
        if let url = URL(string: picTo)
        {
            imageProfileView.layer.cornerRadius = 70
            imageProfileView.layer.masksToBounds = true
            imageProfileView.sd_setImage(with: url , placeholderImage: UIImage(named: "placeholder.png"))
            
            // MARK: - face width to set
            nameLabel.numberOfLines = 1;
            nameLabel.minimumScaleFactor = 8.0
            nameLabel.adjustsFontSizeToFitWidth = true
            nameLabel.sizeToFit()
            nameLabel.text = nameTo
            if lastNameTo.isEmpty == false {
                nameLabel.text = nameTo + " " + lastNameTo
            }
        }
    }

    
    // delete duplicate value
    
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
    
    
    

    
    // Mark: user public post karma data fetch
    func observeMessage()
    {
        
        self.view.addSubview(self.container)
        self.actInd.startAnimating()
        arrayMessageFinal.removeAll()
        
        let ref = Database.database().reference().child("publicPostKarma")
        
        ref.observe(.childAdded, with: { firDataSnapshot in
            
            print(firDataSnapshot)
            if let firebaseDic = firDataSnapshot.value as? [String: AnyObject]
            {
                
                let userObj = PostStringHold()
                userObj.setValuesForKeys(firebaseDic)
                self.arrayMessageFinal.append(userObj)
                if self.isShown == true
                {
                    if let postStar = firebaseDic["postStar"] as? String
                    {
                        
                    }
                    
                    
                    DispatchQueue.main.async
                    {
                            self.observLoadStar()
                        self.starAvrg = self.starAvrg/self.avrgCounter
                        
                        self.ratingAvrgLabel.text =  self.ampmAppend(str: String(self.starAvrg))
                        self.floatRatingView.rating  = Float(self.starAvrg)
                            
                    }
                }
                else
                {
                     self.observLoadStarSelfUser()
                    
                    self.starAvrg = self.starAvrg/self.avrgCounter
                    
                    self.ratingAvrgLabel.text =  self.ampmAppend(str: String(self.starAvrg))
                    self.floatRatingView.rating  = Float(self.starAvrg)

                    
                    self.container.removeFromSuperview()
                    self.actInd.stopAnimating()
                }
               
                
            }
            else
            {
                self.container.removeFromSuperview()
                self.actInd.stopAnimating()
            }
            
        }, withCancel: nil )
    }
    
    
    /// This mathod give star to list user
    func observLoadStar()
    {
        arrayMessageFinal = uniq(source: arrayMessageFinal)
        var intCount = 0
        starAvrg = 0.0
        avrgCounter = 0.0
        
        for item in self.arrayMessageFinal
        {
            let FromuserID = Auth.auth().currentUser?.uid
            
            if self.arrayMessageFinal.count > intCount
            {
                
                let postShow   = self.arrayMessageFinal[intCount];
                //  print("Item \(intCount): \(messageShow.MUid)\(messageShow.FromuserID)\(MUid)")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if postShow.publicPostToID == appDelegate.MUid && postShow.PublicpostFromID == FromuserID
                {
                    
                    let nsstring  = NSString(string: postShow.postStar!)
                    starAvrg = starAvrg + Double(nsstring.floatValue)
                    avrgCounter = avrgCounter + 1.0
                    
                    
                }
                else
                {
                    
                }
                intCount = intCount + 1
                if self.arrayMessageFinal.count == intCount
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
            if self.arrayMessageFinal.count == intCount
            {
                self.container.removeFromSuperview()
                self.actInd.stopAnimating()
                
            }
        }
    }
    
    // This mathod give star to self own user
    
    func observLoadStarSelfUser()
    {
        
        arrayMessageFinal = uniq(source: arrayMessageFinal)
        
        var intCount = 0
        starAvrg = 0.0
        avrgCounter = 0.0
        
        
        for item in self.arrayMessageFinal
        {
            let FromuserID = Auth.auth().currentUser?.uid
            
            if self.arrayMessageFinal.count > intCount
            {
                
                let postShow   = self.arrayMessageFinal[intCount];
                //  print("Item \(intCount): \(messageShow.MUid)\(messageShow.FromuserID)\(MUid)")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if postShow.publicPostToID == FromuserID
                {
                   
                   
                    let nsstring  = NSString(string: postShow.postStar!)
                    starAvrg = starAvrg + Double(nsstring.floatValue)
                    
                    avrgCounter = avrgCounter + 1.0
                    
                   
                    
                }
                else
                {
                }
                intCount = intCount + 1
                if self.arrayMessageFinal.count == intCount
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
            if self.arrayMessageFinal.count == intCount
            {
                self.container.removeFromSuperview()
                self.actInd.stopAnimating()
                
            }
        }
      
        
        
    }
    //split star
    
        func ampmAppend(str:String) -> String
        {
    
    
            var addedStr = ""
            var mutableStr = ""
            var countCoor = 2
            
            if str == "nan"
            {
            }
            else
            {
            var temp = str
            var strArr = str.characters.split{$0 == "."}.map(String.init)
            
            
            
            var intNumber = Int(strArr[0])!
            let descNumber = strArr[1]
    
            for Character in descNumber.characters {
                if Character == " " {
                    // fullNameArr.append(newElement)
                    // newElement = ""
                } else {
    
                    if countCoor != 0
                    {
                        mutableStr += "\(Character)"
                        countCoor -= 1
                    }
                    // newElement += "\(Character)"
                }
            }
    
            addedStr = "\(intNumber)" + "." + mutableStr
             return addedStr
            }
             return addedStr
            
        }
    
    
   
    
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
       // self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
      //  self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
    @IBAction func starShowTimeLineAction(_ sender: UIButton)
    {
        let distination : ShowTimeLinePageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowTimeLinePageViewController") as! ShowTimeLinePageViewController
        distination.timeLineGetMUid = timeLineGetMUid
        self.navigationController?.pushViewController(distination, animated: true)
    }
    
    @IBAction func giveKarmaButtonAction(_ sender: UIButton)
    {
      
        
        let distination : PostKarmaViewController = self.storyboard?.instantiateViewController(withIdentifier: "PostKarmaViewController") as! PostKarmaViewController
        distination.arrayMessageFinal = arrayMessageFinal
        self.navigationController?.pushViewController(distination, animated: true)
        if karmaView.isHidden == false
        {
            //karmaView.isHidden = true

        }
        else
        {
            //karmaView.isHidden = false
        }
    }
    @IBAction func checkLogOutAction(_ sender: UIButton)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.tabCheckbool = false
                //logout facebook
                if let loggedInUsingFBTokenCheck = FBSDKAccessToken.current(){
        
                    FBSDKAccessToken.current()
        
                    let loginManager = FBSDKLoginManager()
                    loginManager.logOut()
                }
        //Logout firebase 
        
         try! Auth.auth().signOut()
        
        let defaults = UserDefaults.standard
        defaults.set("false", forKey: "userLoginKey")
        
        let distination : HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        transition.subtype = kCATransitionFromBottom
        navigationController?.view.layer.add(transition, forKey:kCATransition)
        //let _ = navigationController?.popViewController(animated: false)
        
        self.navigationController?.pushViewController(distination, animated: true)
        
        
       // self.present(distination, animated: true, completion: nil)
        
        
    }
    
    @IBAction func moreCherechetorAction(_ sender: UIButton)
    {
        
        let distination : CherechterPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "CherechterPageViewController") as! CherechterPageViewController
        self.navigationController?.pushViewController(distination, animated: true)
    }
    // MARK: Send to chat view
    @IBAction func chatAction(_ sender: UIButton)
    {
        let distination : ChatLogViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatLogViewController") as! ChatLogViewController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                self.nameTo =  appDelegate.nameToSend
        self.lastNameTo = appDelegate.lastNameToSend
        distination.picTo   =  appDelegate.picToSend
        distination.nameTo  =  appDelegate.nameToSend
        distination.lastNameTo = appDelegate.lastNameToSend
        distination.MUid    =  appDelegate.MUid
        
        let transition = CATransition()
        transition.duration = 0.0
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.navigationController?.view.layer.add(transition, forKey:kCATransitionFromRight)
        self.navigationController?.pushViewController(distination, animated: true)

    }
    
    func clickButton(){
        print("button click")
    }
    
    func clickButtonL(){
        
        _ = self.navigationController?.popViewController(animated: false)
        print("button click")
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
        
        navigationController?.navigationBar.tintColor = .white
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        self.navigationItem.title = "KarmaPro"
        
        let testUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu(1).png"), style: .plain, target: self, action: #selector(FacebookViewController.clickButton))
        //self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
        
        loyaltyLabel.layer.cornerRadius = 7
        loyaltyLabel.layer.masksToBounds = true
        
        honestyLabel.layer.cornerRadius = 7
        honestyLabel.layer.masksToBounds = true
        
        caringLabel.layer.cornerRadius = 7
        caringLabel.layer.masksToBounds = true
        
    }
    
//    func fetchUser() {
//        Database.database().reference().child("Users").observeSingleEvent(of: .childAdded, with: { (snapshot) in
//            
//            print(snapshot)
//            
//            
//            
//            
//            if let firebaseDic = snapshot.value as? [String: AnyObject]
//            {
//                
//            }
//            
//        })
//       
//    }
    
    


  

}
