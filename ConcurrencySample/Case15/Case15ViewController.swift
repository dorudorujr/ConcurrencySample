//
//  Case15ViewController.swift
//  ConcurrencySample
//
//  Created by RLS77777777 on 2021/09/29.
//

import UIKit

class Case15ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "(actor): 共有された状態の変更（インスタンス内でのメソッド呼び出し）"
    }
}

extension Case15ViewController {
    /// 競合状態を引き起こす実装
    final private class CounterBefore {
        private let queue: DispatchQueue = .init(label: "Before")
        private var count: Int = 0
        
        func increment(completion: @escaping (Int) -> Void) {
            queue.async { [self] in
                count += 1
                completion(count)
            }
        }
        
        /// incrementメソッドのオペレーションがバラバラにqueueに追加される。
        /// そのため、 2 回のインクリメントは一度に同期的に実行されるわけではなく、 2 回に分けて実行されます。
        /// すると、2 回のオペレーションの途中の状態が外部から観測されてしまう可能性があります。
        /// つまり途中でprintされちゃう？
        /// printされるのが2の倍数(2と4)だけとは限らなくなる
        /// 非同期に実行される
        ///  1 -> 2 -> 3 -> print -> 4 -> print？
        func incrementTwice(completion: @escaping (Int) -> Void) {
            increment { [self] _ in
                increment { count in
                    completion(count)
                }
            }
        }
    }
    
    private actor CounterAfter {
        private var count: Int = 0
        
        // 内部にキューを持ち、自動的にキューに追加され一つずつ順番に実行される
        // 必ず同時に一つしか実行されない
        func increment() -> Int {
            count += 1
            return count
        }
        
        /// actor のメソッドは外部からは async に見えましたが、インスタンス内部からはただの同期メソッドに見える
        func incrementTwice() -> Int {
            _ = increment()
            _ = increment()
            return count
        }
    }
}
