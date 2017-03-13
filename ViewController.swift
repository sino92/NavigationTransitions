//
//  ViewController.swift
//  navigation-transition
//
//  Created by Sinan Eren on 3/12/17.
//  Copyright © 2017 Intrepid Pursuits. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    private let color = UIColor(
        red: CGFloat(Float(arc4random()) / Float(UINT32_MAX)),
        green: CGFloat(Float(arc4random()) / Float(UINT32_MAX)),
        blue: CGFloat(Float(arc4random()) / Float(UINT32_MAX)),
        alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color
    }

    @IBAction private func nextButtonTapped(_ sender: UIButton) {
        navigationController?.pushViewController(AnotherViewController(), animated: true)
    }

    @IBAction private func sameViewButtonTapped(_ sender: UIButton) {
        navigationController?.pushViewController(ViewController(), animated: true)
    }
}
