//
//  Case18ViewController.swift
//  ConcurrencySample
//
//  Created by RLS77777777 on 2021/09/29.
//

import UIKit

class Case18ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var testNameLabel: UILabel!
    
    private let state: UserViewState = UserViewState()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "(actor, ObservableObject): 共有された状態の変更（非同期処理結果の反映）"
        
        let _ = Task {[weak self] in
            guard let state = self?.state else { return }
            // objectWillChange: ObservableObjectにデフォルトで実装されているプロパティ
            // データ更新を知らせる
            // valuesプロパティを使えば、PublisherをAsyncSequenceに変換することができる
            // sinkの代わりに、for awaitループを使ってPublisherを購読できる
            for await _ in state.objectWillChange.values {
                guard let self = self else { return }
                self.testNameLabel.text = await state.user?.name
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await state.loadUser()
        }
    }
}

// MARK: downloadData メソッド
extension Case18ViewController {
    /// SwiftUIの機能(UIKitでも使えるみたい)
    /// ObservableObject: 参照型のデータを監視するためのプロトコル
    actor UserViewState: ObservableObject {
        let userId: String = ""
        // UI側で監視したいデータに@Publishedをつける
        @Published var user: User?
        
        func loadUser() async {
            do {
                user = try await fetchUserAfter(for: userId)
            } catch {
                
            }
        }
        
        // MARK: ベースのメソッド
        
        private func fetchUserAfter(for id: String) async throws -> User {
            let data = try await downloadDataAfter(from: URL(string: "https://")!)
            let user = try JSONDecoder().decode(User.self, from: data)
            return user
        }
        
        private func downloadDataAfter(from url: URL) async throws -> Data {
            /// 多分1秒遅延
            await Task.sleep(1 * 1000 * 1000 * 1000)
            return "{\"id\":2, \"name\":\"Yamamoto\"}".data(using: String.Encoding.utf8)!
        }
    }
}
