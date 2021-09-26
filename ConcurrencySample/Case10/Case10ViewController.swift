//
//  Case10ViewController.swift
//  ConcurrencySample
//
//  Created by RLS77777777 on 2021/09/26.
//

import UIKit

class Case10ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = " (TaskGroup): 並行処理（可変個数の場合）"
        
        fetchUserIconsBefore(for: ["1","2","3"]) { icons in
            do {
                print("Before Icons:\(try icons.get())")
            } catch {
                print("Before Icons:\(error)")
            }
        }
        
        Task {
            do {
                let icons = try await fetchUserIconsAfter(for: ["1","2","3"])
                print("Before Icons:\(icons)")
            } catch {
                print("Before Icons:\(error)")
            }
        }
    }
    
    private func fetchUserIconsBefore(for ids: [String], completion: @escaping (Result<[String: Data], Error>) -> Void) {
        var results: [String : Result<Data, Error>] = [:]
        let group: DispatchGroup = .init()
        for id in ids {
            let url = URL(string: "https://\(id)")!
            
            group.enter()
            downloadDataBefore(from: url) { icon in
                results[id] = icon
                group.leave()
            }
        }
        
        group.notify(queue: .global()) {
            do {
                let icons = try results.mapValues { try $0.get() }
                completion(.success(icons))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private func fetchUserIconsAfter(for ids: [String]) async throws -> [String : Data] {
        // withThrowingTaskGroup 関数に渡したクロージャの引数として
        // groupインスタンスを受け取る
        try await withThrowingTaskGroup(of: (String, Data).self) { group in
            // Child Taskの作成
            for id in ids {
                // addTask メソッドを使って、groupにChild Taskを追加
                // async let の場合と同様に、それらの Child Task は並行に実行
                // addTask のクロージャの中で await しているが
                // addTask 自体は await しておらず、このクロージャは並行して実行される
                // そのため、 ids のループは個々の id に対するダウンロードの結果を待たずに
                // イテレートする
                group.addTask {
                    let url = URL(string: "https://\(id)")!
                    return try await (id, self.downloadDataAfter(from: url))
                }
            }
            
            var icons: [String : Data] = [:]
            // group から Child Task の結果を取り出すときに await して待ち合わせる
            // for await （ for try await ）を使うことで、非同期的に得られる値を待ちながら順番に取り出すことができます。
            // Child Taskからデータの取得(Child Taskの実行を待つ)
            for try await (id, icon) in group {
                icons[id] = icon
            }
            return icons
        }
    }
}

// MARK: downloadData メソッド
extension Case10ViewController {
    private func downloadDataBefore(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(self.parseJson(from: "{\"id\":1, \"name\":\"Suzuki\"}")!))
        }
    }
    
    private func downloadDataAfter(from url: URL) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            downloadDataBefore(from: url) { result in
                continuation.resume(with: result)
            }
        }
    }
}
