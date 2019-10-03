//
//  SearchTargetCollectionViewCell.swift
//  Kelpie
//
//  Created by Elliott Kipper on 9/22/19.
//  Copyright © 2019 Kip. All rights reserved.
//

import UIKit

class SearchTargetCollectionViewCell: UICollectionViewCell, SearchTargetUpdatable {

    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var mainContainer: UIView!
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.roundCorners()
    }
    
    // MARK: - SearchTargetUpdatable
    func update(searchTarget: SearchTarget, query: String?) {
        self.labelTitle.text = searchTarget.name
        self.labelDescription.text = "Search \(searchTarget.name)"
        if let query = query, !query.isEmpty {
            self.labelDescription.text? += " for \(query)"
        }
        if let colorString = searchTarget.colorHex {
            self.imageView.backgroundColor = UIColor(hex: colorString)
        } else {
            self.imageView.backgroundColor = UIColor.kelpieAccent
        }
        self.imageView.shadowColor = self.imageView.backgroundColor
    }
}
