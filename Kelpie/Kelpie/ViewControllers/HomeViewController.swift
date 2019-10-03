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
    private var searchTargets: Results<SearchTarget>!
    private var searchTargetsNotificationToken: NotificationToken?
    
    // MARK: - IBOutlets
    @IBOutlet weak var labelStats: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarContainer: UIView!
    @IBOutlet weak var constraintBeneathSearchBarContainer: NSLayoutConstraint!
    
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
        self.searchTargets = SearchTarget.all()
        super.viewDidLoad()
        
        self.searchTargetsNotificationToken = self.searchTargets
            .observe { [weak self] changes in
                self?.searchTargetsChanged(changes)
        }
        let bg = [UIColor.black.alpha(0.0), UIColor.black.alpha(0.4)].gradient()
        bg.frame = self.view.bounds
        self.view.layer.insertSublayer(bg, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.constraintBeneathSearchBarContainer.constant = 20.0
        self.view.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.constraintBeneathSearchBarContainer.constant = 0.0 - self.view.safeAreaInsets.bottom -
            self.searchBarContainer.bounds.size.height
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Realm
    private func searchTargetsChanged(_ changes: RealmCollectionChange<Results<SearchTarget>>) {
        let count = self.searchTargets.count
        self.labelStats.text = "\(count) search target\(count == 1 ? "" : "s")"
    }
}

extension HomeViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let searchVC = AdvancedSearchViewController.fromStoryboard()
        searchVC.initialSearchQuery = self.searchBar.text
        self.present(searchVC, animated: true, completion: nil)
        return false
    }
    
}
