//
//  AnotherViewController.swift
//  navigation-transition
//
//  Created by Sinan Eren on 3/13/17.
//  Copyright © 2017 Intrepid Pursuits. All rights reserved.
//

import UIKit

final class AnotherViewController: UIViewController {

    @IBAction private func nextButtonTapped(_ sender: UIButton) {
        navigationController?.pushViewController(ViewController(), animated: true)
    }
}
