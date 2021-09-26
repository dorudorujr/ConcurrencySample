//
//  Case9ViewController.swift
//  ConcurrencySample
//
//  Created by RLS77777777 on 2021/09/26.
//

import UIKit

class Case9ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "async let): 並行処理（固定個数の場合）"
        
        fetchUserIconsBefore(for: "") { icons in
            do {
                print("Before small:\(try icons.get().small),large:\(try icons.get().large)")
            } catch {
                print(error)
            }
        }
        
        Task {
            do {
                let icons = try await fetchUserIconsAfter(for: "")
                print("After small:\(icons.small),large:\(icons.large)")
            } catch {
                print(error)
            }
        }
    }
    
    private func fetchUserIconsBefore(for id: String, completion:
                                      @escaping (Result<(small: Data, large: Data), Error>) -> Void) {
        // 二つの処理が終わるのを待ち合わせて completion ハンドラーを呼び出す
        // ここでは DispatchGroup を使って待ち合わせを実現しています
        let group: DispatchGroup = .init()
        
        var smallIcon: Result<Data, Error>!
        group.enter()
        downloadDataBefore(from: URL(string: "https://small")!) { icon in
            smallIcon = icon
            group.leave()
        }
        
        var largeIcon: Result<Data, Error>!
        group.enter()
        downloadDataBefore(from: URL(string: "https://large")!) { icon in
            largeIcon = icon
            group.leave()
        }
        
        group.notify(queue: .global()) {
            do {
                let icons = try (small: smallIcon.get(), large: largeIcon.get())
                completion(.success(icons))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchUserIconsAfter(for id: String) async throws -> (small: Data, large: Data) {
        // awaitもtryも不要
        async let smallIcon = downloadDataAfter(from: URL(string: "https://small")!)
        async let largeIcon = downloadDataAfter(from: URL(string: "https://large")!)
        // do-catchがなくてもthrowsされる
        let icons = try await (small: smallIcon, large: largeIcon)
        return icons
    }
}

// MARK: downloadData メソッド
extension Case9ViewController {
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
