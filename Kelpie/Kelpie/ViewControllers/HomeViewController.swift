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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchBar.text = SearchTarget.currentQuery
        self.constraintBeneathSearchBarContainer.constant = 20.0
        self.view.layoutIfNeeded()
//        self.setUpSnapBehavior()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.constraintBeneathSearchBarContainer.constant = 0.0 - self.view.safeAreaInsets.bottom -
            self.searchBarContainer.bounds.size.height
        self.view.layoutIfNeeded()
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
        let searchVC = AdvancedSearchViewController.fromStoryboard()
        searchVC.initialSearchQuery = self.searchBar.text
        self.present(searchVC, animated: true, completion: nil)
        return false
    }
    
}

extension HomeViewController {
    
    private func setUpSnapBehavior() {
        guard self.animator == nil else { return }
        self.animator = UIDynamicAnimator(referenceView: self.view)
        self.snappingBehavior = UISnapBehavior(item: self.searchBarContainer,
                                               snapTo: self.searchBarContainer.center)
        self.animator.addBehavior(self.snappingBehavior)
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
            print(distance)
            self.searchBarContainer.center = CGPoint(x: self.searchBarContainer.center.x + translation.x,
                                                     y: self.searchBarContainer.center.y + translation.y)
            recognizer.setTranslation(.zero, in: self.view)
        case .ended, .cancelled, .failed:
            self.animator.addBehavior(self.snappingBehavior)
        default:
            break
        }
    }
    
}
