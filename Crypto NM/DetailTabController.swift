//
//  DetailTabController.swift
//  Crypto NM
//
//  Created by Nikola Markovic on 4/28/18.
//  Copyright © 2018 Nikola Markovic. All rights reserved.
//

import UIKit

class DetailTabController: UITabBarController {

    weak var detailNavBar : DetailNavBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 {
            (self.viewControllers![0] as! DetailsVC).scrollViewDidScroll((self.viewControllers![0] as! DetailsVC).scrollV)
        } else {
            let hVC = self.viewControllers![1] as! HistoryVC
            if hVC.scrollV == nil {
                hVC.scrollViewDidScroll(UIScrollView.init())
                
            } else {
                hVC.scrollViewDidScroll(hVC.scrollV)
            }
        }
        UIView.animate(withDuration: 0.2) {
            self.detailNavBar.view.layoutIfNeeded()
        }
    }

}
