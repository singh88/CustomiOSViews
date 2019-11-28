//
//  ViewController.swift
//
//  Created by Manish Singh on 11/20/19.
//  Copyright © 2019 ManishSingh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var firstView: UIView!
    @IBOutlet var secondView: UIView!
    @IBOutlet var mainHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var showMoreButton: UIButton!

    private var shouldCollapse = false

    var buttonTitle: String {
        return shouldCollapse ? "Show Less" : "Show More"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        animateView(isCollapse: false, buttonText: buttonTitle, heighConstraint: 0)
    }

    @IBAction func buttonTap(_ sender: Any) {
        if shouldCollapse {
            animateView(isCollapse: false,
                        buttonText: buttonTitle,
                        heighConstraint: 0)
        } else {
            animateView(isCollapse: true,
                        buttonText: buttonTitle,
                        heighConstraint: 100)
        }
    }

    private func animateView(isCollapse: Bool,
                             buttonText: String,
                             heighConstraint: Double) {
        shouldCollapse = isCollapse
        mainHeightConstraint.constant = CGFloat(heighConstraint)
        showMoreButton.setTitle(buttonTitle, for: .normal)
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
    }
}
