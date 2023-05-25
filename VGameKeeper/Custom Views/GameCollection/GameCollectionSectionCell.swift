//
//  GameCollectionSectionCell.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 18/05/23.
//

import UIKit

class GameCollectionSectionCell: UITableViewCell {
    var sectionTitle: String?
    
    @IBOutlet weak var labelSectionTitle: UILabel!
    @IBOutlet weak var imageAccessory: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        fillContents()
    }
    
    func fillContents() {
        labelSectionTitle.text = sectionTitle
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
