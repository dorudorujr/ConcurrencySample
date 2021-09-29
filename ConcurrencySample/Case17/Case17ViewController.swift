//
//  Case17ViewController.swift
//  ConcurrencySample
//
//  Created by RLS77777777 on 2021/09/29.
//

import UIKit

class Case17ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = " (actor): 共有された状態の変更（複数インスタンスの連携）"
        let counter: Counter = .init()
        Task {
            _ = await counter.transferCount(to: Counter())
        }
    }
}

extension Case17ViewController {
    actor Counter {
        var count: Int = 0

        func increment() -> Int {
            count += 1
            return count
        }

        func decrement() -> Int {
            count -= 1
            return count
        }

        func transferCount(to another: Counter) async {
            _ = self.decrement()
            // 自分のdecrementメソッドは同期的に呼び出すことはできますが
            // anotherのincrementメソッドは同期的に呼び出すことはできない
            _ = await another.increment()
        }
    }
}
