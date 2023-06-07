//
//  TextSetCell.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 06/06/23.
//

import UIKit

class TextSetCell: UITableViewCell, GameDetailCellDelegate {
    static var identifier: String = "TextSetCell"
    
    //static let identifier = "TextSetCell"
    @IBOutlet weak var vStack: UIStackView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var titleString: String? {
        didSet {
            titleLabel.text = titleString
        }
    }
    var textItems: Set<String>? {
        didSet {
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vStack.alignment = .leading
        vStack.distribution = .equalSpacing
        vStack.spacing = 4.0
        //vStack.backgroundColor = .systemBlue
        vStack.isBaselineRelativeArrangement = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateViews(){
        let subs = vStack.arrangedSubviews
        for s in subs {
            vStack.removeArrangedSubview(s)
            s.removeFromSuperview()
        }
        
        guard let items = textItems else {
            return
        }
        
        var position = 0
        var accumulatedWidth = 0.0
        
        var currentStack = addStack()
        for textElement in items {
            let button = newButton(title: textElement)
            let estimatedSize = button.sizeThatFits(.zero)
            
            //var currentStack = vStack.arrangedSubviews.last as! UIStackView
            //print("\(textElement)(\(estimatedSize.width) -> acc: \(accumulatedWidth) vstack: \(vStack.frame.size.width)")
            
            if accumulatedWidth + estimatedSize.width > vStack.frame.size.width {
                currentStack = addStack()
                accumulatedWidth = 0
            } else {
                accumulatedWidth += (estimatedSize.width + currentStack.spacing)
            }
            
            currentStack.addArrangedSubview(button)
            position += 1
        }
        setNeedsLayout()
    }
    
    private func newHStack() -> UIStackView {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .equalSpacing
        hStack.spacing = 6.0
        hStack.isBaselineRelativeArrangement = false
        //hStack.backgroundColor = .systemOrange
        hStack.contentMode = .scaleAspectFit
        return hStack
    }


    private func newButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        var conf = UIButton.Configuration.gray()
        //conf.gr
        conf.cornerStyle = .capsule
        conf.baseBackgroundColor = .secondarySystemBackground
        conf.baseForegroundColor = .secondaryLabel
        conf.title = title
       // conf.
        //conf.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)
        //conf.titlePadding = 6.0
        button.isUserInteractionEnabled = false
        button.configuration = conf
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        //button.titleLabel?.numberOfLines = 1
        return button
    }
    
    private func addStack() -> UIStackView{
        let hStack = newHStack()
        vStack.addArrangedSubview(hStack)
        return hStack
        //hStack.leadingAnchor.constraint(equalTo: vStack.leadingAnchor).isActive = true
        //hStack.trailingAnchor.constraint(greaterThanOrEqualTo: vStack.trailingAnchor).isActive = true

    }
    
}
