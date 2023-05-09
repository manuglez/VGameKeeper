//
//  UIImageView+ImageFetch.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 08/05/23.
//

import Foundation
import UIKit

enum FetchError:Error{
    case endpoint
    case imageData
    
}

extension UIImageView {
    func fetch(fromURL url: URL) {
        Task {
            let uiimage = try await asyncDonwload(fromURL:url)
            DispatchQueue.main.async {
                self.image = uiimage
            }
        }
    }
    
    private func asyncDonwload(fromURL url: URL) async throws -> UIImage{
        let request = URLRequest.init(url:url)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print("Error fetching image: \(url.absoluteString)")
            throw FetchError.endpoint
        }
        guard let uiimage = UIImage(data: data) else {
            print("Error parsing image: \(url.absoluteString)")
            throw FetchError.imageData
        }
         
        
        return uiimage
    }
}
