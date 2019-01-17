//
//  Location.swift
//  Sprint Treads
//
//  Created by Vivek Rai on 17/01/19.
//  Copyright © 2019 Vivek Rai. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object {
    @objc dynamic public private(set) var latitude = 0.0
    @objc dynamic public private(set) var longitude = 0.0
    
    convenience init(latitude: Double, longitude: Double) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude
    }
}
