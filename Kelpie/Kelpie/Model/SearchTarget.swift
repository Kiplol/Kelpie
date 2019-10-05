//
//  SearchTarget.swift
//  Kelpie
//
//  Created by Elliott Kipper on 9/3/19.
//Copyright © 2019 Kip. All rights reserved.
//

import Foundation
import RealmSwift

protocol SearchTargetUpdatable {
    func update(searchTarget: SearchTarget, query: String?)
}

class SearchTarget: Object {
    
    public static let queryToken: String = "{query}"
    public static var currentQuery: String? {
        didSet {
            if SearchTarget.currentQuery != oldValue {
                NotificationCenter.default.post(name: self.currentQueryDidChange, object: self.currentQuery)
            }
        }
    }
    public static let currentQueryDidChange = Notification.Name("SearchTarget.currentQueryDidChange")
    
    // MARK: - ivars
    @objc dynamic var name: String = ""
    @objc dynamic var url: String = "kelpie://"
    @objc dynamic var colorHex: String?
    @objc dynamic var lastUsed: Date = .distantPast
    
    convenience init(name: String, url: String, colorHex: String? = nil) {
        self.init()
        self.name = name
        self.url = url
        self.colorHex = colorHex
    }
    
    convenience init?(values: [String: AnyHashable]) {
        guard let name = values["name"] as? String,
            let url = values["url"] as? String else {
                return nil
        }
        let colorHex = values["color"] as? String
        self.init(name: name, url: url, colorHex: colorHex)
    }
    
    // MARK: - Business Logic
    func executeSearch(query: String) {
        let escaped = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let resultURLString = self.url.replacingOccurrences(of: SearchTarget.queryToken, with: escaped)
        guard let resultURL = URL(string: resultURLString) else {
            return
        }
        UIApplication.shared.open(resultURL, options: [:], completionHandler: nil)
        self.markUsed()
    }
    
    func markUsed() {
        let realm = try! Realm()
        try! realm.write {
            self.lastUsed = Date()
        }
    }
    
    // MARK: - DB
    class func named(_ name: String) -> SearchTarget? {
        return try! Realm().objects(self.self).filter("name = %@", name).first
    }
    
    class func all() -> Results<SearchTarget> {
        let realm = try! Realm()
        return realm.objects(self)
    }
    
}

extension SearchTarget: LaunchPreparable {
    
    // MARK: - IMDb
    class func getOrMakeIMDb() -> SearchTarget {
        if let cached = self.named("IMDb") {
            return cached
        }
        let imdb = SearchTarget.init(name: "IMDb",
                                     url: "https://www.imdb.com/find?q=\(SearchTarget.queryToken)",
            colorHex: "#f5de50")
        let realm = try! Realm()
        try! realm.write {
            realm.add(imdb)
        }
        return imdb
    }
    
    class func getOrMakeDefaults() {
        guard let plistPath = Bundle.main.path(forResource: "default_search_targets", ofType: "plist") else {
            return
        }
        guard let contents = NSDictionary(contentsOfFile: plistPath) as? [String: AnyHashable],
            let dicts = contents["searchTargets"] as? [[String: AnyHashable]] else {
                return
        }
        let realm = try! Realm()
        try! realm.write {
            dicts.filter {
                guard let name = $0["name"] as? String else {
                    return false
                }
                return SearchTarget.named(name) == nil
            }.forEach {
                if let newTarget = SearchTarget(values: $0) {
                    realm.add(newTarget)
                }
            }
        }
    }
    
    // MARK: - LaunchPreparable
    static func prepareAtAppLaunch() {
        _ = self.getOrMakeDefaults()
    }
}
