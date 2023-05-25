//
//  UIViewController+Alerts.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 09/05/23.
//

import Foundation
import UIKit

extension UIViewController {
    func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { alertAction in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true)        
    }
    
    func showSheetAlert(title: String, message: String, buttonItems: [String], buttonHandler: @escaping (Int) -> Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for item in buttonItems {
            let itemAction = UIAlertAction(title: item, style: .default) { alertAction in
                let listIndex = buttonItems.firstIndex(of: alertAction.title!) ?? -1
                buttonHandler(listIndex)
            }
            
            alert.addAction(itemAction)
        }
        let action = UIAlertAction(title: "Cancelar", style: .cancel) { alertAction in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}
