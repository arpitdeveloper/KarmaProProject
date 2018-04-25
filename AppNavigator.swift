//
//  AppNavigator.swift
//  OLX_SJ
//
//  Created by Ankit Nigam on 08/07/17.
//  Copyright © 2017 Sumit Jagdev. All rights reserved.
//

import UIKit
import CoreLocation

enum LeftButtonType {
    case BACK
    case Menu
}

let appStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

class AppNavigator: UINavigationController, CLLocationManagerDelegate  , UITabBarControllerDelegate {

    static var navigator : AppNavigator = {
        let rootVC = AppNavigator.getWelcomeController()
        let instance : AppNavigator = AppNavigator(rootViewController: rootVC)
        instance.navigationBar.tintColor = UIColor.white
        instance.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        let color = UIColor(hex: "2A0A36")
        instance.navigationBar.barTintColor = color
        return instance
    }()
    
    //var locationManager : CLLocationManager!
    //var currentLocation : CLLocation!
   // var progressHUD : MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        locationManager = CLLocationManager()
//        locationManager.delegate = self;
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        isAuthorizedtoGetUserLocation()
//        locationManager.startUpdatingLocation()
        
      //  progressHUD = MBProgressHUD()
       // progressHUD.mode = MBProgressHUDMode.indeterminate
    //    self.view.addSubview(progressHUD)
        // Do any additional setup after loading the view.
    }

    
    //this method will be called each time when a user change his location access preference.
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedAlways {
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.startUpdatingLocation()
////            let locValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
////            print("locations = \(locValue.latitude) \(locValue.longitude)")
//        }//if authorized
//    }//locationManager func declaration
//
//    //if we have no permission to access user location, then ask user for permission.
//    func isAuthorizedtoGetUserLocation() {
//        
//        if CLLocationManager.authorizationStatus() != .authorizedAlways     {
//            locationManager.requestAlwaysAuthorization()
//        }
//    }
//    
//    //this method is called by the framework on         locationManager.requestLocation();
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("Did location updates is called")
//        currentLocation = locations.first
//        
//        //store the user location here to firebase or somewhere
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Did location updates is called but failed getting location \(error)")
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    static func showNavigationBar(){
        AppNavigator.navigator.setNavigationBarHidden(false, animated: true)
    }
    static func hideNavigationBar(){
        AppNavigator.navigator.setNavigationBarHidden(true, animated: true)
    }

    
    static func showProgressLoading(){
      //  AppNavigator.navigator.progressHUD.show(true)
    }
    static func hideProgressLoading(){
      //  AppNavigator.navigator.progressHUD.hide(inMainQueue: true)
    }
    
    static func PUSH(viewController : UIViewController){
        AppNavigator.navigator.pushViewController(viewController, animated: true)
    }
    static func POP(){
        AppNavigator.navigator.popViewController(animated: true)
    }
    // MARK: - Navigation Buttons
    static func setLeftButton(type : LeftButtonType, onVC: UIViewController) {
        if type == .BACK {
            let buttonImage = #imageLiteral(resourceName: "ic_backArrow")
            onVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: buttonImage, style: .plain, target: AppNavigator.navigator, action:  #selector(backButtonTapped))
        }else if type == .Menu {
            let buttonImage = #imageLiteral(resourceName: "ic_menu")
            onVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: buttonImage, style: .plain, target: AppNavigator.navigator, action:  #selector(menuButtonTapped))
        }
    }
    
    func backButtonTapped() {
        AppNavigator.POP()
    }
    
    func menuButtonTapped() {
       // SJSwiftSideMenuController.toggleLeftSideMenu()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension AppNavigator {
    static func getWelcomeController() -> testViewController{
        let instance = appStoryBoard.instantiateViewController(withIdentifier: "testViewController")
        return instance as! testViewController
    }
    
    static func getSideMenuController() -> TabbarVC{
        let instance = appStoryBoard.instantiateViewController(withIdentifier: "TabbarVC")
        return instance as! TabbarVC
    }
//    
    static func getSignUpController() -> SignUPKarmaViewController{
        let instance = appStoryBoard.instantiateViewController(withIdentifier: "SignUPKarmaViewController")
        return instance as! SignUPKarmaViewController
    }
//    
//    static func getLoginController() -> LoginController{
//        let instance = appStoryBoard.instantiateViewController(withIdentifier: "LoginController")
//        return instance as! LoginController
//    }
//    static func getTermsAndConditionController() -> TermsAndConditionController{
//        let instance = appStoryBoard.instantiateViewController(withIdentifier: "TermsAndConditionController")
//        return instance as! TermsAndConditionController
//    }
//    static func getPrivacyPolicyController() -> PrivacyPolicyController{
//        let instance = appStoryBoard.instantiateViewController(withIdentifier: "PrivacyPolicyController")
//        return instance as! PrivacyPolicyController
//    }

}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
