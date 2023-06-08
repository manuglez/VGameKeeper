//
//  FullSizeImageViewController.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 07/06/23.
//

import UIKit

class FullSizeImageViewController: UIViewController {

  @IBOutlet weak var mainImageView: UIImageView!
   @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   @IBOutlet weak var scrollView: UIScrollView!
    
    
    //private var screenshotImageView: UIImageView!
    //private var scrollView: UIScrollView!
    
    var imageStringUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*screenshotImageView = UIImageView(
           /* frame: CGRect(
                x: 0.0, y: 0.0,
                width: view.bounds.width,
                height: view.bounds.height)*/)
        screenshotImageView.contentMode = .scaleAspectFit
        scrollView.addSubview(screenshotImageView)
        NSLayoutConstraint.activate([
            screenshotImageView.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor),
            screenshotImageView.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            screenshotImageView.leadingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            screenshotImageView.trailingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.trailingAnchor)
        ])*/
        
        // Do any additional setup after loading the view.
        if let stringUrl = imageStringUrl,
           let url = URL(string: IGDBUtilities.bigScrenshotSizeUrl(stringUrl)) {
            activityIndicator.startAnimating()
            mainImageView.fetch(fromURL: url) {
               self.activityIndicator.stopAnimating()
            }
        }
        
        scrollView.maximumZoomScale = 5.0
        scrollView.delegate = self
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hidesBottomBarWhenPushed = false
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
