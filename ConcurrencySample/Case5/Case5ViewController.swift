//
//  Case5ViewController.swift
//  ConcurrencySample
//
//  Created by RLS77777777 on 2021/09/26.
//

import UIKit

class Case5ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserIconBefore(for: "") { icon in
            do {
                print("Before icon:\(try icon.get())")
            } catch {
                print("Before result:\(error)")
            }
        }
        
        Task {
            do {
                print("After icon:\(try await fetchUserIconAfter(for: ""))")
            } catch {
                print("Before icon:\(error)")
            }
        }
    }
    
    private func fetchUserIconBefore(for id: String, completion: @escaping (Result<Data, Error>) -> Void) {
        downloadDataBefore(from: URL(string: "https://")!) { data in
            do {
                let data = try data.get()
                let user = try JSONDecoder().decode(User.self, from: data)
                self.downloadDataBefore(from: URL(string: "https://user/\(user.id)")!) { data in
                    do {
                        let icon = try data.get()
                        completion(.success(icon))
                    } catch {
                        completion(.failure(error))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private func fetchUserIconAfter(for id: String) async throws -> Data {
        let data = try await downloadDataAfter(from: URL(string: "https://")!)
        let user = try JSONDecoder().decode(User.self, from: data)
        let icon = try await downloadDataAfter(from: URL(string: "https://user/\(user.id)")!)
        return icon
    }
}

// MARK: downloadData メソッド
extension Case5ViewController {
    private func downloadDataBefore(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        if url.path.contains("user") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                completion(.success(self.parseJson(from: "{\"id\":1, \"icon\":\"icon.png\"}")!))
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                completion(.success(self.parseJson(from: "{\"id\":1, \"name\":\"Suzuki\"}")!))
            }
        }
    }
    
    private func downloadDataAfter(from url: URL) async throws -> Data {
        /// 多分1秒遅延
        await Task.sleep(1 * 1000 * 1000 * 1000)
        if url.path.contains("user") {
            return self.parseJson(from: "{\"id\":2, \"icon\":\"icon.png\"}")!
        } else {
            return self.parseJson(from: "{\"id\":2, \"name\":\"Yamamoto\"}")!
        }
    }
}
