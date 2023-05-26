//
//  GameDetailTextCell.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 11/05/23.
//

import UIKit

class GameDetailTextCell: UITableViewCell {

    var itemModel: DetailModel?{
        didSet{
            refreshData()
        }
    }

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code        
    }
    
    
    func refreshData() {
        labelTitle.text = itemModel?.mainText?.0
        labelDescription.text = itemModel?.mainText?.1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
