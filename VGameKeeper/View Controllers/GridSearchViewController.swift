//
//  GridSearchViewController.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 11/05/23.
//

import UIKit

class GridSearchViewController: UIViewController {

    private let spacing:CGFloat = 10.0
    private var selectedGame: FeaturedGame?

    @IBOutlet weak var searchCollectionView: UICollectionView!
    private var searchBarController: UISearchController = {
           let sb = UISearchController()
           sb.searchBar.placeholder = "Search for a game"
           sb.searchBar.searchBarStyle = .minimal
           sb.showsSearchResultsController = true
           return sb
       }()
    
    var gameSearchViewModel = GameSearchViewModel()
    
    var goneToDetail: Bool = false
    
    //var searchController = UISearcha
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        searchCollectionView?.collectionViewLayout = layout
        
        /*if let _layout = searchCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let screenRect = view.window?.screen.bounds//UIScreen.ma
            let itemWidth = screenRect!.size.width / 4.0;
            let itemHeight = itemWidth / 1.3 ;
            _layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
       }*/

        searchBarController.delegate = self
        searchBarController.searchResultsUpdater = self
        searchBarController.searchBar.delegate = self
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchBarController

        definesPresentationContext = true
        
    }
    
  
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*Task {
            try await Task.sleep(nanoseconds: 10_000_000)
            DispatchQueue.main.async {
                self.searchBarController.searchBar.searchTextField.becomeFirstResponder()
            }
        }*/
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueGameDetail"{
            let vc = segue.destination as? GameDetailViewController
            vc?.gameInfo = selectedGame
            goneToDetail = true
        }
    }
    

    private func performSearch(text: String) {
        gameSearchViewModel.fetchSearch(query: text) {
            DispatchQueue.main.async {
                self.searchCollectionView.reloadData()
            }
        }
    }
}

extension GridSearchViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if goneToDetail {
            goneToDetail = false
            return
        }
        guard let searchString = searchController.searchBar.text else {
            return
        }
        if searchString.count >= 3 {
            performSearch(text: searchString)
        }
    }
    
}

extension GridSearchViewController: UISearchBarDelegate {
/*    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let searchView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "searchHeader", for: indexPath) as! GameSearchReusableView

        return searchView
    }*/
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard  let text = searchBar.text,
               !text.isEmpty  else {
            return
        }
        performSearch(text: text)
    }
}

extension GridSearchViewController: UISearchControllerDelegate{
    func didPresentSearchController(_ searchController: UISearchController) {
        print("didPresentSearchController")
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        print("willPresentSearchController")
    }
}

extension GridSearchViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       /* let cellH = collectionView.frame.size.width / 4
        let cellW = cellH / 1.3
        return CGSize(width: cellW, height: cellH)*/
        let numberOfItemsPerRow:CGFloat = 4
        let spacingBetweenCells:CGFloat = 16
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        if let collection = self.searchCollectionView{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            let height = width * 1.3
            return CGSize(width: width, height: height)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
}

extension GridSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameSearchViewModel.gamesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridSearchCell", for: indexPath) as? DiscoverCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.featuredGame = gameSearchViewModel.gamesList[indexPath.row]
        cell.refreshData(renderingSize: .small)
        
        /*let image = cell.viewWithTag(1) as! UIImageView
        
        image.image = UIImage(systemName: "photo.on.rectangle.angled")
        if let url = URL(string: gameSearchViewModel.gamesList[indexPath.row].smallSizeUrl()) {
            image.fetch(fromURL: url)
        }*/
        return cell
    }
    
    
}

extension GridSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedGame = gameSearchViewModel.gamesList[indexPath.row]
        self.performSegue(withIdentifier: "segueGameDetail", sender: self)
    }
}
