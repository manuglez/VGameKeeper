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
    
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailTableView.dataSource = self
        detailTableView.delegate = self
        
        detailTableView.register(UINib(nibName: "TextSetCell", bundle: nil), forCellReuseIdentifier: TextSetCell.identifier)
        
       if let game = self.gameInfo {
            gameViewModel.fetchGameFullInfo(
                gameID: game.dbIdentifier) {
                   self.updateData()
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueScreenshots" {
            let nextVC = segue.destination as! ScreenshotsViewController
            
            if let indexpath = selectedIndexPath {
                let viewModelItem = gameViewModel.viewItems[indexpath.row]
                nextVC.screenshotsUrlList = viewModelItem.textArray
            }
            
        }
    }
    
    @IBAction func buttonAddToWishlistPressed(_ sender: Any) {
        addGameToCollection(collectionCategory: 2)
    }
    
    @IBAction func buttonRemoveFromCollectionPressed(_ sender: Any) {
        gameViewModel.removeGameFromCollection(game: gameInfo!) {
            AppDefaultsWrapper.shared.collectionsReload = true
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
                    
                    self.addGameToCollection(collectionCategory: selectedIndex)
                }
            }
    }
    
    func addGameToCollection(collectionCategory: Int){
        guard let game = self.gameInfo else {
            return
        }
        
        let gameCollection = GameCollectionModel(
            index: collectionCategory,
            name: GameCollectionViewModel.getDefaultCollection[collectionCategory]
        )
        self.gameViewModel.addGameToCollection(game: game, gameCollection: gameCollection){
            AppDefaultsWrapper.shared.collectionsReload = true
            self.detailTableView.reloadData()
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
        return gameViewModel.viewItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModelItem = gameViewModel.viewItems[indexPath.row]
        
        switch viewModelItem.itemType {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: GameDetailHeaderCell.identifier, for: indexPath) as! GameDetailHeaderCell
            cell.itemModel = viewModelItem
            return cell
        case .textValue:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellIdentifier")
            var content = cell.defaultContentConfiguration()
            content.text = viewModelItem.mainText?.0
            content.textProperties.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            content.secondaryText = viewModelItem.mainText?.1
            content.secondaryTextProperties.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            cell.contentConfiguration = content
            return cell
        case .textField:
            let cell = tableView.dequeueReusableCell(withIdentifier: GameDetailTextCell.identifier, for: indexPath) as! GameDetailTextCell
            cell.labelString = viewModelItem.mainText?.0
            cell.valueString = viewModelItem.mainText?.1
            return cell
        case .multipleText:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextSetCell.identifier, for: indexPath) as! TextSetCell
            cell.titleString = viewModelItem.mainText?.0
            cell.textItems = viewModelItem.textSet
            return cell
        case .screenshots:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cellIdentifier")
            cell.accessoryType = .disclosureIndicator
            
            var content = cell.defaultContentConfiguration()
            content.text = viewModelItem.mainText?.0
            content.textProperties.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            content.secondaryTextProperties.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            cell.contentConfiguration = content
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
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return gameViewModel.viewItems[indexPath.row].highlight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModelItem = gameViewModel.viewItems[indexPath.row]
        if viewModelItem.itemType == .screenshots {
            selectedIndexPath = indexPath
            performSegue(withIdentifier: "segueScreenshots", sender: nil)
        }
    }
}
