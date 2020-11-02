//
//  MovieCollectionViewCell.swift
//  BillBoard
//
//  Created by Héctor Cuevas Morfín on 02/11/20.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
	
	lazy var movieImage:UIImageView = {
		let m = UIImageView(frame: .zero)
		m.translatesAutoresizingMaskIntoConstraints = false

		return m
	}()
	
	var movie:Movie? {
		didSet {
			setUpData()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setUpView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setUpData() {
		guard let movie = self.movie else {return}
		
		DispatchQueue.global(qos: .background).async {
			guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster_path )") else {
				return
			}
			if let data = try? Data(contentsOf: url) {
				
				DispatchQueue.main.async {
					
					let image = UIImage(data: data)
					self.movieImage.image = image
				}
			}
		}
	}
	
	func setUpView()  {
		self.backgroundColor = .white
		[ movieImage].forEach(contentView.addSubview)
		
		NSLayoutConstraint.activate([
			movieImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			movieImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			movieImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			movieImage.topAnchor.constraint(equalTo: contentView.topAnchor),
		])
	}
	
}
