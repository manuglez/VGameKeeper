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
    
    var discoverViewModel: DiscoverViewModel! = nil
    var selectedGame: FeaturedGame?
    
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var collectionView: UICollectionView!
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        discoverViewModel = DiscoverViewModel(gameQueries: IGDBGameQuery.shared)
        tableView.register(UINib(nibName: "HorizontalGridGameCell", bundle: nil), forCellReuseIdentifier: HorizontalGridGameCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        reloadData()
    }
    
    func reloadData(includeFlags: Bool = false) {
        discoverViewModel.fetchDiscoveries { [weak self] in
            print("Discoveries fetched")
            
            if includeFlags {
                let itemsCount = self?.discoverViewModel.discoveries.count ?? 0
                if itemsCount > 0 {
                    for i in 0...itemsCount-1 {
                        self?.discoverViewModel.discoveries[i].reloadPending = true
                    }
                }
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let notifCenter = NotificationCenter.default
        
        notifCenter.addObserver(self, selector: #selector(sessionTokenUpdated), name: NSNotification.Name(IGDBManager.SESSION_UPDATE_NOTIFICATION), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let notifCenter = NotificationCenter.default
        notifCenter.removeObserver(self, name: NSNotification.Name(IGDBManager.SESSION_UPDATE_NOTIFICATION), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueGameDetail" {
            let gameVC = segue.destination as! GameDetailViewController
            gameVC.gameInfo = selectedGame
        }
    }
    
    @objc func sessionTokenUpdated(_ notification: Notification) {
        reloadData(includeFlags: true)
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
        if let tableCell = tableView.dequeueReusableCell(withIdentifier: HorizontalGridGameCell.reuseIdentifier, for: indexPath) as? HorizontalGridGameCell {
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if discoverViewModel.discoveries[indexPath.section].reloadPending {
            if let discoveryCell = cell as? HorizontalGridGameCell {
                discoveryCell.collectionView.reloadData()
            }
            discoverViewModel.discoveries[indexPath.section].reloadPending = false
        }
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
}
