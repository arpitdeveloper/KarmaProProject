//
//  ChatLogViewController.swift
//  KarmaPro
//
//  Created by Macbook Pro on 01/09/17.
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


class ChatLogViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UITextFieldDelegate , UIAlertViewDelegate{

    var  arrayMessageAll    = [MessageStringhold]()
    var  arrayMessageFinal  = [MessageStringhold]()
    
    var  picTo = String()
    var  nameTo = String()
    var  lastNameTo = String()
    var MUid = String()
    
    // check first time send or not
    var sndFirstTimebool : Bool = false
    
    // Reloade text message in table first time when load
    var boolBottom = Bool()
    
    @IBOutlet weak var enterTextF: UITextField!
    
    
    @IBOutlet weak var SendButtonOutLet: UIButton!
    @IBOutlet weak var mytableView: UITableView!
    
   
    
    var activeTextField: UITextField!
    var viewWasMoved: Bool = false
    
  
    //var filtered:[String] = ["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin","Seattle"]
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        mytableView.layer.backgroundColor = UIColor.white.cgColor
//        mytableView.layer.borderColor = UIColor.white.cgColor
        
        enterTextF.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        let testUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "left-arrow.png"), style: .plain, target: self, action: #selector(ChatLogViewController.clickButton))
        self.navigationItem.leftBarButtonItem  = testUIBarButtonItem
        
       // navigationController?.navigationBar.barTintColor = .purple
        navigationController?.navigationBar.tintColor = .white
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatLogViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatLogViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)

        
        boolBottom = false

         navigationItem.title = nameTo
        mytableView.register(UINib(nibName: "MytableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        mytableView.delegate = self
        mytableView.dataSource = self
        enterTextF.delegate = self
        
        mytableView.reloadData()
        self.automaticallyAdjustsScrollViewInsets  =  false;
        mytableView.showsVerticalScrollIndicator = false
        
     //  self.observeMessage()
        
        
        
        
        
    }
    
//    func alertMathod()
//    {
//        
//        if sndFirstTimebool == false
//        {
//        
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            var moreAlert=UIAlertView(title: "You have not connected to \(appDelegate.nameToSend) ", message: "whould you like to send message anonymous or onymous", delegate: self, cancelButtonTitle:"anonymous", otherButtonTitles: "onymous" )
//            
//            moreAlert.tag=111;
//            moreAlert.show()
//           sndFirstTimebool = true
//        }
//        
//       
//    }
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
                print("anonymous")
                
            }
            else if buttonIndex==2
            {
                print("onymous")
                
            }
        }
    }
    
    
