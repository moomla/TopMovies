//
//  ItemSmallViewCell.swift
//  TopMovies
//
//  Created by Dina Vaingolts on 10/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit
import Kingfisher

class ItemSmallViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var dataSource: SmallViewPresentable? {
        didSet{
            updateView()
        }
    }
    
    func updateView(){
        
        if let path = dataSource?.getImageIconUrl() {
            let url = URL(string: DataProvider.shared.imageUrl(path:path))
            self.posterView.kf.setImage(with: url)
        }
        
        titleLabel.text = dataSource?.getTitle()
        if let subtitle = dataSource?.getSubtitle(){
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = false
        } else {
            subtitleLabel.text = nil
            subtitleLabel.isHidden = true
        }
    }
    
}
