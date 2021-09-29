//
//  Case16ViewController.swift
//  ConcurrencySample
//
//  Created by RLS77777777 on 2021/09/29.
//

import UIKit

class Case16ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let counter: Counter = .init()
        
        Task.detached {
            print(await counter.count)
        }
    }
}

extension Case16ViewController {
    private actor Counter {
        private(set) var count: Int = 0
        
        func increment() -> Int {
            count += 1
            return count
        }
    }
}
