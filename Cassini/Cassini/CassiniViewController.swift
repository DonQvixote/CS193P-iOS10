//
//  CassiniViewController.swift
//  Cassini
//
//  Created by 夏语诚 on 2017/3/16.
//  Copyright © 2017年 Banana Inc. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController, UISplitViewControllerDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.splitViewController?.delegate = self
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let url = DemoURL.NASA[segue.identifier ?? ""] {
            if let imageVC = segue.destination.contentViewController as? ImageViewController {
                imageVC.imageURL = url
                imageVC.title = (sender as? UIButton)?.currentTitle
            }
        }
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if primaryViewController.contentViewController == self {
            if let ivc = secondaryViewController.contentViewController as? ImageViewController, ivc.imageURL == nil {
                return true
            }
        }
        return false
    }

}


extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        }
        else {
            return self
        }
    }
}
