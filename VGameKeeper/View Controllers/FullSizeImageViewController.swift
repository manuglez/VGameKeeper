//
//  FullSizeImageViewController.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 07/06/23.
//

import UIKit

class FullSizeImageViewController: UIViewController {

  @IBOutlet weak var mainImageView: UIImageView!
   @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    enum GameImageType {
        case thumbnail
        case screenshot
        case cover
    }
    
    static let storyboardID = "IndividualScreenshot"
    //private var screenshotImageView: UIImageView!
    //private var scrollView: UIScrollView!
    
    var imageStringUrl: String?
    var pageIndex: Int = 0
    
    var imageType: GameImageType = .screenshot
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let templateStringUrl = imageStringUrl{
            var stringUrl: String!
            
            switch imageType{
            case .thumbnail:
                stringUrl = IGDBUtilities.thumbnailUrl(templateStringUrl)
            case .screenshot:
                stringUrl = IGDBUtilities.bigScrenshotSizeUrl(templateStringUrl)
            case .cover :
                stringUrl = IGDBUtilities.bigCoverSizeUrl(templateStringUrl)
            }
            
            if let url = URL(string: stringUrl) {
                loadingIndicator.startAnimating()
                mainImageView.fetch(fromURL: url) {
                   self.loadingIndicator.stopAnimating()
                }
            }
        }
           
        
        scrollView.maximumZoomScale = 5.0
        scrollView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        scrollView.addGestureRecognizer(tapGesture)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    static func newInstance(imageUrlString: String, withIndex index: Int = 0) -> FullSizeImageViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: storyboardID) as! FullSizeImageViewController
        vc.imageStringUrl = imageUrlString
        vc.pageIndex = index
        return vc
    }
    
    @objc func didTap(){
        print("Tap Gesture")
        let isHidden = self.navigationController?.isNavigationBarHidden ?? true
        self.navigationController?.isNavigationBarHidden = !isHidden
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hidesBottomBarWhenPushed = false
        self.navigationController?.isNavigationBarHidden = false
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

extension FullSizeImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mainImageView
    }
    
}
