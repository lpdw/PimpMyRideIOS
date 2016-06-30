//
//  AppDelegate.swift
//  PimpMyRide
//
//  Created by Yassin Aghani on 27/06/16.
//  Copyright © 2016 Yassin Aghani. All rights reserved.
//

import UIKit
import CoreBluetooth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CBCentralManagerDelegate, CBPeripheralDelegate {

    var window: UIWindow?
    var manager:CBCentralManager?
    var scooter:CBPeripheral?
    var characteristic:CBCharacteristic?
    var bleDelegates:[BleDelegate] = []


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //change status bar color
        UIApplication.sharedApplication().statusBarHidden = false
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        manager  = CBCentralManager(delegate:self, queue:nil, options: nil)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch (central.state) {
        case .PoweredOff:
            print("CoreBluetooth BLE hardware is powered off")
        case .PoweredOn:
            print("CoreBluetooth BLE hardware is powered on and ready")
            central.scanForPeripheralsWithServices(nil, options: nil)
        case .Resetting:
            print("CoreBluetooth BLE hardware is resetting")
            
        case .Unauthorized:
            print("CoreBluetooth BLE state is unauthorized")
            
        case .Unknown:
            print("CoreBluetooth BLE state is unknown")
            
        case .Unsupported:
            print("CoreBluetooth BLE hardware is unsupported on this platform")
            
        }
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        
        if (peripheral.name == "PIMPMYRIDE"){
            print("Discovered: \(peripheral.name) at \(RSSI)")
            scooter = peripheral
            manager?.connectPeripheral(scooter!, options: nil)
            scooter!.delegate = self
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
            if let data = convertStringToDictionary(json){
                for bleDelegate in bleDelegates {
                    bleDelegate.bleSendData(data);
                }
            }
        }
    }
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        print("peripheral:\(peripheral) and service:\(service)")
        
        for characteristic in service.characteristics!
        {
            self.characteristic = characteristic
            peripheral.setNotifyValue(true, forCharacteristic: characteristic)
        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("CONNECT")
        peripheral.discoverServices(nil)
        for bleDelegate in bleDelegates {
            bleDelegate.bleConnect();
        }
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("FAIL")
        scooter = nil
        central.scanForPeripheralsWithServices(nil, options: nil)
        for bleDelegate in bleDelegates {
            bleDelegate.bleFail();
        }
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("DISCONNECT")
        scooter = nil
        central.scanForPeripheralsWithServices(nil, options: nil)
        for bleDelegate in bleDelegates {
            bleDelegate.bleDisconnect();
        }
    }
    
    func addBleDelegate(bleDelegate: BleDelegate) {
        bleDelegates.append(bleDelegate)
        
        if(scooter != nil){
            bleDelegate.bleConnect()
        }
    }
    
    func bleWrite(data: String){
        if(scooter != nil){
            scooter!.writeValue(data.dataUsingEncoding(NSASCIIStringEncoding)!, forCharacteristic: self.characteristic!, type: CBCharacteristicWriteType.WithoutResponse)
        }
    }

}

