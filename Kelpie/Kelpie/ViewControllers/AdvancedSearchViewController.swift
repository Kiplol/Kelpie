//
//  ViewController.swift
//  Kelpie
//
//  Created by Elliott Kipper on 9/3/19.
//  Copyright © 2019 Kip. All rights reserved.
//

import KeyboardObserver
import RealmSwift
import UIKit

class AdvancedSearchViewController: UIViewController {
    
    static let storyboardID = "AdvancedSearch"
    private static let cellReuseID = "searchTagetCell"
    
    // MARK: - ivars
    let keyboard = KeyboardObserver()
    private let searchTargets = SearchTarget.all()
    private var searchTargetsNotificationToken: NotificationToken?
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Helper
    class func fromStoryboard() -> AdvancedSearchViewController {
        guard let vc = UIStoryboard(name: "Main", bundle: Bundle.main)
            .instantiateViewController(withIdentifier: storyboardID) as? AdvancedSearchViewController else {
            fatalError("Check storyboard for missing AdvancedSearchViewController")
        }
        return vc
    }
    
    // MARK: -
    deinit {
        self.searchTargetsNotificationToken?.invalidate()
    }
    
    // MARK: - View Lifeccle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTargetsNotificationToken = self.searchTargets
            .observe { [weak self] changes in
                self?.searchTargetsChanged(changes)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.prepareCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: -
    private func prepareCollectionView() {
        let cellNib = UINib(nibName: "SearchTargetCollectionViewCell", bundle: Bundle.main)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: AdvancedSearchViewController.cellReuseID)
    }
    
    // MARK: - Realm
    private func searchTargetsChanged(_ changes: RealmCollectionChange<Results<SearchTarget>>) {
        //@TODO
        self.collectionView.reloadData()
    }
}

extension AdvancedSearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {// called when text starts editing
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool { // return NO to not resign first responder
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) { // called when text ends editing
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // called when text changes (including clear)
        self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { // called when keyboard search button pressed
        searchBar.resignFirstResponder()
    }
}

extension AdvancedSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchTargets.count + 19
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let searchTarget = self.searchTargets[0]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdvancedSearchViewController.cellReuseID,
                                                      for: indexPath)
        (cell as? SearchTargetUpdatable)?.update(searchTarget: searchTarget, query: self.searchBar.text)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.usableWidth(), height: 60.0)
    }
}
