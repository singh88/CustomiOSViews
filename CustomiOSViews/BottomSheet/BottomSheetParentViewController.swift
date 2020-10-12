//
//  BottomSheetParentViewController.swift
//  ExpandableViewiOS
//
//  Created by Manish Singh on 10/6/20.
//  Copyright © 2020 Manish Singh. All rights reserved.
//

import UIKit

class BottomSheetParentViewController: UIViewController {
    private let transitionDelegate = CustomTransitionDelegate()

    convenience init() {
        self.init(nibName: "\(BottomSheetParentViewController.self)", bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func showByAddingBottomSheetVCViews(_ sender: UIButton) {
        let bottomSheetVC = children.first { $0 is BottomSheetVC }

        if bottomSheetVC == nil {
            showBottomSheetViewController(self)
        }
    }

    @IBAction func showUsingPresentationController(_ sender: UIButton) {
        let bc = ModalPresentableVC()
        bc.modalPresentationStyle = .custom
        bc.transitioningDelegate = transitionDelegate
        present(bc, animated: true, completion: nil)
    }

    func showBottomSheetViewController(_ onParentViewController: UIViewController) {
        let bottomSheetVC = BottomSheetVC()
        
        onParentViewController.addChild(bottomSheetVC)
        onParentViewController.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: onParentViewController)

        let width  = onParentViewController.view.frame.width

        let fittingSize = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)

        let targetHeight = onParentViewController.view.systemLayoutSizeFitting(
            fittingSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        ).height

        // fixed, other solution could be to determine the minimum fitting size.
        let mainHeight: CGFloat = 300
        let mainWidth: CGFloat

        mainWidth = UIDevice.current.userInterfaceIdiom == .pad ? 400 : width

        let yPosition = onParentViewController.view.frame.height-mainHeight
        let xPosition = onParentViewController.view.frame.midX-mainWidth/2

        bottomSheetVC.view.frame = CGRect(x: xPosition, y: yPosition,
        width: mainWidth, height: mainHeight)
    }
}

class BottomSheetVC: UIViewController {
    override func loadView() {
        super.loadView()
        addGestureRecognizer()
        addUIComponent()
    }

    private func addGestureRecognizer() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(panGesture))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }

    @objc func panGesture(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            switch recognizer.direction {
            case .down:
                updateSearchView(.down)
            default:
                break
            }
        }
    }

    private func addUIComponent() {
        let contentView = UIView()
        contentView.backgroundColor = .yellow
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.accessibilityIdentifier = "Content View"

        view.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
        ])

        let dismissIndicatorView = UIView()
        dismissIndicatorView.layer.cornerRadius = 3
        dismissIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        dismissIndicatorView.backgroundColor = .gray
        contentView.addSubview(dismissIndicatorView)

        NSLayoutConstraint.activate([
            dismissIndicatorView.widthAnchor.constraint(equalToConstant: 35),
            dismissIndicatorView.heightAnchor.constraint(equalToConstant: 6),
            dismissIndicatorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            dismissIndicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])

        let button = UIButton(type: .roundedRect)

        button.backgroundColor = .white
        button.layer.cornerRadius = 10

        button.setTitle("Tap to open", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(button)

        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 50),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }

    @objc func buttonTapped() {
        print("Button tapped")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    fileprivate func updateSearchView(_ direction: UISwipeGestureRecognizer.Direction) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self,
                let superViewFrame = self.view.superview?.frame else {return}

            var newYPosition: CGFloat = superViewFrame.midY

            switch direction {
            case .down:
                newYPosition = superViewFrame.maxY
                self.removeFromParent()
            default:
                break
            }

            let frame = self.view.frame
            let newXPosition = superViewFrame.midX - frame.width/2
            self.view.frame = CGRect(x: newXPosition, y: newYPosition, width: frame.width, height: frame.height)
        }
    }
}


