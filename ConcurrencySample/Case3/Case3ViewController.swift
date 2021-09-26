//
//  Case3ViewController.swift
//  ConcurrencySample
//
//  Created by RLS77777777 on 2021/09/26.
//

import UIKit

class Case3ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "非同期関数の利用と実装（エラーハンドリングがある場合）"
        
        fetchUserBefore(for: "") { result in
            do {
                print("Before result:\(try result.get())")
            } catch {
                print("Before result:\(error)")
            }
        }
        
        Task {
            do {
                print("After result:\(try await fetchUserAfter(for: ""))")
            } catch {
                print("Before result:\(error)")
            }
        }
    }
    
    private func fetchUserBefore(for id: String, completion: @escaping (Result<User, Error>) -> Void) {
        downloadDataBefore(from: URL(string: "https://")!) { result in
            do {
                let data = try result.get()
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }
    }
    /// After には do - try - catch が存在しない
    /// downloadDataAfterやdecodeのtryを、fetchUser の throws で受けているため
    /// わざわざ catch して throw しなおさなくても
    ///  fetchUser には throws が付与されているのでそのままエラーを投げることができる
    private func fetchUserAfter(for id: String) async throws -> User {
        let data = try await downloadDataAfter(from: URL(string: "https://")!)
        let user = try JSONDecoder().decode(User.self, from: data)
        return user
    }
}

// MARK: downloadData メソッド
extension Case3ViewController {
    private func downloadDataBefore(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(self.parseJson(from: "{\"id\":1, \"name\":\"Suzuki\"}")!))
        }
    }
    
    private func downloadDataAfter(from url: URL) async throws -> Data {
        /// 多分1秒遅延
        await Task.sleep(1 * 1000 * 1000 * 1000)
        return self.parseJson(from: "{\"id\":2, \"name\":\"Yamamoto\"}")!
    }
}
