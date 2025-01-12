//
//  ViewController.swift
//  Life-FormSearch
//
//  Created by Wesley Keetch on 1/7/25.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate
{

  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!

  var results: [SearchResult] = []
  var dataModel = ["string", "dog", "cap"]

  override func viewDidLoad() {
    super.viewDidLoad()

    searchBar.delegate = self
    tableView.dataSource = self
    tableView.delegate = self
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    guard !searchText.isEmpty else {
      results = []
      tableView.reloadData()
      return
    }

    Task {
      do {
        let fetchedResults = try await EOLAPIManager.shared
          .fetchSearchResults(query: searchText)
        self.results = fetchedResults
        self.tableView.reloadData()
      } catch {
        print("Error fetching results: \(error)")
      }
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
  -> Int
  {
    return results.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
  -> UITableViewCell
  {
    let cell =
    tableView.dequeueReusableCell(withIdentifier: "ResultCell")
    ?? UITableViewCell(style: .subtitle, reuseIdentifier: "ResultCell")
    let result = results[indexPath.row]
    cell.textLabel?.text = result.title
    cell.detailTextLabel?.text = result.content
    return cell
  }

  func tableView(
    _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
  ) {
    tableView.deselectRow(at: indexPath, animated: true)

    let selectedResult = results[indexPath.row]

    Task {
      do {
        let pageDetail = try await EOLAPIManager.shared
          .fetchPageDetails(for: selectedResult.id)
        navigateToDetailViewController(with: pageDetail)
      } catch {
        printContent("Error fetching page detail: \(error)")
      }
    }
  }

  private func navigateToDetailViewController(with pageDetail: PageResponse) {
    let detailVC = PageDetailViewController()
    detailVC.pageDetail = pageDetail
    navigationController?.pushViewController(detailVC, animated: true)
  }
}
