//
//  ViewController.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 04/05/23.
//

import UIKit

class HomeViewController: UIViewController {
    //let imagesArray = ["nintendo_switch", "PC", "ps5", "xbox_seriesx"]
    let imagesArray = ["assasinscreed", "lastofus_part1", "re4_remake", "tloz_totk"]
    
    let discoverViewModel = DiscoverViewModel()
    var selectedGame: FeaturedGame?
    
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var collectionView: UICollectionView!
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("ℹ ViewController didLoad()")
        tableView.delegate = self
        tableView.dataSource = self
        
        discoverViewModel.fetchDiscoveries {
            print("Discoveries fetched")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueGameDetail" {
            let gameVC = segue.destination as! GameDetailViewController
            gameVC.gameInfo = selectedGame
        }
    }
    
    /*func concurrencyTest() async {
        do {
            discoverViewModel = try await IGDBGameQuery.shared.recentReleases()
        } catch {
            print("🚨 IGDBGameQuery Error: \(error.localizedDescription)")
        }
    }*/

    @IBAction func barButtonSearchPressed(_ sender: Any) {
        print("barButtonSearchPressed")
        performSegue(withIdentifier: "segueGridSearch", sender: self)
    }
}

extension HomeViewController: FeaturedGamesGridDelegate {
    func gameSelectedFromGrid(itemIndex: Int, featuredGame: FeaturedGame) {
        selectedGame = featuredGame
        self.performSegue(withIdentifier: "segueGameDetail", sender: self)
        /*showSimpleAlert(
            title: "gameSelectedFromGrid",
            message: "Index: \(itemIndex) element ID: \(featuredGame.dbIdentifier) Game: \(featuredGame.name)")
         */
    }
    
    func gameSelectedFromGrid(itemIndex: Int, elemendId: Int) {
        
    }
    
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170.0
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return discoverViewModel.discoveries.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return discoverViewModel.discoveries[section].sectionName
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
           let header = view as! UITableViewHeaderFooterView
           //header.textLabel?.textColor = UIColor.label
        header.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tableCell = tableView.dequeueReusableCell(withIdentifier: "discoverTableCell", for: indexPath) as? DiscoverTableViewCell {
            tableCell.discoverModel = discoverViewModel.discoveries[indexPath.section]
            tableCell.featuredGameDelegate = self
            return tableCell
        }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "reusableCell")
        var content = cell.defaultContentConfiguration()
        content.text = "This cell is an Error"
        cell.contentConfiguration = content
        return cell
    }
    
    
}

extension HomeViewController: UITableViewDelegate {
    
}
