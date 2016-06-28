//
//  LoginViewController.swift
//  PimpMyRide
//
//  Created by Mangubu on 28/06/2016.
//  Copyright © 2016 Yassin Aghani. All rights reserved.
//


import Alamofire
import UIKit
//import TextFieldEffects
import ChameleonFramework

class LoginViewController: UIViewController {
    let username = "Admin"
    let password = "password"
    
    let screenSize:CGRect = UIScreen.mainScreen().bounds
    
    @IBOutlet weak var loginView: UIView!
    
    @IBOutlet weak var usernameField: UITextView!
    
    @IBOutlet weak var passwordField: UITextView!
    
    @IBOutlet weak var connectButton: UIButton!
    
    @IBAction func connectButton(sender: AnyObject) {
        print("usernameField :", usernameField.text)
        print("passwordField :", passwordField.text)
        if(usernameField.text == username && passwordField.text == password){
            
            print("connected")
            performSegueWithIdentifier("loginSegue", sender: self)
            
        }
        else{
            let alertController = UIAlertController(title: "Error", message: "Verify your password or login", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.flatBlackColorDark()
        
        
        self.usernameField.layer.borderColor = UIColor(colorLiteralRed: 96/255, green: 96/255, blue: 96/255, alpha: 1).CGColor
        self.usernameField.layer.borderWidth = CGFloat(Float(1.0))
        self.usernameField.layer.cornerRadius = CGFloat(Float(2.0))
        self.usernameField.frame.size.height = 100
        //self.usernameField.textContainerInset =  UIEdgeInsetsMake(8,5,8,5);
        
        self.connectButton.backgroundColor = UIColor.flatGreenColor()
        
        //self.usernameField.layer.cornerRadius = 5
        //self.usernameField.frame = CGRectMake(0.0, usernameField.frame.size.height - 1, usernameField.frame.size.width, 1.0);
        //usernameField.text = "Raul"
        
        
        print("username : ", username)
        print("password : ", password)
        
        let url = "https://httpbin.org/get"
        
        Alamofire.request(.GET, url , parameters: ["foo": "bar"])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
