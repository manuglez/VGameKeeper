//
//  HorizontalGridGameCell.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 20/05/23.
//

import UIKit

protocol FeaturedGamesGridDelegate: AnyObject {
    func gameSelectedFromGrid(itemIndex: Int, featuredGame: FeaturedGame)
}

class HorizontalGridGameCell: UITableViewCell {
    static let reuseIdentifier = "HorizontalGridGameCell"
    static let defaultRowHeight = 170.0
    
    var discoverModel: DiscoverModel? {
        didSet{
            collectionView.reloadData()
        }
    }
    @IBOutlet weak var collectionView: DiscoverCollectionView!
    
    weak var featuredGameDelegate: FeaturedGamesGridDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "DiscoverCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: DiscoverCollectionViewCell.reuseIdentifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension HorizontalGridGameCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("collectionView didSelectItemAt \(indexPath.row)")
        
        if let featured = discoverModel?.gamesList[indexPath.row]{
            featuredGameDelegate?.gameSelectedFromGrid(itemIndex: indexPath.row, featuredGame: featured)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellH = collectionView.frame.size.height
        let cellW = cellH / 1.3
        return CGSize(width: cellW, height: cellH)
    }
}


extension HorizontalGridGameCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return discoverModel?.gamesList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverCollectionViewCell.reuseIdentifier, for: indexPath) as? DiscoverCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let featuredGame = discoverModel?.gamesList[indexPath.row] {
            cell.currentImageSize = .medium
            cell.featuredGame = featuredGame
        }

        return cell
    }
}
