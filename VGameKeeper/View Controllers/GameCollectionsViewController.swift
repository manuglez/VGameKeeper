//
//  GameCollectionsViewController.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 17/05/23.
//

import UIKit
import FirebaseAuth

class GameCollectionsViewController: UIViewController {
    var authHandler: AuthStateDidChangeListenerHandle?
    
    var gameCollectionViewModel = GameCollectionViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noUserView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.bringSubviewToFront(tableView)
        tableView.dataSource = self
        tableView.delegate = self
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(authHandler!)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row % 2 == 0) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionSectionCell", for: indexPath) as? GameCollectionSectionCell else {
                return newSimpleCell(labelText: "NO CELL CONFIGURATION")
            }
            let itemIndex: Int = indexPath.row / 2
            print("Section: \(gameCollectionViewModel.gameLists[itemIndex].name)")
            cell.sectionTitle = gameCollectionViewModel.gameLists[itemIndex].name
            cell.fillContents()
            return cell
        } else {
            return newSimpleCell(labelText: "No se han agregado juegos a esta categoría")
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
