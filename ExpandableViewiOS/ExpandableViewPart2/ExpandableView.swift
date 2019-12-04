//
//  ViewController.swift
//  ExpandableViewiOSPart2
//
//  Created by Manish Singh on 11/20/19.
//  Copyright © 2019 ManishSingh. All rights reserved.
//

import UIKit

class ExpandableView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var firstView: UIView!
    @IBOutlet var secondView: UIView!
    @IBOutlet var mainHeightConstraint: NSLayoutConstraint!
    @IBOutlet var showMoreButton: UIButton!

    private var shouldCollapse = false
    var superViewCompletion: (() -> Void)?

    var buttonTitle: String {
        return shouldCollapse ? "Show Less" : "Show More"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        Bundle.main.loadNibNamed(String(describing: ExpandableView.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin]
    }

    override func awakeFromNib() {
        showMoreButton.addTarget(self, action: #selector(didButtonTap), for: .touchUpInside)
    }

    @objc
    func didButtonTap() {
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

        UIView.animate(withDuration: 0.5) {
            self.shouldCollapse = isCollapse
            self.mainHeightConstraint.constant = CGFloat(heighConstraint)
            self.showMoreButton.setTitle(self.buttonTitle, for: .normal)
            self.layoutIfNeeded()
            self.superViewCompletion?()
        }
    }
}
