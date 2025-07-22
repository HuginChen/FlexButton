//
//  ViewController.swift
//  FlexButton
//
//  Created by mac on 07/22/2025.
//  Copyright (c) 2025 mac. All rights reserved.
//

import UIKit
import FlexButton

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "FlexButton Demo"
        view.backgroundColor = .systemBackground
        
        setupFlexButtonExample()
    }
    
    private func setupFlexButtonExample() {
        // 创建FlexButtonExample并添加到视图
        let exampleView = FlexButtonExample()
        view.addSubview(exampleView)
        
        // 设置约束让示例视图填满整个屏幕
        exampleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            exampleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            exampleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            exampleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            exampleView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

