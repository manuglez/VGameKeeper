//
//  ScreenshotsViewController.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 06/06/23.
//

import UIKit

class ScreenshotsViewController: UICollectionViewController {
    private let reuseIdentifier = "screenshotIdentifier"
    
    var screenshotsUrlList: [String]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var selecterUrlString: String?
    var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        // Set estimated cell size
        self.navigationItem.title = "Screenshots"
         let collectionFlowLayout = UICollectionViewFlowLayout()
        let w = (UIScreen.main.bounds.width / 3.0) - 4.0
        collectionFlowLayout.itemSize = CGSize(width: w, height: (w * 9) / 16)
        collectionFlowLayout.minimumLineSpacing = 2
        collectionFlowLayout.minimumInteritemSpacing = 2
         collectionView.collectionViewLayout = collectionFlowLayout
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.hidesBottomBarWhenPushed = false
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueFullImage" {
            if let nextVC = segue.destination as? FullSizeImageViewController {
                self.hidesBottomBarWhenPushed = true
                nextVC.imageStringUrl = selecterUrlString
            }
        } else if segue.identifier == "segueScreenshotsPageView" {
            if let nextVC = segue.destination as? ScreenshotsPagesViewController {
                self.hidesBottomBarWhenPushed = true
                nextVC.imagesUrlList = screenshotsUrlList
                nextVC.initialIndex = selectedIndex
            }
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshotsUrlList?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        if let imageView = cell.viewWithTag(1) as? UIImageView,
           let urlSting = screenshotsUrlList?[indexPath.row]{
           
            let imageUrl = URL(string: IGDBUtilities.mediumScrenshotSizeUrl(urlSting))
            if (imageUrl != nil) {
                imageView.fetch(fromURL: imageUrl!)
            }
            cell.contentView.clipsToBounds = true
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selecterUrlString = screenshotsUrlList?[indexPath.row]
        //performSegue(withIdentifier: "segueFullImage", sender: nil)
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "segueScreenshotsPageView", sender: nil)
    
    }
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
