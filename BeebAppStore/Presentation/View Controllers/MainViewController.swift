//
//  MainViewController.swift
//  BeebAppStore
//
//  Created by Chris Scutt on 04/07/2025.
//

import UIKit

class MainViewController: UIViewController {
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var appResultsTable: UITableView!
	private let searchButton = UIButton(type: .system)
	
	private var searchManager: SearchTermManager!
	private var viewModel: MainViewModel!
	
	private var searchResults: [SearchResult] = [] {
		didSet {
			DispatchQueue.main.async {
				if self.searchResults.isEmpty && self.searchBar.text?.isEmpty == false {
					self.showTableMessage("No results found. Try a different search term.")
				} else {
					self.hideTableMessage()
				}
				self.appResultsTable.reloadData()
			}
		}
	}
	private var selectedResult: SearchResult?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let appDelegate = AppDelegate.shared
		searchManager = SearchTermManagerImpl(context: appDelegate.context)
		viewModel = MainViewModel(searchManager: searchManager, networkService: appDelegate.networkService)

		NetworkMonitor.shared.delegate = self
		
		appResultsTable.delegate = self
		appResultsTable.dataSource = self
		
		searchBar.placeholder = "Search for apps"
		searchBar.accessibilityHint = "Enter text to search the App Store"
		searchBar.delegate = self
		searchBar.translatesAutoresizingMaskIntoConstraints = false
		
		searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
		searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
		searchButton.translatesAutoresizingMaskIntoConstraints = false

		let stackView = UIStackView(arrangedSubviews: [searchBar, searchButton])
		stackView.axis = .horizontal
		stackView.spacing = 8
		stackView.alignment = .center
		stackView.translatesAutoresizingMaskIntoConstraints = false

		view.addSubview(stackView)

		NSLayoutConstraint.activate([
			stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
		])

		searchBar.setContentHuggingPriority(.defaultLow, for: .horizontal)
		searchButton.setContentHuggingPriority(.required, for: .horizontal)

		// Set constraints for results table
		NSLayoutConstraint.activate([
			appResultsTable.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
			appResultsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			appResultsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			appResultsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])		
	}
	
	private func showSimpleAlert(title: String, message: String) {
		let alert = UIAlertController(title: title,
									  message: message,
									  preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default))
		self.present(alert, animated: true)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowDetail",
		   let destination = segue.destination as? DetailViewController {
			destination.result = selectedResult
		}
	}
	
	@objc func searchButtonTapped() {
		searchBar.resignFirstResponder()
		
		guard let searchText = searchBar.text else {
			return
		}

		performSearch(searchText)
	}
	
	private func performSearch(_ query: String) {
		Task {
			do {
				self.searchResults = try await viewModel.performSearch(for: query)
			} catch {
				let nsError = error as NSError
				if nsError.domain == NSURLErrorDomain, nsError.code == NSURLErrorNotConnectedToInternet {
					showSimpleAlert(title: "No Results Found", message: "App is working offline. Please try again later.")
				} else {
					showSimpleAlert(title: "No Results Found", message: "Error occurred: \(error.localizedDescription)")
				}
			}
		}
	}
	
	private func showTableMessage(_ message: String) {
		let label = UILabel()
		label.text = message
		label.textColor = .label
		label.font = .systemFont(ofSize: 18)
		label.textAlignment = .center
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false

		let container = UIView()
		container.addSubview(label)

		NSLayoutConstraint.activate([
			label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
			label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
			label.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: 20),
			label.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -20)
		])
		
		appResultsTable.backgroundView = container
		appResultsTable.separatorStyle = .none
	}
	
	private func hideTableMessage() {
		appResultsTable.backgroundView = nil
		appResultsTable.separatorStyle = .singleLine
	}

}

extension MainViewController : UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.searchResults.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "AppResultCell", for: indexPath) as! AppResultCell
		
		let result = self.searchResults[indexPath.row]
		cell.configure(with: result)
		
		return cell
	}
	
}

extension MainViewController : UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let storyboard = UIStoryboard(name: "Detail", bundle: nil)
		if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
			detailVC.result = self.searchResults[indexPath.row]
			navigationController?.pushViewController(detailVC, animated: true)
		}
	}
	
}

extension MainViewController : UISearchBarDelegate {
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		if let query = searchBar.text {
			searchBar.resignFirstResponder()
			performSearch(query)
		}
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText.isEmpty {
			searchBar.resignFirstResponder()
			hideTableMessage()
			searchResults.removeAll()
			appResultsTable.reloadData()
		}
	}
	
}

extension MainViewController : NetworkMonitorDelegate {
	
	func reportNoInternetConnection() {
		showSimpleAlert(title: "No Internet Connection", message: "Please check your internet settings.")
	}
	
}
