//
//  RequestAccess.swift
//  Stase
//
//  Created by 宋志勇 on 2020/5/9.
//  Copyright © 2020 宋志勇. All rights reserved.
//

import UIKit
import HealthKitUI

let healhStore = HKHealthStore()

func requestAccesToHealhKit() {
    
    let allTypes = Set([HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!])
    
    healhStore.requestAuthorization(toShare: allTypes, read: allTypes) {(success, error) in
        if  !success {
            print("\(String(describing: error))")
        }
    }
}
