//
//  Case11ViewController.swift
//  ConcurrencySample
//
//  Created by RLS77777777 on 2021/09/26.
//

import UIKit

class Case11ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var executionButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    private var task: Task<(), Never>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func executionAction(_ sender: Any) {
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
        // isCancelledのフラグを立てるだけ
        // キャンセル処理は呼び出しメソッド側で行う
        // Case12にて実装
        task?.cancel()
        task = nil
    }
}

// MARK: downloadData メソッド
extension Case11ViewController {
    private func downloadDataAfter(from url: URL) async throws -> Data {
        /// 多分1秒遅延
        await Task.sleep(10 * 1000 * 1000 * 1000)
        return self.parseJson(from: "{\"id\":2, \"name\":\"Yamamoto\"}")!
    }
}
