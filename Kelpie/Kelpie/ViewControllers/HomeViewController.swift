//
//  HomeViewController.swift
//  Kelpie
//
//  Created by Elliott Kipper on 9/3/19.
//  Copyright © 2019 Kip. All rights reserved.
//
import Hue
import RealmSwift
import UIKit

class HomeViewController: UIViewController {
    
    static let storyboardID = "Home"
    
    // MARK: - ivars
    private var searchTargets = SearchTarget.all()
    private var searchTargetsNotificationToken: NotificationToken?
    
    // MARK: - IBOutlets
    @IBOutlet weak var labelStats: UILabel!
    
    // MARK: - Helper
    class func fromStoryboard() -> HomeViewController {
        guard let vc = UIStoryboard(name: "Main", bundle: Bundle.main)
            .instantiateViewController(withIdentifier: storyboardID) as? HomeViewController else {
            fatalError("Check storyboard for missing HomeViewController")
        }
        return vc
    }
    
    // MARK: -
    deinit {
        self.searchTargetsNotificationToken?.invalidate()
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTargetsNotificationToken = self.searchTargets
            .observe { [weak self] changes in
                self?.searchTargetsChanged(changes)
        }
        let bg = [self.view.backgroundColor!, self.view.backgroundColor!.darker].gradient()
        bg.frame = self.view.bounds
        self.view.layer.insertSublayer(bg, at: 0)
    }
    
    // MARK: - Realm
    private func searchTargetsChanged(_ changes: RealmCollectionChange<Results<SearchTarget>>) {
        let count = self.searchTargets.count
        self.labelStats.text = "\(count) search target\(count == 1 ? "" : "s")"
    }
}
