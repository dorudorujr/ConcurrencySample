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
            case .case1:
                self.performSegue(withIdentifier: "case1", sender: nil)
            default:
                return
            }
        }
}
