//
//  GameDetailHeaderCell.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 11/05/23.
//

import UIKit

class GameDetailHeaderCell: UITableViewCell {

    //var coverUrl, headerUrl, gameTitle: String?
    var itemModel: DetailModel? {
        didSet{
            refreshData()
        }
    }
    
    
    
    @IBOutlet weak var imageHeaderBg: UIImageView!
    @IBOutlet weak var imageGameCover: UIImageView!
    @IBOutlet weak var labelGameTitle: UILabel!
    
    @IBOutlet weak var gameCollectionContainer: UIView!
    @IBOutlet weak var gameCollactionIndicator: UIButton!
    @IBOutlet weak var gameCollectionRemoveButton: UIButton!
    
    @IBOutlet weak var buttonAddCollection: UIButton!
    @IBOutlet weak var buttonAddToWishlist: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //refreshData()
        gameCollectionContainer.isHidden = true
    }
    
    func refreshData() {
        if let urlString = itemModel?.secondaryText?.1,
        let url = URL(string: urlString){
            imageGameCover.backgroundColor = .clear
            imageGameCover.fetch(fromURL: url)
        } else {
            imageGameCover.backgroundColor = .lightGray
            imageGameCover.image = UIImage(systemName: "photo.on.rectangle.angled")
        }
        
        labelGameTitle.text = itemModel?.mainText?.1
        
        if let dataDictionary = itemModel?.dataDictionary{
            if let gameColletion = dataDictionary[DetailModel.DATA_HEADER_COLLECTION_KEY] as? GameCollectionModel{
                let uiimage = UIImage(systemName: COLLECTION_ICON_TITLES[gameColletion.index])
                var buttonConfig = UIButton.Configuration.filled()
                buttonConfig.baseBackgroundColor = .systemGreen
                buttonConfig.baseForegroundColor = .label
                buttonConfig.title = gameColletion.name
                buttonConfig.image = uiimage
                buttonConfig.imagePadding = 5.0
                buttonConfig.cornerStyle = .large
                buttonConfig.buttonSize = .medium
                gameCollactionIndicator.configuration = buttonConfig
                
                gameCollectionContainer.isHidden = false
                buttonAddToWishlist.isHidden = true
                
            } else {
                buttonAddToWishlist.isHidden = false
                gameCollectionContainer.isHidden = true
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func bnAddPressed(_ sender: Any) {
        print("bnAddPressed")
    }
    @IBAction func buttonCollectionRemovePressed(_ sender: Any) {
    }
}
