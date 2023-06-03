//
//  GameCollectionSectionCell.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 18/05/23.
//

import UIKit

class GameCollectionSectionCell: UITableViewCell {
    var sectionTitle: String? {
        didSet {
            labelSectionTitle.text = sectionTitle
        }
    }
    
    private var categoryIconName: String = ""
    
    var sectionCategory: Int? {
        didSet{
            guard let category = sectionCategory else{
                categoryIconName = ""
                categoryImage.image = nil
                return
            }
            
            if category < COLLECTION_ICON_TITLES.count {
                categoryIconName = COLLECTION_ICON_TITLES[category]
                categoryImage.image = UIImage(systemName: categoryIconName)
            }
        }
    }
    
    private let systemIconName_Open = "chevron.up"
    private let systemIconName_Closed = "chevron.down"
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var labelSectionTitle: UILabel!
    @IBOutlet weak var imageAccessory: UIImageView!
    
    var isOpen: Bool = true {
        didSet {
            let imageName = isOpen ? systemIconName_Open : systemIconName_Closed
            imageAccessory.image = UIImage(systemName: imageName)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
