//
//  DiscoverTableViewCell.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 09/05/23.
//

import UIKit

protocol FeaturedGamesGridDelegate: AnyObject {
    func gameSelectedFromGrid(itemIndex: Int, featuredGame: FeaturedGame)
}

class DiscoverTableViewCell: UITableViewCell {
    var discoverModel: DiscoverModel?
    @IBOutlet weak var collectionView: DiscoverCollectionView!
    
    weak var featuredGameDelegate: FeaturedGamesGridDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension DiscoverTableViewCell: UICollectionViewDelegateFlowLayout {
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


extension DiscoverTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return discoverModel?.gamesList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath)
        
        guard let imageView = cell.viewWithTag(1) as? UIImageView else {
            return UICollectionViewCell()
        }
        
        guard let cellLabel = cell.viewWithTag(2) as? UILabel else {
            return UICollectionViewCell()
        }
        
        //imageView.image = UIImage(named: imagesArray[indexPath.row])
        if let featuredGame = discoverModel?.gamesList[indexPath.row] {
            guard featuredGame.imageUrl != "" else {
                cellLabel.text = discoverModel?.gamesList[indexPath.row].name
                return cell
            }
            if let url = URL(string: featuredGame.mediumSizeUrl()){
                cellLabel.isHidden = true
                imageView.fetch(fromURL: url)
            } else {
                cellLabel.text = discoverModel?.gamesList[indexPath.row].name
            }
        }
        
        return cell
    }
}

