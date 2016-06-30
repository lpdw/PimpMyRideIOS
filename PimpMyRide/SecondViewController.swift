//
//  SecondViewController.swift
//  PimpMyRide
//
//  Created by Yassin Aghani on 27/06/16.
//  Copyright © 2016 Yassin Aghani. All rights reserved.
//

import UIKit
import CoreBluetooth

class SecondViewController: UIViewController, BleDelegate {
    var appDelegate:AppDelegate?
    var colorised:Bool? = false
    
    @IBOutlet weak var FireButton: UIButton!
    @IBOutlet weak var seaButton: UIButton!
    @IBOutlet weak var natureButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBAction func natureButton(sender: AnyObject) {
        if (colorSwitch.on){
            //appDelegate?.bleWrite("nature");
        }
        else{
            let alertController = UIAlertController(title: "ColorPicker", message:"Turn on the light to set a color", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func seaButton(sender: AnyObject) {
        
        if (colorSwitch.on){
            //appDelegate?.bleWrite("sea");
        }
        else{
            let alertController = UIAlertController(title: "ColorPicker", message:"Turn on the light to set a color", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func FireButton(sender: AnyObject) {
        
        if (colorSwitch.on){
            //appDelegate?.bleWrite("fire");
        }
        else{
            let alertController = UIAlertController(title: "ColorPicker", message:"Turn on the light to set a color", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    @IBAction func yellowButton(sender: AnyObject) {
        if (colorSwitch.on){
            appDelegate?.bleWrite("yellow");
        }
        else{
            let alertController = UIAlertController(title: "ColorPicker", message:"Turn on the light to set a color", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func blueButton(sender: AnyObject) {
        if (colorSwitch.on){
            appDelegate?.bleWrite("blue");
        }
        else{
            let alertController = UIAlertController(title: "ColorPicker", message:"Turn on the light to set a color", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var colorSwitch: UISwitch!
    @IBAction func colorSwitch(sender: AnyObject) {
        
        if (colorSwitch.on){
            print("ON")
            yellowButton.backgroundColor = UIColor.flatYellowColor()
            blueButton.backgroundColor = UIColor.flatSkyBlueColor()
            greenButton.backgroundColor = UIColor.flatGreenColor()
            redButton.backgroundColor = UIColor.redColor()
            FireButton.titleLabel?.textColor = UIColor.redColor()
            seaButton.titleLabel?.textColor = UIColor.flatSkyBlueColor()
            natureButton.titleLabel?.textColor = UIColor.flatGreenColor()
        }
        else{
            print("OFF")
            yellowButton.backgroundColor = UIColor.flatGrayColor()
            blueButton.backgroundColor = UIColor.flatGrayColor()
            greenButton.backgroundColor = UIColor.flatGrayColor()
            redButton.backgroundColor = UIColor.flatGrayColor()
            FireButton.titleLabel?.textColor = UIColor.flatGrayColor()
            seaButton.titleLabel?.textColor = UIColor.flatGrayColor()
            natureButton.titleLabel?.textColor = UIColor.flatGrayColor()
            appDelegate?.bleWrite("none");
        }
    }
    
    @IBAction func greenButton(sender: AnyObject) {
        if (colorSwitch.on){
            appDelegate?.bleWrite("green");
        }
        else{
            let alertController = UIAlertController(title: "ColorPicker", message:"Turn on the light to set a color", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func redButton(sender: AnyObject) {
        if (colorSwitch.on){
            appDelegate?.bleWrite("red");
        }
        else{
            let alertController = UIAlertController(title: "ColorPicker", message:"Turn on the light to set a color", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var bluethootImage: UIImageView!
    @IBOutlet weak var colorView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate!.addBleDelegate(self);
        
        yellowButton.backgroundColor = UIColor.flatGrayColor()
        blueButton.backgroundColor = UIColor.flatGrayColor()
        greenButton.backgroundColor = UIColor.flatGrayColor()
        redButton.backgroundColor = UIColor.flatGrayColor()
        FireButton.titleLabel?.textColor = UIColor.flatGrayColor()
        seaButton.titleLabel?.textColor = UIColor.flatGrayColor()
        natureButton.titleLabel?.textColor = UIColor.flatGrayColor()

        
        self.colorView.layer.shadowColor = UIColor.flatGrayColor().CGColor
        self.colorView.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.colorView.layer.shadowOpacity = 0.4
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bleSendData(data: [String: AnyObject]) {

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
    }
    
    func bleFail(){
        let image = UIImage(named: "bluetooth")
        self.bluethootImage.image = image
        
        let alertController = UIAlertController(title: "Sate", message:"Failed", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
}

