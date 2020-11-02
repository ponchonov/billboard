//
//  MovieBillboardImageView.swift
//  BillBoard
//
//  Created by Héctor Cuevas Morfín on 02/11/20.
//

import UIKit
import ImageIO


class MovieBillboardImageView: UIView {
	
	let imageCache = NSCache<NSString, AnyObject>()

	var image:UIImage? {
		didSet {
			self.movieBillboardImageView.image = self.image
		}
	}
	var task:URLSessionDataTask?

	override var contentMode: UIView.ContentMode {
		didSet {
			self.movieBillboardImageView.contentMode = self.contentMode
		}
	}
	private lazy var movieBillboardImageView:UIImageView = {
		let i = UIImageView(frame: .zero)
		i.translatesAutoresizingMaskIntoConstraints = false
		
		return i
	}()
	
	private lazy var activityIndicator: UIActivityIndicatorView = {
		let i = UIActivityIndicatorView(style: .large)
		i.translatesAutoresizingMaskIntoConstraints = false
		i.color = .black
		i.hidesWhenStopped = true
		i.isHidden = false
		
		return i
	}()
	
	init() {
		super.init(frame: .zero)
		setUpView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setUpView() {
		self.translatesAutoresizingMaskIntoConstraints = false
		[movieBillboardImageView, activityIndicator].forEach(self.addSubview)
		
		NSLayoutConstraint.activate([
			movieBillboardImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			movieBillboardImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
			movieBillboardImageView.topAnchor.constraint(equalTo: topAnchor),
			movieBillboardImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
		])
	}
	
	// MARK: - Properties
	
	var imageURLString: String?
	
	func downloadImageFrom(thumbnailPath: String, imageMode: UIView.ContentMode) {
		task?.cancel()
		
		guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(thumbnailPath)") else {
			return
		}
		
		imageURLString = url.absoluteString
		
		self.activityIndicator.startAnimating()
		self.image = nil
		contentMode = imageMode
		if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
			self.image = cachedImage
			self.activityIndicator.stopAnimating()
		} else {
			 task =  URLSession.shared.dataTask(with: url) { data, response, error in
				
				if self.imageURLString != response?.url?.absoluteString ?? ""{
					return
				}
				guard let data = data, error == nil else {
					DispatchQueue.main.async {
						self.activityIndicator.stopAnimating()
					}
					return }
				DispatchQueue.main.async {
					if let imageToCache = UIImage(data: data) {
						
						self.imageCache.setObject(imageToCache, forKey: url.absoluteString as NSString)
						self.image = imageToCache
						self.activityIndicator.stopAnimating()
					}
				}
			}
			
			task?.resume()
		}
	}
}


