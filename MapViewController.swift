//
//  MapViewController.swift
//  KarmaPro
//
//  Created by Macbook Pro on 30/08/17.
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


class MapViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout , CLLocationManagerDelegate,UIAlertViewDelegate
 {
    
    
   
    let appDelegate    = UIApplication.shared.delegate as! AppDelegate
    var  distanceVar : Double?  = 0.0
    var  distanceVarNear : Double?  = 0.0
  //  var collectionView: UICollectionView?
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var leftRight : CGFloat!
    var cellHW : CGFloat!
    var cellHWDec : CGFloat!
    var screenHeight: CGFloat!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    let reuseIdentifier = "Cell"
    var  ArrayAll = [UserStringHold]()
    var  ArrayAllfinal = [UserStringHold]()
   // var  userNearLocation = [UserLocationNear]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //register cell
        let nib = UINib(nibName: "MyCollectionViewCell", bundle: nil)
        myCollectionView?.register(nib, forCellWithReuseIdentifier: "Cell")
    
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        if screenWidth < 325
        {
         
            leftRight = screenWidth - 280
            //cellHWDec =
            leftRight = leftRight/2
            leftRight = leftRight-10
        }
        else
        {
            leftRight = screenWidth - 290
            leftRight = leftRight/2
            leftRight = leftRight-10
        }
        
        
        // Do any additional setup after loading the view, typically from a nib
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: leftRight, bottom: 20, right:leftRight )
        layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        myCollectionView!.collectionViewLayout = layout
        self.view.addSubview(myCollectionView!)
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
                // 3
                self.fetchUser()
                //self.fetchUserAccordingToLocation()
            }
        }
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        //let nib = UINib(nibName: "MyCollectionViewCell", bundle: nil)
       // myCollectionView?.register(nib, forCellWithReuseIdentifier: "Cell")
       // myCollectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
       

        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        self.navigationItem.title = "KarmaPro"
        
        ArrayAllfinal.removeAll()
        myCollectionView.reloadData()
        

        // Do any additional setup after loading the view.
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
       // self.fetchUser()

        //ArrayAll.removeAll()
        ArrayAllfinal.removeAll()
        myCollectionView.reloadData()
        
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
       // self.fetchUser()
       // ArrayAll.removeAll()
        ArrayAllfinal.removeAll()
        myCollectionView.reloadData()
       
    }
    override func viewDidAppear(_ animated: Bool)
    {
       // self.fetchUser()
       // ArrayAll.removeAll()
        ArrayAllfinal.removeAll()
        myCollectionView.reloadData()
    }
  
    
    // MARK: - UICollectionViewDataSource protocol
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
       
        
        let FromuserID = Auth.auth().currentUser?.uid
        if ArrayAll.count > 0
        {
            self.ArrayAllfinal.removeAll()
            
            
            for var i in (0..<ArrayAll.count)
            {
                if ArrayAll.count > i
                {
                let printVal = ArrayAll[i]
                
                print("Item \(i): \(i)")
                   
                    
                    let latitudeStr  = printVal.latitude
                    let longitudeStr  = printVal.longitude
                    let location = CLLocation(latitude: Double(latitudeStr!)! , longitude: Double(longitudeStr!)! )
                    var distanceInMeters =  appDelegate.appLocationCurrent.distance(from:location ) // result is in meters
                    
                    distanceInMeters = distanceInMeters/1609.344
                    distanceVarNear = 20*1609.344
                    distanceVar = distanceInMeters
                    print( distanceInMeters )
                    
                    if (distanceVar!.isLess(than: distanceVarNear!))
                    {
                        if ArrayAll.count > i
                        {
                            if printVal.fireUserid != FromuserID
                            {
                                if ArrayAll.count > i
                                {
                                    ArrayAllfinal.append(printVal)
                                    for var j in (0..<ArrayAllfinal.count)
                                    {
                                        let printValF = ArrayAllfinal[j]
                                        if ArrayAllfinal.count > j+1
                                        {
                                        let printValF2 = ArrayAllfinal[j+1]
                                        if printValF.fireUserid == printValF2.fireUserid
                                        {
                                            if ArrayAllfinal.count > j
                                            {
                                            ArrayAllfinal.remove(at: j)
                                            }
                                        }
                                        }
                                        
                                    }
                                    
                                }
                            }
                        }
                    }
                    

                    
                
                }
            
            }
            
//            for (index, element) in ArrayAll.enumerated()
//            {
//                
//            }
        }

        
        return ArrayAllfinal.count
    }
    
   
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)as! MyCollectionViewCell
        
         let FromuserID = Auth.auth().currentUser?.uid
        
        if ArrayAllfinal.count > indexPath.row
        {
            
            let printVal = ArrayAllfinal[indexPath.row]
            
            if let picUrl = printVal.picUrl
            {
            if printVal.fireUserid != FromuserID
            {
                print(picUrl)
                if let url = URL(string: picUrl)
                {
                    
                    cell.myImageVIew.layer.cornerRadius = (cell.myImageVIew.frame.height)/2
                    cell.myImageVIew.layer.masksToBounds = true
                    cell.myImageVIew.sd_setImage(with: url , placeholderImage: UIImage(named: "placeholder.png"))
                    cell.firstNameLabel.text = printVal.firstName//friendPrintArray[indexPath.row]//printVal.friendLocation
                    cell.LastNameLabel.text = printVal.lastName
                    
                 }
            }
            }
         }
       
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        let distination : FacebookViewController = self.storyboard?.instantiateViewController(withIdentifier: "FacebookViewController") as! FacebookViewController
        
        if ArrayAllfinal.count > indexPath.row
        {
            
            let printVal = ArrayAllfinal[indexPath.row]
            
            if let picUrl = printVal.picUrl
            {
                print(picUrl)
                
               
                appDelegate.nameToSend = printVal.firstName!
                appDelegate.lastNameToSend = printVal.lastName!
                appDelegate.picToSend  = picUrl
                appDelegate.MUid   = printVal.fireUserid!

                distination.picTo   = picUrl
                distination.nameTo  = printVal.firstName!
                distination.lastNameTo = printVal.lastName!
                //distination.MUid    = printVal.fireUserid!
                distination.isShown = true
                
            }
            
        }
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.navigationController?.view.layer.add(transition, forKey:kCATransitionFromLeft)
         self.navigationController?.pushViewController(distination, animated: true)
       
    }

    // alertHendle button
