//
//  LoginViewController.swift
//  KarmaPro
//
//  Created by Macbook Pro on 28/08/17.
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

import CoreLocation
import SDWebImage

class SearchViewController: UIViewController , UITabBarControllerDelegate , UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout   , CLLocationManagerDelegate , UITextFieldDelegate , UIAlertViewDelegate{
    
    var activeTextField: UITextField!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var distanceVar : Double?  = 0.0
    var distanceVarNear : Double?  = 0.0
    let reuseIdentifier = "Cell"
    var ArrayAll = [UserStringHold]()
    var ArrayAllfinal = [UserStringHold]()
    @IBOutlet weak var dynamicTxtField: UITextField!
    var searchActive : Bool = false
    var ss = NSString()
    var fileterArray  = [UserStringHold]()
    var userResultData2    = NSArray()
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var leftRight : CGFloat!
    var cellHW : CGFloat!
    var cellHWDec : CGFloat!
    var screenHeight: CGFloat!
    
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var mySearchCollView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dynamicTxtField.delegate = self
        
        //register cell
        let nib = UINib(nibName: "MyCollectionViewCell", bundle: nil)
        mySearchCollView?.register(nib, forCellWithReuseIdentifier: "Cell")
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        dynamicTxtField.delegate = self
        
        
        if screenWidth < 325
        {
            
            leftRight = screenWidth - 280
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
        mySearchCollView!.collectionViewLayout = layout
        self.view.addSubview(mySearchCollView!)
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
                // 3
                self.fetchUser()
                //self.fetchUserAccordingToLocation()
            }
        }
        
        mySearchCollView.delegate = self
        mySearchCollView.dataSource = self
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        self.navigationItem.title = "KarmaPro"
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//        
//        view.addGestureRecognizer(tap)
        
        //ArrayAll.removeAll()
        //ArrayAllfinal.removeAll()
        ArrayAllfinal = uniq(source: ArrayAllfinal)

        mySearchCollView.reloadData()
        
    }
    // MARK: keyBoard delegate
    
    
    
    
   
    
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
              
                self.view.frame.origin.y = 0
                self.view.frame.origin.y -= keyboardSize!.height
            } else {
                
            }
        }
    }
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
//    func dismissKeyboard()
//    {
//        //Causes the view (or one of its embedded text fields) to resign the first responder status.
//        view.endEditing(true)
//    }
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        // self.fetchUser()
        // ArrayAll.removeAll()
        // ArrayAllfinal.removeAll()
        ArrayAllfinal = uniq(source: ArrayAllfinal)

        mySearchCollView.reloadData()
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        // self.fetchUser()
        // ArrayAll.removeAll()
        //ArrayAllfinal.removeAll()
        mySearchCollView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backAction(_ sender: UIButton)
    {
        
        // _ = navigationController?.popViewController(animated: true)
        //        let distination : testViewController = self.storyboard?.instantiateViewController(withIdentifier: "testViewController") as! testViewController
        //       // distination.picTo = self.picTo
        //       // distination.nameTo = self.nameTo
        //
        //          self.navigationController?.pushViewController(distination, animated: true)
        // let vc : testViewController = self.storyboard?.instantiateViewController(withIdentifier: "testViewController") as! testViewController
        
        let distination : testViewController = self.storyboard?.instantiateViewController(withIdentifier: "testViewController") as! testViewController
        self.navigationController?.pushViewController(distination, animated: true)
    }
    func fetchUser()
    {
        
        self.ArrayAll.removeAll()
        //self.ArrayAllfinal.removeAll()
        
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
                        //self.ArrayAllfinal.removeAll()
                        self.mySearchCollView.reloadData()
                }
                
                
            }
            
        })
        
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        let FromuserID = Auth.auth().currentUser?.uid
        
        if(searchActive)
        {
            return fileterArray.count
        }
        else
        {
            
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
    }
    
    
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)as! MyCollectionViewCell
        
        let FromuserID = Auth.auth().currentUser?.uid
        
        if(searchActive)
        {
            
            
            let printVal = self.fileterArray[indexPath.row]
            
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
                        
                    }
                }
            }
            
            
            return cell
        }
        else
        {
            
            
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
                            
                        }
                    }
                }
            }
            return cell
        }
        
        
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        if  appDelegate.paidkarmBool == true
//        {
        
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
                    distination.lastNameTo  = printVal.lastName!
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
            
            
            
            
        //}
        //else
//        {
//            
//            var moreAlert = UIAlertView(title: "Paid process Testing", message: "", delegate: self, cancelButtonTitle: "No Thanks!", otherButtonTitles: "Pay Here" )
//            
//            moreAlert.tag=111;
//            moreAlert.show()
//        }
    }
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
                print("Pay Here")
                let distination : PaidKarmaProViewController = self.storyboard?.instantiateViewController(withIdentifier: "PaidKarmaProViewController") as! PaidKarmaProViewController
                let transition = CATransition()
                transition.duration = 0.5
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
                transition.type = kCATransitionFade
                transition.subtype = kCATransitionFromRight
                navigationController?.view.layer.add(transition, forKey:kCATransitionFromRight)
                self.navigationController?.pushViewController(distination, animated: true)
            }
        }
    }
    
    
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
    func fetchUserAccordingToLocation()
    {}
    //MARK: TextField Delegate
    
    
    @IBAction func dynamicTextAction(_ sender: UITextField)
    {
        //   dynamicTxtField.text = ""
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.activeTextField = textField
        print("TextField did begin editing method called")
        
        //searchActive = false;
        
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
        
        print("TextField did end editing method called")
        searchActive = false;
        self.fetchUser()
        self.fileterArray.removeAll()
        self.mySearchCollView.reloadData()
        //self.tableView.reloadData()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("TextField should clear method called")
        searchActive = false
        self.fetchUser()
        //tableView.isHidden = false;
        ss = ""
        self.fileterArray.removeAll()
        self.mySearchCollView.reloadData()
        
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        dynamicTxtField.text = ss as String
        if ss == ""
        {
            searchActive = false
           // self.fetchUser()
        }
        
         ArrayAllfinal = uniq(source: ArrayAllfinal)
        
        
        DispatchQueue.main.async
            {
                
        }
        
        
        DispatchQueue.main.async
            {
                //self.tableView.isHidden = false;
                //self.tableView.reloadData()
        }
        self.view.endEditing(true)
        // blurEffectView.removeFromSuperview()
        dynamicTxtField.text = ss as String
        return true
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
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        print("TextField should snd editing method called")
        dynamicTxtField.text = ss as String
        // blurEffectView.removeFromSuperview()
        if ss == ""
        {
            
        }
        return true;
    }
    
    private func textView(textField: UITextView, shouldChangeCharactersInRange range: NSRange, replacementText string: String) -> Bool
    {
        if string  ==  "\n" {
            return false;
        }
        return true;
    }
    
    func textField(_ textField1: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        
        searchActive = true;
        
        
        ss = textField1.text!  as String as NSString
        ss = (ss as String) + string as NSString
        
        
        self.fileterArray.removeAll()
        let searchPredicate = NSPredicate(format: "firstName CONTAINS[C] %@", ss)
        self.fileterArray = (ArrayAllfinal.filter { searchPredicate.evaluate(with: $0) } as NSArray) as! [UserStringHold];
        DispatchQueue.main.async
            {
                
                self.mySearchCollView.reloadData()
        }
        //        if range.length == 0 || range.length == 1
        //        {
        //            searchActive = false
        //            self.fetchUser()
        //        }
        
        return true;
    }
    
    
    
    
    
}
