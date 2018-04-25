//
//  SignUPKarmaViewController.swift
//  KarmaPro
//
//  Created by Macbook Pro on 29/08/17.
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
import FirebaseStorage
import CoreLocation



class SignUPKarmaViewController: UIViewController  , UIActionSheetDelegate , UIAlertViewDelegate , UITextFieldDelegate , CLLocationManagerDelegate {

    
    var urlStr = String()
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var locationCor =  CLLocation()
    

    @IBOutlet weak var returnToLoginButtonOutLet: UIButton!
    @IBOutlet weak var myimageView: UIImageView!
     var imageSave : UIImage? = nil
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var ReEnterPassTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    var activeTextField: UITextField!
    var viewWasMoved: Bool = false
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        emailTF.delegate = self
        ReEnterPassTF.delegate = self
        passwordTF.delegate = self
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignUPKarmaViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUPKarmaViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        self.navigationItem.title = "KarmaPro"
        
        self.Desinge()
        
        
        // loading view
        
        container.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)//self.view.frame
        // CGRect(x: 0, y: 0, width: 400, height: 1000)//self.view.frame
        container.center = self.view.center
        // let color = UIColor(hexString) //( : "ff0000")
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


      }

    // MARK: keyBoard delegate 
    
    
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

       // firstNameTF.setValue(UIColor.init(colorLiteralRed: 80/255, green: 80/255, blue: 80/255, alpha: 0.5), forKeyPath: "_placeholder.textColor")
        
        let color = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        firstNameTF.attributedPlaceholder = NSAttributedString(string:" First Name" , attributes: [NSForegroundColorAttributeName : color])
        

        
        lastNameTF.attributedPlaceholder = NSAttributedString(string:" Last Name" , attributes: [NSForegroundColorAttributeName : color])
        
        
        ReEnterPassTF.attributedPlaceholder = NSAttributedString(string:" Re - enter Password" , attributes: [NSForegroundColorAttributeName : color])
        
        
        emailTF.attributedPlaceholder = NSAttributedString(string:" Email" , attributes: [NSForegroundColorAttributeName : color])
        
        passwordTF.attributedPlaceholder = NSAttributedString(string:" Password" , attributes: [NSForegroundColorAttributeName : color])
        
        
        //firstNameTF. = UIColor.white.withAlphaComponent(0.5)
        // lastNameTF.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        // emailTF.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.view.addSubview(self.container)
        self.actInd.startAnimating()
        
        myimageView.layer.cornerRadius = 70
        myimageView.layer.masksToBounds = true
        // UIColor(red: 0/255, green: 159/255, blue: 184/255, alpha: 1.0).cgColor
        let border = CALayer()
        let width = CGFloat(1.5)
        border.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5).cgColor
        border.frame = CGRect(x: 0, y: firstNameTF.frame.size.height - width, width:  firstNameTF.frame.size.width, height: firstNameTF.frame.size.height)
        
        border.borderWidth = width
        firstNameTF.layer.addSublayer(border)
        firstNameTF.layer.masksToBounds = true
        
        let borderpassTextF = CALayer()
        borderpassTextF.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5).cgColor
        borderpassTextF.frame = CGRect(x: 0, y: lastNameTF.frame.size.height - width, width:  lastNameTF.frame.size.width, height: lastNameTF.frame.size.height)
        
        borderpassTextF.borderWidth = width
        lastNameTF.layer.addSublayer(borderpassTextF)
        lastNameTF.layer.masksToBounds = true
        
        
        let borderpassTextF1 = CALayer()
        borderpassTextF1.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5).cgColor
        borderpassTextF1.frame = CGRect(x: 0, y: emailTF.frame.size.height - width, width:  emailTF.frame.size.width, height: emailTF.frame.size.height)
        
        borderpassTextF1.borderWidth = width
        emailTF.layer.addSublayer(borderpassTextF1)
        emailTF.layer.masksToBounds = true
        
        let borderpassTextF12 = CALayer()
        borderpassTextF12.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5).cgColor
        borderpassTextF12.frame = CGRect(x: 0, y: ReEnterPassTF.frame.size.height - width, width:  ReEnterPassTF.frame.size.width, height: ReEnterPassTF.frame.size.height)
        
        borderpassTextF12.borderWidth = width
        ReEnterPassTF.layer.addSublayer(borderpassTextF12)
        ReEnterPassTF.layer.masksToBounds = true
        
        let borderpassTextF123 = CALayer()
        borderpassTextF123.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5).cgColor
        borderpassTextF123.frame = CGRect(x: 0, y: passwordTF.frame.size.height - width, width:  passwordTF.frame.size.width, height: passwordTF.frame.size.height)
        
        borderpassTextF123.borderWidth = width
        passwordTF.layer.addSublayer(borderpassTextF123)
        passwordTF.layer.masksToBounds = true
       
        self.container.removeFromSuperview()
        self.actInd.stopAnimating()

    }
    
    @IBAction func returnToLoginAction(_ sender: UIButton)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func imageSelectAction(_ sender: UIButton)
    {
        MSActionSheet.instance.showFullActionSheet(on: self){ (image) in
              self.imageSave = image
              self.myimageView.image = image
          

        }
           }
    @IBAction func registerAction(_ sender: UIButton)
    {
        
        if emailTF.text != "" && passwordTF.text != "" && firstNameTF.text != "" && lastNameTF.text != "" && ReEnterPassTF.text != ""
        {
        
        if self.imageSave == nil
        {
            let moreAlert=UIAlertView(title: "Please select Image", message: "", delegate: self, cancelButtonTitle: "Ok")
            moreAlert.show()
        }
        else
        {
            if self.imageSave != nil
            {
            self.imagePickerController2()
            }

        }
        }
        else
        {
            let moreAlert=UIAlertView(title: "Please enter all field detail", message: "", delegate: self, cancelButtonTitle: "Ok")
            //  var moreAlert=UIAlertView(title: "Photo", message: "", delegate: self, cancelButtonTitle: "No Thanks!", otherButtonTitles: "Save Image", "Email", "Facebook", "Whatsapp" )
            
            moreAlert.tag=111;
            moreAlert.show()
        }
      
    }
    
    // MARK: image picker from phone
    func  imagePickerController2() {
        
        
        self.view.addSubview(self.container)
        self.actInd.startAnimating()
        

        
      //  self.actInd.startAnimating()
        
        
        DispatchQueue.main.async {
            
            
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let imageNameUni = NSUUID().uuidString
            let  data = UIImagePNGRepresentation(self.imageSave! )
            let userProfilePic = storageRef.child("\(imageNameUni).png")
            //  let uploadTask = userProfilePic.put(data as Data, metadata: nil) { metadata, error in
            _ = userProfilePic.putData(data! , metadata: nil) { metadata, error in
                if (error != nil) {
                    
                    print(error as Any)
                    self.container.removeFromSuperview()
                    self.actInd.stopAnimating()
                    // Uh-oh, an error occurred!
                } else {
                    if  let downloadURL : String  = metadata!.downloadURL()?.absoluteString
                    {
                        print(downloadURL)
                       self.urlStr  = downloadURL
                        self.SginUpCreateAcc()
                        
                    }
                    
                }
            }
        }
    }
    
    
    // alertHendle button
    func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int)
    {
        if alertView.tag==112
        {
            if buttonIndex==0
            {
                print("No Thanks!")
            }
            else if buttonIndex==1
            {
                print("Save Image")
                _ = navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    // MARK: Firebase create account and saving data
    
    func SginUpCreateAcc()
    {
       
        self.view.addSubview(self.container)
        self.actInd.startAnimating()
        
        // Password()
        // Password_Confimed()
        // let passchectd : Bool =  validate(password: userPassTF.text!)
        print("Email:\( emailTF ) password:\(passwordTF) firstNameToFirebase:\(firstNameTF)")
        
        
        if emailTF.text != "" && passwordTF.text != "" && firstNameTF.text != "" && lastNameTF.text != "" && ReEnterPassTF.text != ""
        {
            //  let error = NSError()
            
            Auth.auth().createUser(withEmail: emailTF.text! , password: passwordTF.text! ) { (user : User?,  error) in
                
                if error == nil
                {
                    print("You have successfully signed up")
                    
                    
                    let ref = Database.database().reference()
                    let childRef = ref.child("Users").child((user?.uid)!)
                    // childRef = childRef.childByAutoId()
                    //"21.8257° N, 76.3526° E"
                    // (self.locationCor.coordinate.latitude)
                    // (self.locationCor.coordinate.longitude)
                    //let  userUid = string
                    let values = [ "fireUserid" : user?.uid , "firstName" : self.firstNameTF.text! , "lastName" : self.lastNameTF.text! ,  "picUrl" : self.urlStr, "email" : self.emailTF.text! ,  "password" : self.passwordTF.text! ,  "latitude" : "\(self.locationCor.coordinate.latitude)" , "longitude" :  "\(self.locationCor.coordinate.longitude)" ] as [String : Any]
                    childRef.updateChildValues(values, withCompletionBlock: {(error , ref )in
                        if error != nil
                        {
                            self.container.removeFromSuperview()
                            self.actInd.stopAnimating()
                            
                            print(error! )
                            return
                        }else
                        {
                        //let moreAlert=UIAlertView(title: "Your Account has been created succesfully.", message: "", delegate: self, cancelButtonTitle: "Ok")
                        var moreAlert=UIAlertView(title: "Your Account has been created succesfully.", message: "", delegate: self, cancelButtonTitle: "Ok", otherButtonTitles: "Return to Login" )
                            
                            moreAlert.tag=112;
                            moreAlert.show()
                           
                            self.container.removeFromSuperview()
                            self.actInd.stopAnimating()
                            
                        }
                    })
                    
                    
                    
                }
                else
                {
                    self.container.removeFromSuperview()
                    self.actInd.stopAnimating()
                    print("Error Auth:\(String(describing: error))")
                    
                    let moreAlert=UIAlertView(title: "Error Auth:\(String(describing: error))", message:"", delegate: self, cancelButtonTitle: "Ok")
                    moreAlert.show()

                }
            }
            
            
        }
        
    }
}