//    func CheckFirstTimeMessage()
//    {
//        
//        self.alertMathod()
//        let FromuserID = Auth.auth().currentUser?.uid
//        
//        var intCount = 0
//        for item in arrayMessageAll
//        {
//            
//            if arrayMessageAll.count > intCount
//            {
//               
//                
//                let messageShow   =  arrayMessageAll[intCount];
//                
//                
//                
//                print("Item \(intCount): \(messageShow.MUid)\(messageShow.FromuserID)\(MUid)")
//                if messageShow.MUid == MUid && FromuserID == messageShow.FromuserID || messageShow.MUid == FromuserID && MUid == messageShow.FromuserID
//                {
//                    
//                    sndFirstTimebool = true
//                    
//                    
//                    self.arrayMessageFinal.append(messageShow)
//                    
//                }
//                else
//                {
//                    
//                    arrayMessageAll.remove(at: intCount)
//                }
//                intCount = intCount + 1
//            }
//        }
//    }
    //viewDidAppear(_ animated: Bool) {
    override func viewDidAppear(_ animated: Bool)
    {
         mytableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
           super.viewWillAppear(animated) // No need for semicolon
        
        self.observeMessage()
        //self.arrayMessageFinal.removeAll()
        //arrayMessageAll.removeAll()
        mytableView.reloadData()
        
    }
    
    func clickButton(){
        
        _ = self.navigationController?.popViewController(animated: false)
        print("button click")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated) // No need for semicolon
        //self.arrayMessageFinal.removeAll()
          mytableView.reloadData()
        
    }
    
    
    
    // MARK: Opening Keyborad to send message
    
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

    
    // MARK: Featching message from firebase
    func observeMessage()
    {
        
        arrayMessageAll.removeAll()
        let ref = Database.database().reference().child("Message")
        
        ref.observe(.childAdded, with: { firDataSnapshot in
            
            print(firDataSnapshot)
            if let firebaseDic = firDataSnapshot.value as? [String: AnyObject]
            {
                
                let userObj = MessageStringhold()
                userObj.setValuesForKeys(firebaseDic)
                self.arrayMessageAll.append(userObj)
                
                 //self.CheckFirstTimeMessage()
                
                DispatchQueue.main.async
                    {
                    //self.arrayMessageFinal.removeAll()
                       
                    self.mytableView.reloadData()
                        self.boolBottom = false
                       
                    }
                
            }
            
        }, withCancel: nil )
    }
    
    
    // MARK: Send Saving message to firebase
    @IBAction func sendButtonAction(_ sender: UIButton)
    {
        
        if enterTextF.text != ""
        {
        print(enterTextF.text as Any)
        
            let ref = Database.database().reference().child("Message")
            let FromuserID = Auth.auth().currentUser?.uid
        //let ch2  = ref.child(userID!)
        
            let childRef = ref.childByAutoId()
            let StrChildRef = "\(childRef)"
           let StrChildRefFinal =  self.splitStringDate(str: StrChildRef)
            let timeSnap = Int(NSDate().timeIntervalSince1970)
            let myStringTime = "\(timeSnap)"
            let values = [ "messageText" : enterTextF.text! , "MUid" : MUid , "FromuserID" : FromuserID! , "dateStr" : myStringTime , "checkOrNotMSG" : "false" , "strKeyMSG" : StrChildRefFinal  ] as [String : Any]
            childRef.updateChildValues(values , withCompletionBlock: {(error , ref )in
                if error != nil
                {
                    print(error! )
                   
                    return
                }else
                {
                    
                  //  print("Saved sucess fully")
                    //self.arrayMessageFinal.removeAll()
                    //self.arrayMessageAll.removeAll()
                    self.mytableView.reloadData()
                    
                    
                }
            })
            
        enterTextF.text = ""
        enterTextF.placeholder = "Enter message..."
        //Enter message
    }
    }
    
    func splitStringDate(str:String) -> String
    {
        let fullNameArr = str.components(separatedBy: "Message/")
       // var intNumber = Int(fullNameArr[0])!
        let descNumber = "\(fullNameArr[1])"
        return descNumber
    }
//    func ampmAppend(str:String) -> String
//    {
//        
//        
//        var mutableStr = ""
//        var countCoor = 3
//        var temp = str
//        var strArr = str.characters.split{$0 == "-"}.map(String.init)
//        var intNumber = Int(strArr[0])!
//        let descNumber = strArr[1]
//        
////        for Character in descNumber.characters {
////            if Character == " " {
////                // fullNameArr.append(newElement)
////                // newElement = ""
////            } else {
////                
////                if countCoor != 0
////                {
////                    mutableStr += "\(Character)"
////                    countCoor -= 1
////                }
////                // newElement += "\(Character)"
////            }
////        }
//        
//        let addedStr = "\(intNumber)" + "." + mutableStr
//        
//        return addedStr
//        
//    }
    
    // MARK: Table View message from firebase
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        arrayMessageFinal.removeAll()
        let FromuserID = Auth.auth().currentUser?.uid
        
        var intCount = 0
        for item in arrayMessageAll
        {
         
        if arrayMessageAll.count > intCount
        {
           
            
            let messageShow   = arrayMessageAll[intCount];
            
           
            
            print("Item \(intCount): \(messageShow.MUid)\(messageShow.FromuserID)\(MUid)")
            if messageShow.MUid == MUid && FromuserID == messageShow.FromuserID || messageShow.MUid == FromuserID && MUid == messageShow.FromuserID
            {
             
                self.arrayMessageFinal.append(messageShow)

            }
            else
            {
               
                arrayMessageAll.remove(at: intCount)
            }
        intCount = intCount + 1
        }
        }
  
        
        return arrayMessageFinal.count;
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as! MytableViewCell;
        let messageShow   = arrayMessageFinal[indexPath.row];
        
