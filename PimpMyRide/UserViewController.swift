//
//  ParameterViewController.swift
//  PimpMyRide
//
//  Created by Mangubu on 30/06/2016.
//  Copyright © 2016 Yassin Aghani. All rights reserved.
//

import UIKit
import CoreBluetooth
import Alamofire

class UserViewController: UIViewController, BleDelegate {
    
    var appDelegate:AppDelegate?
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBAction func deconnexionButton(sender: AnyObject) {
        
        self.performSegueWithIdentifier("decoSegue", sender: self)
        
    }
    @IBOutlet weak var needConnectSwitch: UISwitch!

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var nbCooterLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userDataView: UIView!
    @IBOutlet weak var displayNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userDataView.layer.shadowColor = UIColor.flatGrayColor().CGColor
        self.userDataView.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.userDataView.layer.shadowOpacity = 0.4
        
        let token = defaults.objectForKey("Token") as! String
        print("token=============================================================",token)
        
        let url = "https://pimp-my-ride.herokuapp.com/users/me"
        
        Alamofire.request(.GET, url , parameters: ["token": token])
            .responseJSON {
                response in switch response.result {
                case .Success(let JSON):
                    print("PARAMETERS PAGE Success with JSON: \(JSON)")
                    let response = JSON as! NSDictionary
                    let user = response.objectForKey("user") as! NSDictionary
                    let displayName = user.objectForKey("displayName") as! String
                    let userName = user.objectForKey("username") as! String
                    let email = user.objectForKey("email") as! String
                    let scooters = user.objectForKey("scooters")
                    let nbScooter = scooters!.count as Int
                    
                    print ("SCOOTER =========================================>", nbScooter)
                    //let displayName = self.defaults.objectForKey("displayName") as! String
                    
                    self.displayNameLabel.text = displayName
                    self.emailLabel.text = email
                    self.usernameLabel.text = userName
                    self.nbCooterLabel.text = "\(nbScooter)"
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
                
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bleSendData(data: [String: AnyObject]) {
        
    }
    
    
    func bleConnect(){
        let alertController = UIAlertController(title: "Sate", message:"Connected", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func bleDisconnect(){
        let alertController = UIAlertController(title: "Sate", message:"Disconnected", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func bleFail(){
        let alertController = UIAlertController(title: "Sate", message:"Failed", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
}