//    func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int)
//    {
//        if alertView.tag==111
//        {
//            if buttonIndex==0
//            {
//                print("No Thanks!")
//            }
//            else if buttonIndex==1
//            {
//                print("Pay Here")
//                let distination : PaidKarmaProViewController = self.storyboard?.instantiateViewController(withIdentifier: "PaidKarmaProViewController") as! PaidKarmaProViewController
//                let transition = CATransition()
//                transition.duration = 0.5
//                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
//                transition.type = kCATransitionFade
//                transition.subtype = kCATransitionFromRight
//                navigationController?.view.layer.add(transition, forKey:kCATransitionFromRight)
//                self.navigationController?.pushViewController(distination, animated: true)
//            }
//        }
//    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        if screenWidth < 325
        {
            
           cellHW =  130
            
        }
        else
        {
            cellHW =  330 / 2
            
        }
        if cellHW > 140
        {
            cellHW = 140
        }
        

        
        return CGSize(width: cellHW , height: cellHW)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 50;
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 30;
//    }
    

//    func checkMathodNear()
//    {
//        
//        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//       
//        
////        for var i in (0..<userNearLocation.count)
////        {
////            if userNearLocation.count>i
////            {
////            
////            
////            
////            let printVal = userNearLocation[i]
////            let latitudeStr  = printVal.latitude
////            let longitudeStr  = printVal.longitude
////            let location = CLLocation(latitude: Double(latitudeStr!)! , longitude: Double(longitudeStr!)! )
////            
////            var distanceInMeters =  appDelegate.appLocationCurrent.distance(from:location ) // result is in meters
////            
////            distanceInMeters = distanceInMeters/1609.344
////            distanceVarNear = 20*1609.344
////            
////            distanceVar = distanceInMeters
////            
////            print( distanceInMeters )
////            
////            
////            if (distanceVarNear?.isLess(than: distanceVar!))!
////            {
////                for var j in (0..<ArrayAll.count)
////                {
////                    if ArrayAll.count>i
////                    {
////                    
////                    
////                    let printValAll = ArrayAll[j]
////                   if printValAll.fireUserid == printVal.userFirebaseId
////                    {
////                        ArrayAllfinal.append(printValAll)
////                        
////                            DispatchQueue.main.async
////                            {
////                               
////                                self.myCollectionView.reloadData()
////                            }
////                    }
////                        else
////                        {
////                    
////                        }
////                }
////                }
////            }
////            else
////            {
////                userNearLocation.remove(at: i)
////            }
////        }
////    }
//    
//        
//        
//    }
    func fetchUserAccordingToLocation()
    {}
    
    func fetchUser()
    {
        
       self.ArrayAll.removeAll()
        self.ArrayAllfinal.removeAll()
   
        let ref = Database.database().reference().child("Users")
        
        ref.observe(.childAdded, with: { firDataSnapshot in
            
             print(firDataSnapshot)
            if let firebaseDic = firDataSnapshot.value as? [String: AnyObject]
            {
                
                let userObj = UserStringHold()
                userObj.setValuesForKeys(firebaseDic)
                self.ArrayAll.append(userObj)
                DispatchQueue.main.async
                {
                    self.fetchUserAccordingToLocation()
                    self.ArrayAllfinal.removeAll()
                    self.myCollectionView.reloadData()
                }
                
                
            }
            
        })
        
    }

}
