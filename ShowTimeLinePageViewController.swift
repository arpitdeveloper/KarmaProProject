//
//  ShowTimeLinePageViewController.swift
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

class ShowTimeLinePageViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var  timeLineGetMUid   = String()
    var  arrayMessageFinal = [PostStringHold]()
    var  arrayMessageFinalST = [PostStringHold]()
    @IBOutlet weak var mytableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.observeMessage()
        
        
        mytableView.register(UINib(nibName: "TimeLineTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")

        self.automaticallyAdjustsScrollViewInsets = false
        mytableView.delegate = self
        mytableView.dataSource = self
        
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        self.navigationItem.title = "KarmaPro"
        
        let testUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu(1).png"), style: .plain, target: self, action: #selector(ShowTimeLinePageViewController.clickButton))
        //self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
        
        
        let testUIBarButtonItemL = UIBarButtonItem(image: UIImage(named: "left-arrow.png"), style: .plain, target: self, action: #selector(ShowTimeLinePageViewController.clickButtonL))
        self.navigationItem.leftBarButtonItem  = testUIBarButtonItemL

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.mytableView.reloadData()
        
        
    }
    
    func observeMessage()
    {
        let ref = Database.database().reference().child("publicPostKarma")
        
        ref.observe(.childAdded, with: { firDataSnapshot in
            
            print(firDataSnapshot)
            if let firebaseDic = firDataSnapshot.value as? [String: AnyObject]
            {
                
                
                let userObj = PostStringHold()
                userObj.setValuesForKeys(firebaseDic)
                self.arrayMessageFinal.append(userObj)
                
                DispatchQueue.main.async
                    {
                      //  self.arrayMessageFinal.removeAll()
                        self.mytableView.reloadData()
                      //  self.boolBottom = false
                }
                
            }
            
        }, withCancel: nil )
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
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        var intCount = 0
        arrayMessageFinalST.removeAll()
        for item in arrayMessageFinal
        {
            
            if arrayMessageFinal.count > intCount
            {
                
                
                let postShow   = arrayMessageFinal[intCount];
              
            //print("Item \(intCount): \(messageShow.MUid)\(messageShow.FromuserID)\(MUid)")
                
                let FromuserID = Auth.auth().currentUser?.uid
               
                
                if postShow.publicPostToID == timeLineGetMUid
                {
                    
                    self.arrayMessageFinalST.append(postShow)
                    
                }
                else
                {
                    
                    arrayMessageFinal.remove(at: intCount)
                }
                intCount = intCount + 1
            }
        }
        
        return arrayMessageFinalST.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as! TimeLineTableViewCell;
        
        if self.arrayMessageFinalST.count > indexPath.row
        {
        let postShow   = self.arrayMessageFinalST[indexPath.row];
        
        //if postShow.publicPostToID == appDelegate.MUid
      //  {
            cell.descriptionLabel.text  = postShow.publicPostStr
            
            if  appDelegate.paidkarmBool == true
            {
                for (index, element) in self.appDelegate.allUserArray.enumerated() {
                    let userIdName   = self.appDelegate.allUserArray[index];
                    
                    if postShow.PublicpostFromID == userIdName.fireUserid
                    {
                        cell.anonymousLabel.text    = "From : " + userIdName.firstName! + " " + userIdName.lastName!
                    }
                    
                    
                }
                
            }
            else
            {
                if postShow.FromAnonymousOrName == ""
                {
                    cell.anonymousLabel.text    = "From : " + "Anonymous"
                }
                else
                {
                    cell.anonymousLabel.text    = "From : " + postShow.FromAnonymousOrName!
                }

            }
        
            let nsstring  = NSString(string: postShow.postStar!)
            cell.floatRatingView.rating  = nsstring.floatValue
        //}

        
        }
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
            return 75
    }


    

}