//        cell.contentView.backgroundColor = UIColor.white
//        cell.backgroundColor = UIColor.white
        
        let FromuserID = Auth.auth().currentUser?.uid
        
        if boolBottom == false
        {
            // First figure out how many sections there are
            let lastSectionIndex = self.mytableView!.numberOfSections - 1
            
            // Then grab the number of rows in the last section
            let lastRowIndex = self.mytableView!.numberOfRows(inSection: lastSectionIndex) - 1
            
            // Now just construct the index path
            //let pathToLastRow = //ind(forRow: lastRowIndex, inSection: lastSectionIndex)
            let pathToLastRow = IndexPath(row: lastRowIndex , section: lastSectionIndex )
            //tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            // Make the last row visible
            self.mytableView?.scrollToRow(at: pathToLastRow, at: UITableViewScrollPosition.bottom, animated: true)
            boolBottom = true
        }
        
        
        
        
        print(messageShow.MUid as Any)
        if messageShow.MUid == MUid && FromuserID == messageShow.FromuserID || messageShow.MUid == FromuserID && MUid == messageShow.FromuserID
        {
             cell.nameLabel?.text = messageShow.messageText
        
        
            let messageShow   = arrayMessageFinal[indexPath.row];
            let textViewSige =  messageShow.messageText
            let font = UIFont(name: "Helvetica" , size: 15.0)
            
            
            
            let widthSize = widthForView(text: textViewSige! , font: font!, width: self.view.frame.width)
            let height = heightForView(text: textViewSige! , font: font!, width: self.view.frame.width)
        
           // cell.contentView.frame = CGRect(x: 0, y: 0, width: 250, height: height + 10)
          // mytableView.addSubview(cell.contentView)
           
            if messageShow.MUid == FromuserID && MUid == messageShow.FromuserID
            {
                
                cell.nameLabel.numberOfLines = 0
                cell.nameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                
            cell.nameLabel.frame = CGRect(x: 10, y: 3, width: widthSize + 5 , height: height + 10)
            cell.myBobleView.frame =  CGRect(x: 10, y: 3, width: widthSize + 20, height: height + 20)
                cell.nameLabel.layer.cornerRadius = 14
                cell.nameLabel.layer.masksToBounds = true
                cell.myContentView.layer.cornerRadius = 14
                cell.myContentView.layer.masksToBounds = true
                cell.myBobleView.backgroundColor = UIColor(red: 70/255, green: 148/255, blue: 235/255, alpha: 1.0)
                cell.myContentView.addSubview(cell.myBobleView)
                cell.myBobleView.addSubview(cell.nameLabel)
                return cell;

            }
            
            if messageShow.MUid == MUid && FromuserID == messageShow.FromuserID
            {
                cell.nameLabel.numberOfLines = 0
                cell.nameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                
                cell.nameLabel.frame = CGRect(x: 10 , y: 3, width: widthSize + 5 , height: height + 10 )
                cell.myBobleView.frame =  CGRect(x: cell.frame.width - ( widthSize + 40 )  , y: 3, width: widthSize + 20 , height: height + 20)
                cell.nameLabel.layer.cornerRadius = 14
                cell.nameLabel.layer.masksToBounds = true
                cell.myContentView.layer.cornerRadius = 14
                cell.myContentView.layer.masksToBounds = true
                cell.myBobleView.backgroundColor = UIColor.lightGray
                cell.myContentView.addSubview(cell.myBobleView)
                cell.myBobleView.addSubview(cell.nameLabel)
                return cell;
                

            }
            
            
          return cell;
            
        }
       
      
        
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let messageShow   = arrayMessageFinal[indexPath.row];
        let textViewSige =  messageShow.messageText
        let font = UIFont(name: "Helvetica" , size: 15.0)
        
        var height = heightForView(text: textViewSige! , font: font!, width: self.view.frame.width)
        
        
        
        if height < 30 {
            
            return 50
        }
        
        
        
        
        height = height + 40
        return height ;
        
    }
    
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    func widthForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude , height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        var widthMax = label.frame.width
        if widthMax > 200
        {
          widthMax = 210
            return widthMax
        }
        
        return label.frame.width
    }


}
