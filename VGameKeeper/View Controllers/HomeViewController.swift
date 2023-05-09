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
    
    var discoverViewModel = DiscoverViewModel()
    
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
    
    /*func concurrencyTest() async {
        do {
            discoverViewModel = try await IGDBGameQuery.shared.recentReleases()
        } catch {
            print("🚨 IGDBGameQuery Error: \(error.localizedDescription)")
        }
    }*/

    @IBAction func barButtonSearchPressed(_ sender: Any) {
        print("barButtonSearchPressed")
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
           header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tableCell = tableView.dequeueReusableCell(withIdentifier: "discoverTableCell", for: indexPath) as? DiscoverTableViewCell {
            tableCell.viewModel = discoverViewModel.discoveries[indexPath.section]
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
/*
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellH = collectionView.frame.size.height
        let cellW = cellH / 1.3
        return CGSize(width: cellW, height: cellH)
    }
}


extension HomeViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if discoverViewModel.discoveries.count > 0 {
            return discoverViewModel.discoveries[0].gamesList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath)
        
        guard let imageView = cell.viewWithTag(1) as? UIImageView else {
            return UICollectionViewCell()
        }
        
        guard let cellLabel = cell.viewWithTag(2) as? UILabel else {
            return UICollectionViewCell()
        }
        
        //imageView.image = UIImage(named: imagesArray[indexPath.row])
        if let url = URL(string: discoverViewModel.discoveries[0].gamesList[indexPath.row].mediumSizeUrl()){
            cellLabel.isHidden = true
            imageView.fetch(fromURL: url)
        } else {
            cellLabel.text = discoverViewModel.discoveries[0].gamesList[indexPath.row].name
        }
       
        //
        
        return cell
    }
    
    
}

*/
