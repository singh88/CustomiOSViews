//
//  AppCoordinator.swift
//  ExpandableViewiOS
//
//  Created by Manish Singh on 12/4/19.
//  Copyright © 2019 Manish Singh. All rights reserved.
//

import UIKit

class AppCoordinator {
    var navigationController: UINavigationController

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        guard let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "mainViewController") as? MainViewController else {
            return
        }

        mainViewController.coordinator = self
        navigationController.pushViewController(mainViewController, animated: true)
    }

    func showExpandableViewPart1() {
        guard let expandableViewPart1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "expandableViewPart1") as? ExpandableViewPart1 else {
            return
        }

        navigationController.pushViewController(expandableViewPart1, animated: true)
    }

    func showExpandableViewPart2() {
        guard let expandableViewPart2 = UIStoryboard(name: "ExpandableViewPart2", bundle: nil).instantiateInitialViewController() as? ExpandableViewPart2 else {
            return
        }

        navigationController.pushViewController(expandableViewPart2, animated: true)
    }
}
