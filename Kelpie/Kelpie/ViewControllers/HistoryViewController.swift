//
//  HistoryViewController.swift
//  Kelpie
//
//  Created by Elliott Kipper on 3/13/20.
//  Copyright © 2020 Kip. All rights reserved.
//

import RealmSwift
import UIKit

class HistoryViewController: KelpieViewController, UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {
    
    // MARK: -
    private class var cellReuseID: String { return "searchHistory" }
    
    // MARK: - ivars
    private let searchHistories = SearchHistory.allSortedByDate()
    private var searchHistoriesNotificationToken: NotificationToken?

    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let cellNib = UINib(nibName: "SearchTargetCollectionViewCell", bundle: Bundle.main)
            self.collectionView.register(cellNib, forCellWithReuseIdentifier: HistoryViewController.cellReuseID)
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchHistoriesNotificationToken = self.searchHistories.observe(self.searchHistoriesDidChange(_:))
        // Do any additional setup after loading the view.
    }
    
    func searchHistoriesDidChange(_ change: RealmCollectionChange<Results<SearchHistory>>) {
        //@TODO
        self.collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchHistories.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryViewController.cellReuseID,
                                                      for: indexPath)
        if let searchHistoryUpdatable = cell as? SearchHistoryUpdatable {
            let history = self.searchHistories[indexPath.row]
            searchHistoryUpdatable.update(searchHistory: history)
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.searchHistories[indexPath.row].execute()
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.usableWidth(), height: 60.0)
    }

}
