//
//  ScreenshotsPagesViewController.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 08/06/23.
//

import UIKit

class ScreenshotsPagesViewController: UIPageViewController {
    
    var imagesUrlList: [String]?
    var initialIndex: Int = 0
    
    private var pageViewControllers: [UIViewController]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        pageViewControllers = []
        
        var index = 0
        if let urlList = imagesUrlList {
            for urlString in urlList {
                pageViewControllers?.append(FullSizeImageViewController.newInstance(imageUrlString: urlString, withIndex: index))
                index += 1
            }
        }
        
        setViewControllers([pageViewControllers![initialIndex]], direction: .forward, animated: true) { finished in
            print("Page View Controlled finished: \(finished)")
        }
        
        delegate = self
        dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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

extension ScreenshotsPagesViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let screenshotVC = viewController as? FullSizeImageViewController {
            
            if screenshotVC.pageIndex > 0 {
                return pageViewControllers?[screenshotVC.pageIndex - 1]
            } else {
                return nil
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let screenshotVC = viewController as? FullSizeImageViewController {
            let pageCount = pageViewControllers?.count ?? 0
            if screenshotVC.pageIndex < pageCount - 1 {
                return pageViewControllers?[screenshotVC.pageIndex + 1]
            } else {
                return nil
            }
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageViewControllers?.count ?? 0
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        return initialIndex
    }
}

extension ScreenshotsPagesViewController: UIPageViewControllerDelegate {
   
}
