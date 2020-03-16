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

class AdvancedSearchViewController: KelpieViewController {
    
    static let storyboardID = "AdvancedSearch"
    private static let cellReuseID = "searchTagetCell"
    static let didBecomeFirstResponder = Notification.Name(rawValue:
        "AdvancedSearchViewController.didBecomeFirstResponder")
    static let didResignFirstResponder = Notification.Name(rawValue:
    "AdvancedSearchViewController.didBecomeResignResponder")
    
    // MARK: - ivars
    private let searchTargets = SearchTarget.all().sorted(byKeyPath: "lastUsed", ascending: false)
    private var searchTargetsNotificationToken: NotificationToken?
    var initialSearchQuery: String?
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolbarView: UIView!
    
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
        self.prepareCollectionView()
        self.searchTargetsNotificationToken = self.searchTargets
            .observe { [weak self] changes in
                self?.searchTargetsChanged(changes)
        }
        self.searchBar.text = self.initialSearchQuery
        self.toolbarView.removeFromSuperview()
        self.searchBar.searchTextField.inputAccessoryView = self.toolbarView
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchBar.resignFirstResponder()
    }
    
    // MARK: -
    private func prepareCollectionView() {
        let cellNib = UINib(nibName: "SearchTargetCollectionViewCell", bundle: Bundle.main)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: AdvancedSearchViewController.cellReuseID)
    }
    
    // MARK: - Keyboard
    override func keyboardDidChange(event: KeyboardEvent) {
        switch event.type {
        case .willShow, .willHide, .willChangeFrame:
            let keyboardFrameEnd = event.keyboardFrameEnd
            let height = max(self.view.safeAreaInsets.bottom, self.view.bounds.size.height -
                keyboardFrameEnd.origin.y + self.view.safeAreaInsets.bottom + 20.0)
            self.collectionView.contentInset.bottom = height
            self.collectionView.verticalScrollIndicatorInsets.bottom = height - 20.0
        default:
            break
        }
    }
    
    @IBAction func clearTapped(_ sender: Any) {
        self.searchBar.text = nil
        self.searchBar(self.searchBar, textDidChange: "")
    }
    
    @IBAction func pasteTapped(_ sender: Any) {
        guard let pasteboardString = UIPasteboard.general.string else {
            return
        }
        self.searchBar.text = pasteboardString
        self.searchBar(self.searchBar, textDidChange: pasteboardString)
    }
    
    // MARK: - Realm
    private func searchTargetsChanged(_ changes: RealmCollectionChange<Results<SearchTarget>>) {
        guard self.isViewLoaded else { return }
        self.collectionView.reloadData()
    }
}

extension AdvancedSearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) { // called when text starts editing
        NotificationCenter.default.post(name: AdvancedSearchViewController.didBecomeFirstResponder, object: nil)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool { // return NO to not resign first responder
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) { // called when text ends editing
        NotificationCenter.default.post(name: AdvancedSearchViewController.didResignFirstResponder, object: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // called when text changes (including clear)
        SearchTarget.currentQuery = searchText.isEmpty ? nil : searchText
        self.collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { // called when keyboard search button pressed
        searchBar.resignFirstResponder()
    }
}

extension AdvancedSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchTargets.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let searchTarget = self.searchTargets[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdvancedSearchViewController.cellReuseID,
                                                      for: indexPath)
        (cell as? SearchTargetUpdatable)?.update(searchTarget: searchTarget, query: self.searchBar.text)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defer {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        guard let query = self.searchBar.text, !query.isEmpty else {
            self.searchBar.becomeFirstResponder()
            return
        }
        self.searchTargets[indexPath.row].executeSearch(query: query)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.usableWidth(), height: 60.0)
    }
}
