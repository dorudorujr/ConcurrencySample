//
//  Case6ViewController.swift
//  ConcurrencySample
//
//  Created by RLS77777777 on 2021/09/26.
//

import UIKit

class Case6ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "コールバックから async への変換"
        
        Task {
            do {
                print("After result:\(try await downloadDataAfter(from: URL(string: "https://")!))")
            } catch {
                print("Before result:\(error)")
            }
        }
    }
}

// MARK: downloadData メソッド
extension Case6ViewController {
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
