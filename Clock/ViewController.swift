//
//  ViewController.swift
//  Clock
//
//  Created by yubin.zhu on 2019/11/8.
//  Copyright © 2019 ford. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var timer: Timer?
    lazy var clockView: ClockView = {
        let clock = ClockView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.width))
        clock.center = view.center
        return clock
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(clockView)
    }
}
