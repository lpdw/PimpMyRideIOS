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

