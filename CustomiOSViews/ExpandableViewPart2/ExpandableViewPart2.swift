//
//  ExpandableViewPart2.swift
//  ExpandableViewiOSPart2
//
//  Created by Manish Singh on 12/4/19.
//  Copyright © 2019 Manish Singh. All rights reserved.
//

import UIKit

class ExpandableViewPart2: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var firstView: ExpandableView!
    @IBOutlet weak var secondView: ExpandableView!
    @IBOutlet weak var thirdView: ExpandableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        firstView.superViewCompletion = {
            UIView.animate(withDuration: 0.5) {
                self.stackView.layoutSubviews()
            }
        }

        secondView.superViewCompletion = {
            UIView.animate(withDuration: 0.5) {
                self.stackView.layoutSubviews()
            }
        }

        thirdView.superViewCompletion = {
            UIView.animate(withDuration: 0.5) {
                self.stackView.layoutSubviews()
            }
        }
    }
}
