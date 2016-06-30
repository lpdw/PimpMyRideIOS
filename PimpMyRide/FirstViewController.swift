//
//  FirstViewController.swift
//  PimpMyRide
//
//  Created by Yassin Aghani on 27/06/16.
//  Copyright © 2016 Yassin Aghani. All rights reserved.
//

import MBCircularProgressBar
import Alamofire
import UIKit
import CoreBluetooth

class FirstViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    var manager:CBCentralManager? = nil
    var scooter:CBPeripheral!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBOutlet weak var circularProgressBar: MBCircularProgressBarView!
    @IBOutlet weak var dashboardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let token = defaults.objectForKey("Token") as! String
        print("token=============================================================",token)
        
        manager  = CBCentralManager(delegate:self, queue:nil, options: nil)
        
        self.dashboardView.layer.shadowColor = UIColor.flatGrayColor().CGColor
        self.dashboardView.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.dashboardView.layer.shadowOpacity = 0.4
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        var msg = ""
        switch (central.state) {
        case .PoweredOff:
            msg = "CoreBluetooth BLE hardware is powered off"
        case .PoweredOn:
            msg = "CoreBluetooth BLE hardware is powered on and ready"
        case .Resetting:
            msg = "CoreBluetooth BLE hardware is resetting"
            
        case .Unauthorized:
            msg = "CoreBluetooth BLE state is unauthorized"
            
        case .Unknown:
            msg = "CoreBluetooth BLE state is unknown"
            
        case .Unsupported:
            msg = "CoreBluetooth BLE hardware is unsupported on this platform"
            
        }
        print(msg)
        
        central.scanForPeripheralsWithServices(nil, options: nil)
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        
        if (peripheral.name == "PIMPMYRIDE"){
            print("Discovered: \(peripheral.name) at \(RSSI)")
            //print("AdvertisementData:\(advertisementData)")
            scooter = peripheral
            manager?.connectPeripheral(scooter, options: nil)
            scooter.delegate = self
            manager?.stopScan()
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        print("Services:\(peripheral.services) and error\(error)")
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics(nil, forService: service)
            }
        }
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        
        if let json = String(data: characteristic.value!, encoding: NSUTF8StringEncoding) {
            print("characteristic changed:\(json)")
            
            if let reponse = convertStringToDictionary(json){
                let speed = reponse["speed"] as! CGFloat
                //speedLabel.text = "\(speed)"
                circularProgressBar.value = speed
            }
            
            //let alertController = UIAlertController(title: "Bluetooh", message: message, preferredStyle: .Alert)
            //alertController.addAction(UIAlertAction(title: "Close", style: .Cancel, handler: nil))
            //self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        print("peripheral:\(peripheral) and service:\(service)")
        for characteristic in service.characteristics!
        {
            peripheral.setNotifyValue(true, forCharacteristic: characteristic)
        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("CONNECT")
        peripheral.discoverServices(nil)
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("FAIL")
    }
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("DISCONNECT")
    }
}

