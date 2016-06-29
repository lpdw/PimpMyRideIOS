//
//  LoginViewController.swift
//  PimpMyRide
//
//  Created by Mangubu on 28/06/2016.
//  Copyright © 2016 Yassin Aghani. All rights reserved.
//


import Alamofire
import UIKit
import ChameleonFramework

class LoginViewController: UIViewController {
    //let username = "Admin"
    //let password = "password"
    
    @IBOutlet weak var usernameField: UITextView!
    
    @IBOutlet weak var passwordField: UITextView!
    
    @IBOutlet weak var connectButton: UIButton!
    
    @IBAction func connectButton(sender: AnyObject) {
        print("usernameField :", usernameField.text)
        print("passwordField :", passwordField.text)
        
        let url = "https://pimp-my-ride.herokuapp.com/token"
        
        Alamofire.request(.POST, url , parameters: ["username": usernameField.text,"password": passwordField.text ])
         .responseJSON {
            response in switch response.result {
            case .Success(let JSON):
                print("Success with JSON: \(JSON)")
                
                let response = JSON as! NSDictionary
                if ((response.objectForKey("err")) != nil){
                    let alertController = UIAlertController(title: "Error", message:"Verify your username or password", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                else if ((response.objectForKey("token")) != nil){
                    
                    self.performSegueWithIdentifier("loginSegue", sender: self)
                }
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
         
         }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.flatBlackColorDark()
        
        self.usernameField.layer.borderColor = UIColor(colorLiteralRed: 96/255, green: 96/255, blue: 96/255, alpha: 1).CGColor
        self.usernameField.layer.borderWidth = CGFloat(Float(1.0))
        self.usernameField.layer.cornerRadius = CGFloat(Float(2.0))
        self.usernameField.frame.size.height = 100
        
        self.connectButton.backgroundColor = UIColor.flatGreenColor()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loginSegue" {
            if let destination = segue.destinationViewController as? FirstViewController {
                destination.receivedUsername = self.usernameField.text
                destination.receivedPassword = self.passwordField.text
            }
        }
    }
}
