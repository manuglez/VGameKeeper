//
//  UserRegisterViewController.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 18/05/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class UserRegisterViewController: UIViewController {

    @IBOutlet weak var textViewName: UITextField!
    @IBOutlet weak var textViewEmail: UITextField!
    @IBOutlet weak var textViewPassword: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    
    var isLogin = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if isLogin {
            textViewName.removeFromSuperview()
            buttonLogin.titleLabel?.text = "Iniciar Sesión"
        }
    }
    

    @IBAction func buttonRegisterPressed(_ sender: Any) {
        if isLogin {
            loginUser()
        } else {
            registerUser()
        }
    }
    
    func registerUser() {
        let db = Firestore.firestore()
        
        Auth.auth().createUser(withEmail: textViewEmail.text!, password: textViewPassword.text!){ authResult, error in
            guard let user = authResult?.user, error == nil else {
                self.showSimpleAlert(title: "Registration Error", message: error!.localizedDescription)
                return
              }
            
            print("\(user.email!) created")
            
            let userData = [
                "nombre": self.textViewName.text!,
                "email": user.email!,
                "authid": user.uid
            ]
            db.collection("usuarios").document(user.uid).setData(userData, merge: true) {
                err in
                    if let err = err {
                        print("Error adding document: \(err)")
                        self.showSimpleAlert(title: "Registration Error 2", message: err.localizedDescription)
                    } else {
                        print("Document added with ID: \(user.uid)")
                        self.dismiss(animated: true)
                    }
            }

           
            
        }
    }
    
    func loginUser() {
        let db = Firestore.firestore()
        Auth.auth().signIn(withEmail: textViewEmail.text!, password: textViewPassword.text!){ authResult, error in
            guard let user = authResult?.user, error == nil else {
                self.showSimpleAlert(title: "Registration Error", message: error!.localizedDescription)
                return
              }
            
            print("\(user.email!) logged in!!!")
            
            self.dismiss(animated: true)
        }
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
