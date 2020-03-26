//
//  AppCenter+Kelpie.swift
//  Kelpie
//
//  Created by Elliott Kipper on 3/26/20.
//  Copyright © 2020 Kip. All rights reserved.
//

import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import Foundation

extension MSAppCenter: LaunchPreparable {
    
    static func prepareAtAppLaunch() {
        MSAppCenter.start("d1ea1ddb-7f7d-4648-84b6-f868042edb6b", withServices: [
          MSAnalytics.self,
          MSCrashes.self
        ])
    }
    
}
