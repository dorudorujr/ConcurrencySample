//
//  TopViewController.swift
//  ConcurrencySample
//
//  Created by RLS77777777 on 2021/09/25.
//

import UIKit

class TopViewController: UITableViewController {
    
    private enum Cell: String, CaseIterable {
        case case1 = "Case1"
        case case2 = "Case2"
        case case3 = "Case3"
        case case5 = "Case5"
        case case6 = "Case6"
        case case9 = "Case9"
        case case10 = "Case10"
        case case11 = "Case11"
        case case12 = "Case12"
        case case14 = "Case14"
        case case15 = "Case15"
        case case16 = "Case16"
        case case17 = "Case17"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = Cell.allCases[indexPath.row].rawValue
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Cell.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard let cell = tableView.cellForRow(at: indexPath) else { return }

            switch Cell(rawValue: cell.textLabel?.text ?? "") {
            case .case1, .case2, .case3, .case5, .case6, .case9, .case10, .case11, .case12, .case14, .case15, .case16, .case17:
                self.performSegue(withIdentifier: cell.textLabel?.text ?? "", sender: nil)
            default:
                return
            }
        }
}
