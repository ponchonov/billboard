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
	
	var trailers:[Video] = [Video]()
	
	@IBOutlet weak var tableView: UITableView! {
		didSet {
			tableView.register(UINib(nibName: "TrailerTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
			tableView.dataSource = self
		}
	}
	
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
		updateTrailers(movie: movie)
	}
	
	func  updateTrailers(movie:Movie)  {
		
		API.shared.getTrailers(movieId: movie.id) {[weak self] (videos, error) in
			guard let weakSelf = self else {return}
			if error == nil {
				DispatchQueue.main.async {
					weakSelf.trailers = videos
					weakSelf.tableView.reloadData()
				}
			}
		}
	}
}


extension DetailViewController:UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return trailers.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TrailerTableViewCell
		
		cell.trailer = self.trailers[indexPath.row]
		cell.selectionStyle = .none
		tableView.separatorColor = .clear

		return cell
	}
}
