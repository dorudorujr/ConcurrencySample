//
//  Case14ViewController.swift
//  ConcurrencySample
//
//  Created by RLS77777777 on 2021/09/29.
//

import UIKit

class Case14ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let counter: Counter = .init()
        
        // incrementメソッドは非同期的に実行されるため(キューで一つずつ実行されるため)
        // awaitが必要
        // Task.detached: メインスレッドで実行されないようにする？
        // メインスレッドだと必ずキュー的に処理されるので今回のケースを検証できない
        // 本来はdetachedを使うべきではない
        Task.detached {
            print(await counter.increment()) // 1 or 2
        }

        Task.detached {
            print(await counter.increment()) // 2 or 1
        }
    }
}

extension Case14ViewController {
    /// actorに継承という概念はない.....?
    private actor Counter {
        private var count: Int = 0
        
        // 内部にキューを持ち、自動的にキューに追加され一つずつ順番に実行される
        // 必ず同時に一つしか実行されない
        func increment() -> Int {
            count += 1
            return count
        }
    }
}
