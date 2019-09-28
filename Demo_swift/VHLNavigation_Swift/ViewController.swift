//
//  ViewController.swift
//  VHLNavigation_Swift
//
//  Created by Vincent on 2019/9/28.
//  Copyright © 2019 Darnel Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let button = UIButton(frame: CGRect(x: 100, y: 60 + 64, width: 150, height: 30))
        button.setTitle("微信样式", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        self.view.addSubview(button)
        
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func buttonClick() {
        let fakeVC = FakeViewController()
        self.navigationController?.pushViewController(fakeVC, animated: true)
    }
}

