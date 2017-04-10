//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by 夏语诚 on 2017/3/15.
//  Copyright © 2017年 Banana Inc. All rights reserved.
//

import UIKit

class EmotionsViewController: /* VCLLoggingViewController */ UITableViewController, UISplitViewControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBAction func addEmotionalFace(from segue: UIStoryboardSegue) {
        if let editor = segue.source as? ExpressionEditorViewController {
            emotionalFaces.append((editor.name, editor.expression))
            tableView.reloadData()
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destinationViewController.
         // Pass the selected object to the new view controller.
        var destinationViewController = segue.destination
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        if let faceViewController = destinationViewController as? FaceViewController, /* let identifier = segue.identifier,
            let expression = emotionalFaces[identifier] */
            let cell = sender as? UITableViewCell, let indexpath = tableView.indexPath(for: cell) {
//            faceViewController.expression = expression
//            faceViewController.navigationItem.title = (sender as? UIButton)?.currentTitle
            faceViewController.expression = emotionalFaces[indexpath.row].expression
            faceViewController.navigationItem.title = emotionalFaces[indexpath.row].name
        } else if destinationViewController is ExpressionEditorViewController {
            if let popoverPresentationController = segue.destination.popoverPresentationController {
                popoverPresentationController.delegate = self
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emotionalFaces.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Emotion Cell", for: indexPath)
        cell.textLabel?.text = emotionalFaces[indexPath.row].name
        return cell
    }
    
//    private let emotionalFaces: Dictionary<String, FacialExpression> = [
//        "sad" : FacialExpression(eyes: .closed, mouth: .frown),
//        "happy" : FacialExpression(eyes: .open, mouth: .smile),
//        "worried" : FacialExpression(eyes: .open, mouth: .smirk)
//    ]

    private var emotionalFaces: [(name: String, expression: FacialExpression)] = [
        ("Sad", FacialExpression(eyes: .closed, mouth: .frown)),
        ("Happy", FacialExpression(eyes: .open, mouth: .smile)),
        ("Worried", FacialExpression(eyes: .open, mouth: .smirk))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitViewController?.delegate = self
    }

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if primaryViewController.contentViewController == self {
            if secondaryViewController.contentViewController is FaceViewController {
                return true
            }
        }
        return false
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        if traitCollection.verticalSizeClass == .compact {
            return .none
        } else if traitCollection.horizontalSizeClass == .compact {
            return .overFullScreen
        } else {
            return .none
        }
    }

}


extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}
