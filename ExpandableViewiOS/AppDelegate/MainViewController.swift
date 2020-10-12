//
//  MainViewController.swift
//  ExpandableViewiOS
//
//  Created by Manish Singh on 12/4/19.
//  Copyright © 2019 Manish Singh. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    weak var coordinator: AppCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func showExpandableViewPart1Tapped(_ sender: Any) {
        coordinator?.showExpandableViewPart1()
    }

    @IBAction func showExpandableViewPart2Tapped(_ sender: Any) {
        coordinator?.showExpandableViewPart2()
    }

    @IBAction func openBottomSheet(_ sender: Any) {
        coordinator?.showBottomSheetVC()
    }
}
