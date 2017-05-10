//
//  ExpressionEditorViewController.swift
//  FaceIt
//
//  Created by 夏语诚 on 2017/4/10.
//  Copyright © 2017年 Banana Inc. All rights reserved.
//

import UIKit

class ExpressionEditorViewController: UITableViewController, UITextFieldDelegate {
    
    var name: String {
        return nameTextField?.text ?? ""
    }
    
    private let eyeChoices = [FacialExpression.Eyes.open, .closed, .squinting]
    private let mouthChoices = [FacialExpression.Mouth.frown, .smirk, .neutral, .grin, .smile]
    
    var expression: FacialExpression {
        return FacialExpression(eyes: eyeChoices[eyeControl?.selectedSegmentIndex ?? 0], mouth: mouthChoices[mouthControl?.selectedSegmentIndex ?? 0])
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var eyeControl: UISegmentedControl!
    @IBOutlet weak var mouthControl: UISegmentedControl!
    
    @IBAction func updateFace() {
//        print("\(name) = \(expression)")
        faceViewController?.expression = expression
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
    
    private var faceViewController: BlinkingFaceViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Embed Face" {
            faceViewController = segue.destination as? BlinkingFaceViewController
            faceViewController?.expression = expression
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "Add Emotion", name.isEmpty {
            handleUnnamedFace()
            return false
        } else {
            return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        }
    }
    
    private func handleUnnamedFace() {
        let alert = UIAlertController(title: "Invalid Face", message: "A face must have a name.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.nameTextField?.text = alert.textFields?.first?.text
            self.performSegue(withIdentifier: "Add Emotion", sender: nil)
        }))
        alert.addTextField(configurationHandler: nil)
        present(alert, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let popoverPresentationController = navigationController?.popoverPresentationController {
            if popoverPresentationController.arrowDirection != .unknown {
                navigationItem.leftBarButtonItem = nil
            }
        }
        var size = tableView.minimumSize(forSection: 0)
        size.height -= tableView.heightForRow(at: IndexPath(row: 1, section: 0))
        size.height += size.width
        preferredContentSize = size
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return tableView.bounds.size.width
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UITableView
{
    func minimumSize(forSection section: Int) -> CGSize {
        var width: CGFloat = 0
        var height : CGFloat = 0
        for row in 0..<numberOfRows(inSection: section) {
            let indexPath = IndexPath(row: row, section: section)
            if let cell = cellForRow(at: indexPath) ?? dataSource?.tableView(self, cellForRowAt: indexPath) {
                let cellSize = cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
                width = max(width, cellSize.width)
                height += heightForRow(at: indexPath)
            }
        }
        return CGSize(width: width, height: height)
    }
    
    func heightForRow(at indexPath: IndexPath? = nil) -> CGFloat {
        if indexPath != nil, let height = delegate?.tableView?(self, heightForRowAt: indexPath!) {
            return height
        } else {
            return rowHeight
        }
    }
}
