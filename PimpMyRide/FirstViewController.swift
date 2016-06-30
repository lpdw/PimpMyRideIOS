//
//  FirstViewController.swift
//  PimpMyRide
//
//  Created by Yassin Aghani on 27/06/16.
//  Copyright © 2016 Yassin Aghani. All rights reserved.
//

import MBCircularProgressBar
import CoreLocation
import Alamofire
import UIKit
import CoreBluetooth

class FirstViewController: UIViewController, CLLocationManagerDelegate, BleDelegate {
    var manager:CBCentralManager? = nil
    var scooter:CBPeripheral!
    var characteristic:CBCharacteristic?
    var alamofireManager : Alamofire.Manager?

    
    let locationManager = CLLocationManager()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var bluethootImage: UIImageView!
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBOutlet weak var circularProgressBar: MBCircularProgressBarView!
    @IBOutlet weak var dashboardView: UIView!
    @IBOutlet weak var temperatureProgressBar: MBCircularProgressBarView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityProgressBar: MBCircularProgressBarView!
    
    @IBOutlet weak var humidityLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.addBleDelegate(self);
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        let token = defaults.objectForKey("Token") as! String
        print("token=============================================================",token)
        
        //FIRST WE NEED TO HAVE SCOOTER _ID FROM /user/me
         let urlForUser = "https://pimp-my-ride.herokuapp.com/users/me"
         Alamofire.request(.GET, urlForUser , parameters: ["token": token])
         .responseJSON {
         response in switch response.result {
         case .Success(let JSON):
         print("PARAMETERS PAGE Success with JSON ================>: \(JSON)")
         let response = JSON as! NSDictionary
         let user = response.objectForKey("user") as! NSDictionary
         let scooters = user.objectForKey("scooters") as! NSArray
         let scooterId = scooters.firstObject as! String
         
         print ("USER =========================================>", scooterId)
         
         //THEN WE NEED TO HAVE arduinoD FROM scooters/:arduinoID
         let urlForArduinoID = "https://pimp-my-ride.herokuapp.com/scooters/\(scooterId)"
         print("urlForArduinoID ======================>",urlForArduinoID)
         Alamofire.request(.GET, urlForArduinoID , parameters: ["token": token])
            .responseJSON {
                response in switch response.result {
                case .Success(let JSON):
                    print("PARAMETERS PAGE Success with JSON: \(JSON)")
                    let response = JSON as! NSDictionary
                    let scooter = response.objectForKey("scooter") as! NSDictionary
                    let arduinoID = scooter.objectForKey("arduinoID") as! String
                    
                    print ("ARDUINOID =========================================>", arduinoID)
                    //let displayName = self.defaults.objectForKey("displayName") as! String
                
                    
                    //THEN WE NEED TO UPDATE SCOOTER VALUE WITH DATA FROM BLE  scooters/:arduinoID
                    let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
                    configuration.timeoutIntervalForResource = 2 // seconds
                    
                    
                    let urlForUpdate = "https://pimp-my-ride.herokuapp.com/scooters/\(arduinoID)"
                    print("URL======================>",urlForUpdate)
                    self.alamofireManager = Alamofire.Manager(configuration: configuration)
                    self.alamofireManager!.request(.PUT, urlForUpdate , parameters: ["token": token,"temperature": "100","humidity": "100","speed": "100"])
                        .responseJSON {
                            response in switch response.result {
                            case .Success(let JSON):
                                print("PARAMETERS PAGE Success with JSON: \(JSON)")
                                let response = JSON as! NSDictionary
                                
                                print ("FINALRESPONSE =========================================>", response)
                                //let displayName = self.defaults.objectForKey("displayName") as! String
                                
                            case .Failure(let error):
                                print("Request failed with error for Updating scooter data: \(error)")
                            }
                    }
                    
                case .Failure(let error):
                    print("Request failed with error for arduino ID: \(error)")
                }
                
            }

         case .Failure(let error):
         print("Request failed with error for Scooter _id: \(error)")
         }
         
         }
        
        self.dashboardView.layer.shadowColor = UIColor.flatGrayColor().CGColor
        self.dashboardView.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.dashboardView.layer.shadowOpacity = 0.4
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func bleSendData(data: [String: AnyObject]) {
        let speed = data["speed"] as! CGFloat
        //speedLabel.text = "\(speed)"
        circularProgressBar.value = speed
        
        let temperature = data["temperature"] as! CGFloat
        temperatureLabel.text = "\(Int(temperature)) °C"
        temperatureProgressBar.value = temperature
        let humidity = data["humidity"] as! CGFloat
        humidityLabel.text = "\(Int(humidity)) %"
        humidityProgressBar.value = humidity
    }
    
    func bleConnect(){
        let image = UIImage(named: "bluetooth-blue")
        self.bluethootImage.image = image
        
        let alertController = UIAlertController(title: "Sate", message:"Connected", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func bleDisconnect(){
        let image = UIImage(named: "bluetooth")
        self.bluethootImage.image = image
        
        let alertController = UIAlertController(title: "Sate", message:"Disconnected", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        circularProgressBar.value = 0.0
        temperatureProgressBar.value = 0.0
        humidityProgressBar.value = 0.0
        temperatureLabel.text = "-- °c"
        humidityLabel.text = "-- %"
    }
    
    func bleFail(){
        let image = UIImage(named: "bluetooth")
        self.bluethootImage.image = image
        
        let alertController = UIAlertController(title: "Sate", message:"Failed", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        circularProgressBar.value = 0.0

    }
}

