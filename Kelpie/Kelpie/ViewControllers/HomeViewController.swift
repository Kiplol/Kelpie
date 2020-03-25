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
    private var animator: UIDynamicAnimator!
    private var snappingBehavior: UISnapBehavior!
    private var firstAppearance = true
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.currentQueryDidChange(_:)),
                                               name: SearchTarget.currentQueryDidChange, object: nil)
        self.searchTargetsNotificationToken = self.searchTargets
            .observe { [weak self] changes in
                self?.searchTargetsChanged(changes)
        }
        let bg = [UIColor.black.alpha(0.0), UIColor.black.alpha(0.4)].gradient()
        bg.frame = self.view.bounds
        self.view.layer.insertSublayer(bg, at: 0)
        
        self.showSearchVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchBar.text = SearchTarget.currentQuery
        self.constraintBeneathSearchBarContainer.constant = 20.0
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.firstAppearance {
            self.showSearchVC()
        }
        self.firstAppearance = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setUpSnapBehavior()
        self.snappingBehavior.snapPoint = self.searchBarContainer.center
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.constraintBeneathSearchBarContainer.constant = 0.0 - self.view.safeAreaInsets.bottom -
            self.searchBarContainer.bounds.size.height
        self.view.layoutIfNeeded()
    }
    
    // MARK: -
    fileprivate func showSearchVC() {
        let searchVC = AdvancedSearchViewController.fromStoryboard()
        searchVC.initialSearchQuery = self.searchBar.text
        self.present(searchVC, animated: true, completion: nil)
    }
    
    // MARK: - Notifications
    @objc func currentQueryDidChange(_ sender: Any?) {
        guard let newQuery = (sender as? Notification)?.object as? String else {
            return
        }
        self.searchBar.text = newQuery
    }
    
    // MARK: - Realm
    private func searchTargetsChanged(_ changes: RealmCollectionChange<Results<SearchTarget>>) {
        let count = self.searchTargets.count
        self.labelStats.text = "\(count) search target\(count == 1 ? "" : "s")"
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.showSearchVC()
        return false
    }
    
}

extension HomeViewController {
    
    private func setUpSnapBehavior() {
        guard self.animator == nil else { return }
        self.animator = UIDynamicAnimator(referenceView: self.view)
        self.snappingBehavior = UISnapBehavior(item: self.searchBarContainer,
                                               snapTo: self.searchBarContainer.center)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(HomeViewController.pannedView(recognizer:)))
        self.searchBarContainer.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func pannedView(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            self.animator.removeBehavior(self.snappingBehavior)
        case .changed:
            let translation = recognizer.translation(in: self.view)
            let newCenter = CGPoint(x: self.searchBarContainer.center.x + translation.x,
                                    y: self.searchBarContainer.center.y + translation.y)
            let distance = newCenter.distance(from: self.snappingBehavior.snapPoint)
            let maxDistance: CGFloat = 80.0
            let t = distance / maxDistance
            let penis = max(0.0, min(1.0, 1.0 - pow(t, 2.0)))
            self.searchBarContainer.center = CGPoint(x: self.searchBarContainer.center.x + (translation.x * penis),
                                                     y: self.searchBarContainer.center.y + (translation.y * penis))
            recognizer.setTranslation(.zero, in: self.view)
            
            if self.searchBarContainer.center.y <= self.snappingBehavior.snapPoint.y - maxDistance + 20.0 {
                self.showSearchVC()
            }
        case .ended, .cancelled, .failed:
            self.animator.addBehavior(self.snappingBehavior)
        default:
            break
        }
    }
    
}
