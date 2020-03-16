//
//  SearchHistory.swift
//  Kelpie
//
//  Created by Elliott Kipper on 3/13/20.
//  Copyright © 2020 Kip. All rights reserved.
//

import RealmSwift

class SearchHistory: Object {

    // MARK: - ivars
    @objc dynamic var searchTarget: SearchTarget!
    @objc dynamic var query: String!
    @objc dynamic var lastUsed: Date!
    
    // MARK: - Initialization
    convenience init(searchTarget: SearchTarget, query: String, lastUsed: Date = Date()) {
        self.init()
        self.searchTarget = searchTarget
        self.query = query
        self.lastUsed = lastUsed
    }
    
    // MARK: -
    func execute() {
        Realm.makeChanges {
            self.lastUsed = Date()
        }
        self.searchTarget.executeSearch(query: self.query)
    }
    
    // MARK: - Helpers
    class func allSortedByDate(ascending: Bool = false) -> Results<SearchHistory> {
        let realm = try! Realm()
        return realm.objects(self).sorted(byKeyPath: "lastUsed", ascending: false)
    }
    
}
