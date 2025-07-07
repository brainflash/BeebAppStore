//
//  DetailViewController.swift
//  BeebAppStore
//
//  Created by Chris Scutt on 04/07/2025.
//

import UIKit

class DetailViewController : UIViewController {
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var appName: UILabel!
	@IBOutlet weak var trackValue: UILabel!
	@IBOutlet weak var artistValue: UILabel!
	@IBOutlet weak var ratingValue: UILabel!
	@IBOutlet weak var costValue: UILabel!
	@IBOutlet weak var detailsView: UITextView!
	
	var result: SearchResult?
	
	private var imageLoadTask: URLSessionDataTask?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setNavBarAppearance()

		if let result {
			appName.text = result.appName
			trackValue.text = result.appName
			artistValue.text = result.sellerName
			ratingValue.text = result.ratingString ?? ""
			costValue.text = result.priceString ?? ""
			detailsView.text = result.appDescription
			loadImage(urlString: result.imageURL)
		}
		
		detailsView.isEditable = false
		
		setupAccessibility()
	}
	
	private func setupAccessibility() {
		if let result {
			appName.accessibilityLabel = "App Name: \(result.appName ?? "")"
			trackValue.accessibilityLabel = "Track Name: \(result.appName ?? "")"
			artistValue.accessibilityLabel = "Artist Name: \(result.sellerName ?? "")"
			ratingValue.accessibilityLabel = "Rating: \(result.ratingString ?? "")"
			costValue.accessibilityLabel = "Price: \(result.priceString ?? "")"
			detailsView.accessibilityLabel = "App Description: \(result.appDescription ?? "")"
		}
	}
	
	private func setNavBarAppearance() {
		let appearance = UINavigationBarAppearance()
		appearance.configureWithTransparentBackground()
		appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.7)
		appearance.titleTextAttributes = [.foregroundColor: UIColor.label]

		navigationController?.navigationBar.standardAppearance = appearance
		navigationController?.navigationBar.scrollEdgeAppearance = appearance
	}
	
	private func setPlaceholder() {
		let config = UIImage.SymbolConfiguration(pointSize: 60, weight: .regular)
		let placeholder = UIImage(systemName: "photo", withConfiguration: config)
		imageView.tintColor = .gray
		imageView.image = placeholder?.withRenderingMode(.alwaysTemplate)
	}
	
	private func loadImage(urlString: String?) {
		guard let urlString, let url = URL(string: urlString) else {
			setPlaceholder()
			return
		}
		
		imageLoadTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
			guard let self, let data, error == nil else { return }
			
			if let image = UIImage(data: data) {
				DispatchQueue.main.async {
					self.imageView.image = image
				}
			}
		}
		imageLoadTask?.resume()
	}
}
