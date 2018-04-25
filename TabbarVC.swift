//
//  TabbarVC.swift
//  SwiftSmartMomma
//
//  Created by Ankit Nigam on 23/05/17.
//  Copyright © 2017 Arpit Trivedi. All rights reserved.
//

import UIKit

class TabbarVC: UITabBarController, UITabBarControllerDelegate {

     var myTabbarController: TabbarVC!
    var  picTo = String()
    var  nameTo = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if  appDelegate.tabCheckbool == true
        {
        self.selectedIndex = 0
        }
       self.myTabbarController = self

      //  myTabbarController.delegate = self;
        self.delegate = self;
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if  appDelegate.tabCheckbool == true
        {
            self.selectedIndex = 0
        }
        // Create Tab one
//        let distination : FacebookViewController! = self.storyboard?.instantiateViewController(withIdentifier: "FacebookViewController") as! FacebookViewController

       // let distination = FacebookViewController() //= self.storyboard?.instantiateViewController(withIdentifier: "FacebookViewController") as! FacebookViewController
        
//        distination.picTo = self.picTo
//        distination.nameTo = self.nameTo
//        let tabOneBarItem = UITabBarItem(title: "Tab 1", image: UIImage(named: "placeholder.png"), selectedImage: UIImage(named: "placeholder.png"))
//        
//        tabOne.tabBarItem = tabOneBarItem
//        
//        
//        // Create Tab two
//        let tabTwo = LoginViewController()
//        let tabTwoBarItem2 = UITabBarItem(title: "Tab 2", image: UIImage(named: "placeholder.png"), selectedImage: UIImage(named: "placeholder.png"))
//        
//        tabTwo.tabBarItem = tabTwoBarItem2
//        
//        
       // self.viewControllers = [distination]
    }
    
    // UITabBarControllerDelegate method
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        print("Selected \(viewController)")
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

}
