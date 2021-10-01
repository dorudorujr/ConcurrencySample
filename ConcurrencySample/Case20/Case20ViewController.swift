//
//  Case20ViewController.swift
//  ConcurrencySample
//
//  Created by RLS77777777 on 2021/09/29.
//

import UIKit

class Case20ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    private let state: Case20UserViewState = Case20UserViewState()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let _ = Task {[weak self] in
            guard let state = self?.state else { return }
            for await _ in state.objectWillChange.values {
                guard let self = self else { return }
                self.nameLabel.text = state.user?.name
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
@MainActor
final class Case20UserViewState: ObservableObject {
    let userId: String = ""
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
