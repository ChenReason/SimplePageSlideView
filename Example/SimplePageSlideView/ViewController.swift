//
//  ViewController.swift
//  SimplePageSlideView
//
//  Created by chenreason on 08/27/2017.
//  Copyright (c) 2017 chenreason. All rights reserved.
//

import UIKit
import SimplePageSlideView
import SnapKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let v = SimplePageSlideView()
        v.dataSource = self
        v.frame = view.bounds
        view.addSubview(v)
    }
}

extension ViewController: SimplePageSlideViewDataSource {
    func itemView(in containerView: SimplePageSlideView, willMoveTo direction: Direction) -> UIView? {
        let v = UIView()
        v.snp.makeConstraints { (make) in
            make.height.equalTo(800)
        }
        v.backgroundColor = direction == .up ? UIColor.green : UIColor.yellow
        return v
    }
}
