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
         //collectionFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let w = (UIScreen.main.bounds.width / 3.0) - 4.0
        //let w = collectionView.frame.size.width / 3
        collectionFlowLayout.itemSize = CGSize(width: w, height: (w * 9) / 16)
        collectionFlowLayout.minimumLineSpacing = 2
        collectionFlowLayout.minimumInteritemSpacing = 2
         collectionView.collectionViewLayout = collectionFlowLayout
        /*if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            print("flowlayout")
            layout.itemSize = CGSize(width: 100, height: 100)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            collectionView.collectionViewLayout = layout
        }*/
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
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
