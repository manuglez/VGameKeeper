//
//  GameDetailViewController.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 09/05/23.
//

import UIKit

class GameDetailViewController: UIViewController{
   
    var gameInfo: FeaturedGame?
    
    let gameViewModel = GameDetailViewModel()
    
    @IBOutlet weak var detailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailTableView.dataSource = self
        detailTableView.delegate = self
       if let game = self.gameInfo {
            gameViewModel.fetchGameFullInfo(
                gameID: game.dbIdentifier) {
                   self.updateData()
                }
        }
    }
    
    @IBAction func buttonAddToWishlistPressed(_ sender: Any) {
    }
    
    @IBAction func buttonRemoveFromCollectionPressed(_ sender: Any) {
        gameViewModel.removeGameFromCollection(game: gameInfo!) {
            self.updateData()
        }
    }
    
    @IBAction func buttonAddToListPressed(_ sender: Any) {
        var listaColecciones = GameCollectionViewModel.getDefaultCollection
        let collectionIndex = gameViewModel.getCollectionIndex()
        if collectionIndex != -1 {
            var collectionName = listaColecciones[collectionIndex]
            collectionName = "\u{2713} \(collectionName)"
            listaColecciones[collectionIndex] = collectionName
        }
        
        showSheetAlert(
            title: "Seleccione una colección a agregar el juego",
            message: "Colecciones disponibles:",
            buttonItems: listaColecciones) { selectedIndex in
                print("Selected Index: \(selectedIndex)")
                
                if selectedIndex != -1 {
                    guard let game = self.gameInfo else {
                        return
                    }
                    
                    let gameCollection = GameCollectionModel(
                        index: selectedIndex,
                        name: GameCollectionViewModel.getDefaultCollection[selectedIndex]
                    )
                    self.gameViewModel.addGameToCollection(game: game, gameCollection: gameCollection){
                        self.detailTableView.reloadData()
                    }
                }
            }
    }
    
    func updateData() {
        //textViewSummary.text = gameViewModel.gameInfo?.summary
        detailTableView.reloadData()
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

extension GameDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameViewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch gameViewModel.items[indexPath.row].itemType {
            
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: "gameDetailHeaderCell", for: indexPath) as! GameDetailHeaderCell
            cell.itemModel = gameViewModel.items[indexPath.row]
            return cell
        case .textValue:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellIdentifier")
            var content = cell.defaultContentConfiguration()
            content.text = gameViewModel.items[indexPath.row].mainText?.0
            content.textProperties.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            content.secondaryText = gameViewModel.items[indexPath.row].mainText?.1
            content.secondaryTextProperties.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            cell.contentConfiguration = content
            return cell
        case .textField:
            let cell = tableView.dequeueReusableCell(withIdentifier: "gameDetailTextCell", for: indexPath) as! GameDetailTextCell
            cell.itemModel = gameViewModel.items[indexPath.row]
            return cell
        default:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cellIdentifier")
            var content = cell.defaultContentConfiguration()
            content.text = "No Data"
            cell.contentConfiguration = content
            return cell
        /*case .horizontalGrid:
            break
        case .multipleText:
            break
        
            */
        }
        
    }
    
    
}

extension GameDetailViewController: UITableViewDelegate {
    
}
