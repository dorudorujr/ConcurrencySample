//
//  ViewController.swift
//  ConcurrencySample
//
//  Created by RLS77777777 on 2021/09/25.
//

import UIKit

class Case1ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        label.text = "非同期関数の利用（エラーハンドリングがない場合）"
        
        print("--------- Case1ViewController ---------")
        super.viewDidLoad()
        print("Before ready")
        downloadDataBefore(from: URL(string: "https://")!) { data in
            print(data)
        }
        
        Task {
            // print("After ready")とprint(data)が同じスレッドで実行される保証はない
            print("After ready")
            // downloadDataAfterを呼ぶ際にselfを必要としない理由
            // Task のイニシャライザでは
            // @_implicitSelfCapture という隠し属性を使って実現されているので
            // selfを暗黙的に strong キャプチャする
            // なぜselfを暗黙的にstrongキャプチャしても問題ないかというと
            // Task のイニシャライザに渡されるクロージャはリファレンスサイクルを作らないから
            // (通常のクロージャとは違い残り続けることはないから)
            // このクロージャは実行が完了すれば解放されるため
            // ここでキャプチャされた self がリファレンスサイクルを作り、メモリリークにつながる恐れはない
            let data = await downloadDataAfter(from: URL(string: "https://")!)
            print(data)
        }
    }
}

extension Case1ViewController {
    func downloadDataBefore(from url: URL, completion: @escaping (String) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion("Before Data")
        }
    }
    
    func downloadDataAfter(from url: URL) async -> String {
        /// 多分1秒遅延
        await Task.sleep(1 * 1000 * 1000 * 1000)
        return "After Data"
    }
}

