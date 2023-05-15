//
//  GameDetailHeaderCell.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 11/05/23.
//

import UIKit

class GameDetailHeaderCell: UITableViewCell {

    //var coverUrl, headerUrl, gameTitle: String?
    var itemModel: DetailModel?
    
    @IBOutlet weak var imageHeaderBg: UIImageView!
    @IBOutlet weak var imageGameCover: UIImageView!
    @IBOutlet weak var labelGameTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        refreshData()
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func bnAddPressed(_ sender: Any) {
    }
}
