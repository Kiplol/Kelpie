//
//  GeneralProtocols.swift
//  Kelpie
//
//  Created by Elliott Kipper on 9/3/19.
//  Copyright © 2019 Kip. All rights reserved.
//

protocol LaunchPreparable {
   static func prepareAtAppLaunch()
}

import RealmSwift
extension Realm: LaunchPreparable {
    static func prepareAtAppLaunch() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 2,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { _, _ in
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        _ = try! Realm()
    }
}
