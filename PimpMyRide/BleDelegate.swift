//
//  BleDelegate.swift
//  PimpMyRide
//
//  Created by Mangubu on 30/06/2016.
//  Copyright © 2016 Yassin Aghani. All rights reserved.
//

import Foundation

protocol BleDelegate{
    func bleSendData(data: [String: AnyObject])
    func bleConnect()
    func bleDisconnect()
    func bleFail()
}