//
//  CherechterPageViewController.swift
//  KarmaPro
//
//  Created by Macbook Pro on 09/09/17.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

import UIKit

class CherechterPageViewController: UIViewController {
    
    
    
    //charector Label
    
    @IBOutlet weak var char1Label: UILabel!
    @IBOutlet weak var char2Label: UILabel!
    @IBOutlet weak var char3Label: UILabel!
    @IBOutlet weak var char4Label: UILabel!
    @IBOutlet weak var char5Label: UILabel!
    @IBOutlet weak var char6Label: UILabel!
    @IBOutlet weak var char7Label: UILabel!
    @IBOutlet weak var char8Label: UILabel!
    @IBOutlet weak var char9Label: UILabel!
    @IBOutlet weak var char10Label: UILabel!
    @IBOutlet weak var char11Label: UILabel!
    @IBOutlet weak var char12Label: UILabel!
    @IBOutlet weak var char13Label: UILabel!
    @IBOutlet weak var char14Label: UILabel!
    @IBOutlet weak var char15Label: UILabel!
    @IBOutlet weak var char16Label: UILabel!
    @IBOutlet weak var char17Label: UILabel!
    @IBOutlet weak var char18Label: UILabel!
    @IBOutlet weak var char19Label: UILabel!
    @IBOutlet weak var char20Label: UILabel!
    @IBOutlet weak var char21Label: UILabel!
    @IBOutlet weak var char22Label: UILabel!
    
   
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.labelDesgn()
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        self.navigationItem.title = "KarmaPro"
        
        let testUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu(1).png"), style: .plain, target: self, action: #selector(CherechterPageViewController.clickButton))
        //self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
       
        
        let testUIBarButtonItemL = UIBarButtonItem(image: UIImage(named: "left-arrow.png"), style: .plain, target: self, action: #selector(CherechterPageViewController.clickButtonL))
        self.navigationItem.leftBarButtonItem  = testUIBarButtonItemL


        // Do any additional setup after loading the view.
    }
    
    
    func clickButton(){
        print("button click")
    }
    
    func clickButtonL(){
        
        _ = self.navigationController?.popViewController(animated: false)
        print("button click")
    }

    func labelDesgn()
    {
        char1Label.layer.cornerRadius = 7
        char1Label.layer.masksToBounds = true
        char2Label.layer.cornerRadius = 7
        char2Label.layer.masksToBounds = true
        char3Label.layer.cornerRadius = 7
        char3Label.layer.masksToBounds = true
        char4Label.layer.cornerRadius = 7
        char4Label.layer.masksToBounds = true
        char5Label.layer.cornerRadius = 7
        char5Label.layer.masksToBounds = true
        char6Label.layer.cornerRadius = 7
        char6Label.layer.masksToBounds = true
        char7Label.layer.cornerRadius = 7
        char7Label.layer.masksToBounds = true
        char8Label.layer.cornerRadius = 7
        char8Label.layer.masksToBounds = true
        char9Label.layer.cornerRadius = 7
        char9Label.layer.masksToBounds = true
        char10Label.layer.cornerRadius = 7
        char10Label.layer.masksToBounds = true
        char11Label.layer.cornerRadius = 7
        char11Label.layer.masksToBounds = true
        char12Label.layer.cornerRadius = 7
        char12Label.layer.masksToBounds = true
        char13Label.layer.cornerRadius = 7
        char13Label.layer.masksToBounds = true
        char14Label.layer.cornerRadius = 7
        char14Label.layer.masksToBounds = true
        char15Label.layer.cornerRadius = 7
        char15Label.layer.masksToBounds = true
        char16Label.layer.cornerRadius = 7
        char16Label.layer.masksToBounds = true
        char17Label.layer.cornerRadius = 7
        char17Label.layer.masksToBounds = true
        char18Label.layer.cornerRadius = 7
        char18Label.layer.masksToBounds = true
        char19Label.layer.cornerRadius = 7
        char19Label.layer.masksToBounds = true
        char20Label.layer.cornerRadius = 7
        char20Label.layer.masksToBounds = true
        char21Label.layer.cornerRadius = 7
        char21Label.layer.masksToBounds = true
        char22Label.layer.cornerRadius = 7
        char22Label.layer.masksToBounds = true
        
    }

}
