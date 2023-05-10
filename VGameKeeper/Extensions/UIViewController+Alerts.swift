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
}
