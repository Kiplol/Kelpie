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
    
    // MARK: - ivars
    @objc dynamic var name: String = ""
    @objc dynamic var url: String = "kelpie://"
    @objc dynamic var colorHex: String?
    
    convenience init(name: String, url: String, colorHex: String? = nil) {
        self.init()
        self.name = name
        self.url = url
        self.colorHex = colorHex
    }
    
    // MARK: - Business Logic
    func executeSearch(query: String) {
        let escaped = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let resultURLString = self.url.replacingOccurrences(of: SearchTarget.queryToken, with: escaped)
        guard let resultURL = URL(string: resultURLString) else {
            return
        }
        UIApplication.shared.open(resultURL, options: [:], completionHandler: nil)
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
    
    // MARK: - LaunchPreparable
    static func prepareAtAppLaunch() {
        _ = self.getOrMakeIMDb()
    }
}
