//
//  AppResultCell.swift
//  BeebAppStore
//
//  Created by Chris Scutt on 04/07/2025.
//

import UIKit

class AppResultCell : UITableViewCell {
	@IBOutlet weak var appIconView: UIImageView!
	@IBOutlet weak var appNameLabel: UILabel!
	@IBOutlet weak var appNameValue: UILabel!
	@IBOutlet weak var sellerNameLabel: UILabel!
	@IBOutlet weak var sellerNameValue: UILabel!
	
	private var imageLoadTask: URLSessionDataTask?
	
	private func setPlaceholder() {
		let config = UIImage.SymbolConfiguration(pointSize: 60, weight: .regular)
		let placeholder = UIImage(systemName: "photo", withConfiguration: config)
		appIconView.tintColor = .gray
		appIconView.image = placeholder?.withRenderingMode(.alwaysTemplate)
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		imageLoadTask?.cancel()
		imageLoadTask = nil
		setPlaceholder()
	}
	
	func configure(with result: SearchResult) {
		loadImage(urlString: result.iconURL)
		appIconView.layer.cornerRadius = 16
		appNameValue.text = result.appName
		sellerNameValue.text = result.sellerName
		
		if let appName = result.appName, let sellerName = result.sellerName {
			accessibilityLabel = "\(appName), by \(sellerName)"
		}
		accessibilityHint = "Double tap to view app details"
		accessibilityTraits = .button
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
					self.appIconView.image = image
				}
			}
		}
		imageLoadTask?.resume()
	}
}
