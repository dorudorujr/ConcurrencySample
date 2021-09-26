//
//  UIViewController.swift
//  ConcurrencySample
//
//  Created by RLS77777777 on 2021/09/26.
//

import UIKit

extension UIViewController {
    func parseJson(from string: String) -> Data? {
        string.data(using: String.Encoding.utf8)
    }
}
