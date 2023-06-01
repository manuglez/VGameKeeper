//
//  DiscoverCollectionViewCell.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 09/05/23.
//

import UIKit

enum ImageRenderSize {
    case thumbnail
    case xsmall
    case small
    case medium
    case big
}

class DiscoverCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "gameCell"
    var featuredGame: FeaturedGame? {
        didSet {
            refreshData(renderingSize: currentImageSize)
        }
    }
    
    var currentImageSize: ImageRenderSize = .small
    var gameImageView: UIImageView?
    var gameLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let imageView = viewWithTag(1) as? UIImageView else {
            return
        }
        
        gameImageView = imageView
        
        guard let cellLabel = viewWithTag(2) as? UILabel else {
           
            return
        }
        
        gameLabel = cellLabel
        //refreshData(renderingSize: .small)
    }
    
    func refreshData(renderingSize: ImageRenderSize){
        gameImageView?.image = nil
        gameLabel?.isHidden = false
        
        guard featuredGame?.imageUrl != "" else {
            gameLabel?.text = featuredGame?.name ?? "NO NAME"
            return
        }
        
        var urlStringW = featuredGame?.smallSizeUrl()
        switch renderingSize {
        case .thumbnail:
            urlStringW = featuredGame?.thumbnailUrl()
        case .xsmall:
            urlStringW = featuredGame?.xsmallSizeUrl()
        case .small:
            urlStringW = featuredGame?.smallSizeUrl()
        case .medium:
            urlStringW = featuredGame?.mediumSizeUrl()
        case .big:
            urlStringW = featuredGame?.bigSizeUrl()
        }
        
        if let urlString = urlStringW,
           let url = URL(string: urlString){
            gameLabel?.isHidden = true
            gameImageView?.fetch(fromURL: url)
        } else {
            gameLabel?.text = featuredGame?.name ?? "NO NAME"
        }
    }
}
