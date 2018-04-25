//
//  PaidKarmaProViewController.swift
//  KarmaPro
//
//  Created by Macbook Pro on 21/09/17.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

import UIKit

class PaidKarmaProViewController: UIViewController {

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   @IBAction func paidKarma(_ sender: UIButton)
   {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.paidkarmBool = true
    let _ = self.navigationController?.popViewController(animated: true)
   }

}
