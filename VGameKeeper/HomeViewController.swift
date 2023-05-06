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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("ℹ ViewController didLoad()")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //DispatchQueue.q
        Task {
        //    await concurrencyTest()
        }
        
    }

    @IBAction func barButtonSearchPressed(_ sender: Any) {
        print("barButtonSearchPressed")
    }
    
}

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
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath)
        
        guard let imageView = cell.viewWithTag(1) as? UIImageView else {
            return UICollectionViewCell()
        }
        
        imageView.image = UIImage(named: imagesArray[indexPath.row])
        
        return cell
    }
    
    
}

