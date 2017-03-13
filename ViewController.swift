//
//  ViewController.swift
//  navigation-transition
//
//  Created by Sinan Eren on 3/12/17.
//  Copyright © 2017 Intrepid Pursuits. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let color = UIColor(
        red: CGFloat(Float(arc4random()) / Float(UINT32_MAX)),
        green: CGFloat(Float(arc4random()) / Float(UINT32_MAX)),
        blue: CGFloat(Float(arc4random()) / Float(UINT32_MAX)),
        alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color
    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        navigationController?.pushViewController(ViewController(), animated: true)
    }
}
