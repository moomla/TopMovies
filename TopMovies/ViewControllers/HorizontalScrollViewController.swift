//
//  HrizontalScrollViewController.swift
//  TopMovies
//
//  Created by Dina Vaingolts on 10/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit
import Kingfisher

protocol SmallViewPresentable {
    func getId() -> String
    func getImageIconUrl() -> String?
    func getTitle() -> String
    func getSubtitle() -> String?
}


class HorizontalScrollViewController: UICollectionViewController {
    var dataSource: [SmallViewPresentable]? {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    var selectionBlock: ((SmallViewPresentable) ->Void )?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width/3, height: self.view.frame.size.height)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource?.count ?? 0
    }
        
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemSmallViewCell",
                                                      for: indexPath) as! ItemSmallViewCell
        cell.dataSource = dataSource![indexPath.row]
        return cell
    }
        
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let block = selectionBlock {
            let selected = dataSource![indexPath.row]
            block(selected)
        }
    }
}

