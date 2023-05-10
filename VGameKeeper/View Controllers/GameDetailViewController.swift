//
//  GameDetailViewController.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 09/05/23.
//

import UIKit

class GameDetailViewController: UIViewController {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var labelGameTitle: UILabel!
    @IBOutlet weak var textViewSummary: UITextView!
    var gameInfo: FeaturedGame?
    
    let gameViewModel = GameDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let game = self.gameInfo {
            labelGameTitle.text = game.name
            if let url = URL(string: game.bigSizeUrl()){
                coverImage.fetch(fromURL: url)
            }
            gameViewModel.fetchGameFullInfo(
                gameID: game.dbIdentifier) {
                    DispatchQueue.main.async {
                        self.updateData()
                    }
                }
        }
        
    }
    
    
    func updateData() {
        textViewSummary.text = gameViewModel.gameInfo?.summary
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
