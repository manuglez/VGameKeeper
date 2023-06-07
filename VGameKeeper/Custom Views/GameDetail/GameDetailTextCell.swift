//
//  GameDetailTextCell.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 11/05/23.
//

import UIKit

class GameDetailTextCell: UITableViewCell, GameDetailCellDelegate {
    static var identifier: String = "gameDetailTextCell"
    
    var labelString: String?{
        didSet {
            labelTitle.text = labelString
        }
    }
    var valueString: String? {
        didSet {
            labelDescription.text = valueString
        }
    }

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code        
    }
    
    
    func refreshData() {
        labelTitle.text = labelString
        labelDescription.text = valueString
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
