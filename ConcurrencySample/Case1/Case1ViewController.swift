//
//  ViewController.swift
//  ConcurrencySample
//
//  Created by RLS77777777 on 2021/09/25.
//

import UIKit

class Case1ViewController: UIViewController {

    override func viewDidLoad() {
        print("--------- Case1ViewController ---------")
        super.viewDidLoad()
        print("Before ready")
        downloadDataBefore(from: URL(string: "https://")!) { data in
            print(data)
        }
        
        Task {
            // print("After ready")とprint(data)が同じスレッドで実行される保証はない
            print("After ready")
            let data = await downloadDataAfter(from: URL(string: "https://")!)
            print(data)
        }
    }
}

extension Case1ViewController {
    func downloadDataBefore(from url: URL, completion: @escaping (String) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion("Before Data")
        }
    }
    
    func downloadDataAfter(from url: URL) async -> String {
        /// 多分1秒遅延
        await Task.sleep(1 * 1000 * 1000 * 1000)
        return "After Data"
    }
}

