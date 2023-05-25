//
//  SettingsViewController.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 19/05/23.
//

import UIKit
import FirebaseAuth

class SettingsTableViewController: UITableViewController {
    var authHandler: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authHandler = Auth.auth().addStateDidChangeListener { auth, user in
            // ...
            print("stateChange \(user?.email ?? "NO EMAIL")")
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    @IBAction func buttonLogoutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            //tableView.reloadData()
        } catch let err as NSError {
            print("Error signing out \(err)")
            showSimpleAlert(title: "Signout error", message: "Error signing out \(err)")
        }
        
        
    }
    
    @objc func registerPressed(_ sender: UIButton){
        performSegue(withIdentifier: "segueRegister", sender: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let _ = Auth.auth().currentUser {
            let cell = tableView.dequeueReusableCell(withIdentifier: "signoutCell", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "signinCell", for: indexPath)
            let registerButton: UIButton = cell.viewWithTag(2) as! UIButton
            registerButton.addTarget(self, action: #selector(registerPressed), for: .touchUpInside)
            
            let loginButton: UIButton = cell.viewWithTag(1) as! UIButton
            loginButton.addTarget(self, action: #selector(registerPressed), for: .touchUpInside)
            
            return cell
        }
        //return super.tableView(tableView, cellForRowAt: indexPath)
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    

}
