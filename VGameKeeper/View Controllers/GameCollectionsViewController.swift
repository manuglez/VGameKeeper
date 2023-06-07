//
//  GameCollectionsViewController.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 17/05/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class GameCollectionsViewController: UIViewController {
    var authHandler: AuthStateDidChangeListenerHandle?
    
    var gameCollectionViewModel = GameCollectionViewModel()
    var selectedGame: FeaturedGame?

    var loadingView: UIView?
    var dataListener: ListenerRegistration?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noUserView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.bringSubviewToFront(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "HorizontalGridGameCell", bundle: nil), forCellReuseIdentifier: HorizontalGridGameCell.reuseIdentifier)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let moContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = Auth.auth().currentUser {
            print("WE HAVE AN USER")
        } else {
            print("NO USER")
        }
        
        authHandler = Auth.auth().addStateDidChangeListener { auth, user in
          // ...
            print("stateChange \(user?.email ?? "NO EMAIL")")
            if user == nil {
                self.view.bringSubviewToFront(self.noUserView)
            }else {
                self.view.bringSubviewToFront(self.tableView)
            }
        }
        
        Task {
            try await addDataChangeListener()
        }
    }
    
    func addDataChangeListener() async throws {
        let db = Firestore.firestore()
        let fserv = FirestoreService()
        
        dataListener = db.collection(Firestore_Colecctions.coleccion.rawValue)
            .whereField("usuario", isEqualTo: fserv.userReference)
            .addSnapshotListener({ querySnapshot, error in
                print("!!! Snapshot Event")
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                let listas = documents.map { $0["nombre"]! }
                print("Listas de usuario: \(listas)")
                    
            })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AppDefaultsWrapper.shared.collectionsReload {
            showLodingView()
            gameCollectionViewModel.fetchCollections {
                AppDefaultsWrapper.shared.collectionsReload = false
                self.removeLoadingView()
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(authHandler!)
        dataListener?.remove()
    }
    
    func showLodingView() {
        let screeBounds = UIScreen.main.bounds
        loadingView = UIView(frame: screeBounds)
        
        //loadingView?.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
        //let bgColor: UIColor =
        loadingView?.backgroundColor = .label.withAlphaComponent(0.4)
        let indicatorViewWidth = 100.0
        let indicatorViewHeight = 100.0
        let framex = screeBounds.size.width / 2 - indicatorViewWidth / 2
        let framey = screeBounds.size.height / 2 - indicatorViewHeight / 2
        
        let indicatorFrame = UIView(frame: CGRect(x: framex, y: framey, width: indicatorViewWidth, height: indicatorViewHeight))
        indicatorFrame.backgroundColor = .systemGray
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.tintColor = .systemBackground
        
        indicatorFrame.addSubview(indicator)
        indicator.center = CGPoint(x: indicatorFrame.frame.size.width/2, y: indicatorFrame.frame.size.height/2)
        
        loadingView?.addSubview(indicatorFrame)
        self.view.addSubview(loadingView!)
        indicator.startAnimating()
        self.view.bringSubviewToFront(loadingView!)
    }
    
    func removeLoadingView() {
        self.view.sendSubviewToBack(loadingView!)
        loadingView?.removeFromSuperview()
        loadingView = nil
        self.view.bringSubviewToFront(tableView)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueRegister"{
           
            guard let nextVC = segue.destination as? UserRegisterViewController else {
                return
            }
            
            var isLogin = true
            if let senderView = sender as? UIView {
                isLogin = senderView.tag == 1
            }
            
            nextVC.isLogin = isLogin
        } else if segue.identifier == "segueGameDetail" {
            let gameVC = segue.destination as! GameDetailViewController
            gameVC.gameInfo = selectedGame
        }
    }
    
    
    @IBAction func buttonLoginPressed(_ sender: UIView) {
        sender.tag = 1
        performSegue(withIdentifier: "segueRegister", sender: sender)
    }
    
    @IBAction func buttonRegisterPressed(_ sender: UIButton) {
        sender.tag = 2
        performSegue(withIdentifier: "segueRegister", sender: sender)
    }
}

// MARK: - Data Source
extension GameCollectionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameCollectionViewModel.gameLists.count * 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 1 {
            let itemIndex: Int = indexPath.row / 2
            let isOpen = gameCollectionViewModel.gameLists[itemIndex].isOpen
            return isOpen ? HorizontalGridGameCell.defaultRowHeight : 0.0
        }
        
        return UITableView.automaticDimension//(self as GameCollectionsViewController).superclass.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row % 2 == 0) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionSectionCell", for: indexPath) as? GameCollectionSectionCell else {
                return newSimpleCell(labelText: "NO CELL CONFIGURATION")
            }
            let itemIndex: Int = indexPath.row / 2
            let viewModelItem = gameCollectionViewModel.gameLists[itemIndex]
            cell.sectionTitle = viewModelItem.name.rawValue
            cell.sectionCategory = viewModelItem.category.rawValue
            cell.isOpen = viewModelItem.isOpen

            return cell
        } else {
            let itemIndex: Int = (indexPath.row / 2)
            let sectionName = gameCollectionViewModel.gameLists[itemIndex].name.rawValue
            let gameCollection = gameCollectionViewModel.gameLists[itemIndex].gameCollection
            //gameLists[itemIndex].gameCollection
            if gameCollection.count > 0 {
               
                if let tableCell = tableView.dequeueReusableCell(withIdentifier: HorizontalGridGameCell.reuseIdentifier, for: indexPath) as? HorizontalGridGameCell {
                    let viewModelWrap = DiscoverModel(
                        sectionName: sectionName,
                        gamesList: gameCollection)
                    tableCell.discoverModel = viewModelWrap
                    tableCell.featuredGameDelegate = self
                    return tableCell
                }
                
                let cell = UITableViewCell(style: .default, reuseIdentifier: "reusableCell")
                var content = cell.defaultContentConfiguration()
                content.text = "This cell is an Error"
                cell.contentConfiguration = content
                return cell
            } else {
                let title = "No se han agregado juegos a esta categoría"
                return newSimpleCell(labelText: title)
            }
        }
    }
    
    func newSimpleCell(labelText: String) -> UITableViewCell{
        let defCell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        var content = defCell.defaultContentConfiguration()
        content.text = labelText
        defCell.contentConfiguration = content
        return defCell
    }
}

extension GameCollectionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row % 2 == 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            let itemIndex: Int = indexPath.row / 2
            let isOpen = gameCollectionViewModel.gameLists[itemIndex].isOpen
            gameCollectionViewModel.gameLists[itemIndex].isOpen = !isOpen
            tableView.reloadData()
        }
    }
}

extension GameCollectionsViewController: FeaturedGamesGridDelegate {
    func gameSelectedFromGrid(itemIndex: Int, featuredGame: FeaturedGame) {
        selectedGame = featuredGame
        self.performSegue(withIdentifier: "segueGameDetail", sender: self)
    }
}
