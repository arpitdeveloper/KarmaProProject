//
//  DescribeGiveKarmaViewController.swift
//  KarmaPro
//
//  Created by Macbook Pro on 11/09/17.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

import UIKit


import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseAnalytics
import FirebaseMessaging
import FirebaseDatabase
import FirebaseInstanceID


class PostKarmaViewController: UIViewController , FloatRatingViewDelegate, UIAlertViewDelegate {

    var postWithUserIdName = String()
    var arrayMessageFinal = [PostStringHold]()
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var starToPostStr = String()
    var categorySwitchIsOn:Bool =  false
    var karmaIsPost:Bool =  false
    @IBOutlet weak var moreinfoTF: SJTextField!
    @IBOutlet var floatRatingView: FloatRatingView!
    
    @IBOutlet weak var switchTabOut: UISwitch!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.mathodDesigne()
        
        karmaIsPost = true
        
        
        // Required float rating view params
        self.floatRatingView.emptyImage = UIImage(named: "StarEmpty")
        self.floatRatingView.fullImage = UIImage(named: "StarFull")
        // Optional params
        self.floatRatingView.delegate       = self
        self.floatRatingView.contentMode    = UIViewContentMode.scaleAspectFit
        self.floatRatingView.maxRating      = 5
        self.floatRatingView.minRating      = 0
        self.floatRatingView.rating         = 0
        self.floatRatingView.editable       = true
        self.floatRatingView.halfRatings    = true
        self.floatRatingView.floatRatings   = false

        
        switchTabOut.addTarget(self, action:#selector(PostKarmaViewController.switchTabAction(_:)), for: .valueChanged)
        
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        self.navigationItem.title = "KarmaPro"
        
        let testUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu(1).png"), style: .plain, target: self, action: #selector(PostKarmaViewController.clickButton))
        //self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
        
        
        let testUIBarButtonItemL = UIBarButtonItem(image: UIImage(named: "left-arrow.png"), style: .plain, target: self, action: #selector(PostKarmaViewController.clickButtonL))
        self.navigationItem.leftBarButtonItem  = testUIBarButtonItemL


        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    func clickButton()
    {
        print("button click")
    }
    
    func clickButtonL()
    {
        
        _ = self.navigationController?.popViewController(animated: false)
        print("button click")
    }
    
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        starToPostStr = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        starToPostStr = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }

    @IBAction func postDescribeAction(_ sender: UIButton)
    {
       let chekbool =  self.observLoadStar()
       
        
    }
    func observLoadStar( )-> Bool
    {
        
        var intCount = 0
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
                    
                   karmaIsPost = false
                    let moreAlert = UIAlertView(title: "Oops!", message: "It looks like you have already gave this user their Karma.", delegate: self, cancelButtonTitle: "Ok")
                    moreAlert.tag=111;
                    moreAlert.show()
                    
                }
                else
                {
                    if karmaIsPost == false
                    {
                    karmaIsPost = false
                    }
                    else
                    {
                        karmaIsPost = true
                    }
                    

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
            if self.arrayMessageFinal.count <= intCount
            {
                if karmaIsPost == true
                {
                    if moreinfoTF.text != ""
                    {
                        self.view.addSubview(self.container)
                        self.actInd.startAnimating()
                        var confirmAlert = UIAlertView(title: "You can only leave Karma once!", message: "Please make sure you have given this person exactly what they deserve.", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Post Karma" )
                        
                        confirmAlert.tag = 110;
                        confirmAlert.show()
                        
                    }
                    else
                    {
                        let moreAlert=UIAlertView(title: "Oops!", message: "It looks like you haven’t left any Karma.", delegate: self, cancelButtonTitle: "Ok")
                        //  var moreAlert=UIAlertView(title: "Photo", message: "", delegate: self, cancelButtonTitle: "No Thanks!", otherButtonTitles: "Save Image", "Email", "Facebook", "Whatsapp" )
                        
                        moreAlert.tag=111;
                        moreAlert.show()
                        
                    }
                }
                self.container.removeFromSuperview()
                self.actInd.stopAnimating()
                
            }
            
        }
        return karmaIsPost
    }

    
    //MARK: alertHendle Mathod 
    func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int)
    {
        if alertView.tag==110
        {
            if buttonIndex==0
            {
                print("Cancel!")
                
            }
            else if buttonIndex==1
            {
                print("Post Karma")
                
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    
                    let ref = Database.database().reference().child("publicPostKarma")
                    let FromuserID = Auth.auth().currentUser?.uid
                    //let ch2  = ref.child(userID!)
                    let timeSnap = Int(NSDate().timeIntervalSince1970)
                    var myStringTime = String(timeSnap)
                    let childRef = ref.childByAutoId()
                    let values = [ "publicPostStr" : moreinfoTF.text! , "publicPostToID" : appDelegate.MUid , "PublicpostFromID" : FromuserID! , "FromAnonymousOrName" : postWithUserIdName , "postDateStr" : myStringTime  , "postStar" :  starToPostStr   ] as [String : Any]
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
                            let moreAlert=UIAlertView(title: "Your Karma has been published.", message: "", delegate: self, cancelButtonTitle: "Ok")
                            
                            moreAlert.tag=111;
                            moreAlert.show()
                            
                        }
                    })
                    
                    
                    
                    // enterTextF.text = ""
                    
                    //  enterTextF.placeholder = "Enter message..."
                    //Enter message
                
                
            }
        }
    }
    
    
    
    @IBAction func switchTabAction(_ sender: UISwitch)
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        
        if sender.isOn {
            
            let moreAlert=UIAlertView(title: "Your Karma will be publish with Name.", message: "", delegate: self, cancelButtonTitle: "Ok")
            
            moreAlert.tag=111;
            moreAlert.show()
            postWithUserIdName = appDelegate.nameForProfile
            categorySwitchIsOn =  true
            
        } else {
            
            let moreAlert=UIAlertView(title: "Your Karma will be publish Anonymous.", message: "", delegate: self, cancelButtonTitle: "Ok")
            
            moreAlert.tag=111;
            moreAlert.show()
            postWithUserIdName = ""
            categorySwitchIsOn =  false
        }
    }
    
    
    func mathodDesigne()
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
        
        let border = CALayer()
        let width = CGFloat(0.4)
        border.borderColor = UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 0.6).cgColor
        border.frame = CGRect(x: 0, y: moreinfoTF.frame.size.height - width, width:  moreinfoTF.frame.size.width, height: moreinfoTF.frame.size.height)
        
        border.borderWidth = width
        moreinfoTF.layer.addSublayer(border)
        moreinfoTF.layer.masksToBounds = true
    }
}
