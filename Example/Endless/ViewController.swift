//
//  ViewController.swift
//  Endless
//
//  Created by self.dealloc@protonmail.com on 04/04/2019.
//  Copyright (c) 2019 self.dealloc@protonmail.com. All rights reserved.
//

import UIKit
import Endless

class ViewController: UIViewController {
    private var indicator: Endless.PageIndicator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = Endless.Configuration(numberOfPages: 5,
                                                  maxNumberOfPages: 10,
                                                  dotColor: .red)
        let indicator = Endless.PageIndicator(configuration: configuration)
        self.indicator = indicator
        view.addSubview(indicator)
        indicator.frame.origin = CGPoint(x: 50, y: 200)
    }
    @IBAction func increment(_ sender: Any) {
        guard let indicator = self.indicator else {
            return
        }
        
        indicator.selectedIndex = indicator.selectedIndex + 1
    }
    
    @IBAction func decrement(_ sender: Any) {
        guard let indicator = self.indicator else {
            return
        }
        
        indicator.selectedIndex = indicator.selectedIndex - 1
    }
}

