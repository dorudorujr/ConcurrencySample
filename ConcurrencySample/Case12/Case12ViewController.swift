//
//  Case12ViewController.swift
//  ConcurrencySample
//
//  Created by RLS77777777 on 2021/09/27.
//

import UIKit

class Case12ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    private var task: Task<(), Never>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "(Task.checkCancellation()): 非同期処理のキャンセル（非同期 API の実装側①）"
    }
    
    @IBAction func executionAction(_ sender: Any) {
        print("push executionAction")
        task = Task {
             do {
                 let data = try await downloadDataAfter(from: URL(string: "https://")!)
                 print("After execution:\(data)")
             } catch {
                 if Task.isCancelled {
                     print("After cancel")
                 } else {
                     print("After execution:\(error)")
                 }
             }
         }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        print("push cancelAction")
        task?.cancel()
        task = nil
    }
}

// MARK: downloadData メソッド
extension Case12ViewController {
    private func downloadDataAfter(from url: URL) async throws -> Data {
        /// 多分10秒遅延
        for _ in 0..<10 {
            //try Task.checkCancellation()// キャンセルのチェック & 処理の中断
            if Task.isCancelled {
                throw CancellationError()
            }
            await Task.sleep(1 * 1000 * 1000 * 1000)
        }
        return self.parseJson(from: "{\"id\":2, \"name\":\"Yamamoto\"}")!
    }
}
