//
//  Case2ViewController.swift
//  ConcurrencySample
//
//  Created by RLS77777777 on 2021/09/26.
//

import UIKit

class Case2ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "非同期関数の実装（エラーハンドリングがない場合）。Case1は利用でCase2は実装"
        
        fetchUserBefore(for: "") { user in
            print("Before User:\(user)")
        }
        
        Task {
            let user = await fetchUserAfter(for: "")
            print("After User:\(user)")
        }
    }
    
    func fetchUserBefore(for id: String, completion: @escaping (User) -> Void) {
        downloadDataBefore(from: URL(string: "https://")!) { data in
            let user = try! JSONDecoder().decode(User.self, from: data)
            completion(user)
        }
    }
    
    func fetchUserAfter(for id: String) async -> User {
        let data = await downloadDataAfter(from: URL(string: "https://")!)
        let user = try! JSONDecoder().decode(User.self, from: data)
        return user
    }
}

// MARK: downloadData メソッド
extension Case2ViewController {
    func downloadDataBefore(from url: URL, completion: @escaping (Data) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(self.parseJson(from: "{\"id\":1, \"name\":\"Suzuki\"}")!)
        }
    }
    
    func downloadDataAfter(from url: URL) async -> Data {
        /// 多分1秒遅延
        await Task.sleep(1 * 1000 * 1000 * 1000)
        return self.parseJson(from: "{\"id\":2, \"name\":\"Yamamoto\"}")!
    }
}
