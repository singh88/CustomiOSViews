//
//  ModalPresentableVC.swift
//  ExpandableViewiOS
//
//  Created by Manish Singh on 10/11/20.
//  Copyright © 2020 Manish Singh. All rights reserved.
//

import UIKit

class ModalPresentableVC: UIViewController {
    override func loadView() {
        super.loadView()
        configureView()
        addButton()
    }

    private func configureView() {
        view.backgroundColor = UIColor.gray
        view.layer.cornerRadius = 20
        view.layer.shadowRadius = 1
        view.layer.shadowColor = UIColor.systemBlue.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
    }

    private func addButton() {
        let contentView = UIView()
        contentView.backgroundColor = .yellow
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 200),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        contentView.topAnchor.constraint(equalTo: view.topAnchor).priority = .defaultLow
        let button = UIButton(type: .roundedRect)
        button.setTitle("Tap to open", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.backgroundColor = .green
        button.titleLabel?.textAlignment = .center
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(button)

        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 50),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            //button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    @objc func buttonTapped() {
        print("Button tapped")
    }
}
