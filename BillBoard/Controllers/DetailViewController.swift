//
//  DetailViewController.swift
//  BillBoard
//
//  Created by Héctor Cuevas Morfín on 02/11/20.
//

import UIKit

class DetailViewController: UIViewController {

	@IBOutlet weak var imageView: UIView!
	@IBOutlet weak var movieYear: UILabel!
	@IBOutlet weak var movieTime: UILabel!
	@IBOutlet weak var movieRate: UILabel!
	@IBOutlet weak var movieOverView: UITextView!
	
	var movie:Movie?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupView()
        // Do any additional setup after loading the view.
    }
    
	func setupView()  {
		let posterImage = MovieBillboardImageView(frame: imageView.bounds)
		
		imageView.addSubview(posterImage)
		
		guard let movie = movie else {return}
		
		posterImage.downloadImageFrom(thumbnailPath: movie.poster_path, imageMode: .scaleToFill)
		movieYear.text = movie.release_date
		movieRate.text = "\(movie.vote_average)/10"
		movieOverView.text = movie.overview
		self.title = movie.original_title
	}
}
