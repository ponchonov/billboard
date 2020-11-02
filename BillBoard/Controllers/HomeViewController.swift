//
//  HomeViewController.swift
//  BillBoard
//
//  Created by Héctor Cuevas Morfín on 02/11/20.
//

import UIKit

class HomeViewController: UIViewController {
	let cellIdentifier = "movieCell"
	var movies:[Movie] = [Movie]()
	var isDataLoading = true
	var refreshControl = UIRefreshControl()
	var currentLanguage = "En"
	
	lazy var collectionView:UICollectionView = {
		let l = UICollectionViewFlowLayout()
		var itemSize = CGSize(width: UIScreen.main.bounds.width/2, height: 300)
		
		l.itemSize = itemSize
		l.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		l.minimumLineSpacing = 0
		l.minimumInteritemSpacing = 0
		
		let c = UICollectionView(frame: .zero, collectionViewLayout: l)
		
		c.translatesAutoresizingMaskIntoConstraints = false
		c.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
		c.dataSource = self
		c.delegate = self
		c.backgroundColor = UIColor(red:0.89, green:0.90, blue:0.90, alpha:1.00)
		
		return c
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.collectionView.alwaysBounceVertical = true
		self.refreshControl.tintColor = UIColor.red
		self.refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
		self.collectionView.addSubview(refreshControl)
		setUpView()
		getInitialData()
		self.title = "Pop Movies"
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "EN", style: .done, target: self, action: #selector(self.changeLanguage(sender:)))

		
	}
	
	@objc func changeLanguage(sender: UIBarButtonItem) {
		if (API.shared.language == "en") {
			API.shared.language = "es"
		} else {
			API.shared.language = "en"
		}
		self.getInitialData()
		self.navigationItem.rightBarButtonItem?.title = API.shared.language.uppercased()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		self.navigationController?.navigationBar.prefersLargeTitles = true
		setupLayout(width: UIScreen.main.bounds.width)
	}
	
	func setupLayout(width:CGFloat)  {
		
		var itemSize:CGSize?
		var numberOfColumns:CGFloat = 2
		if UIDevice.current.userInterfaceIdiom == .pad {
			numberOfColumns = 3
			if (UIDevice.current.orientation.isLandscape ){
				numberOfColumns = 5
			}
		}
		itemSize = CGSize(width: width/numberOfColumns, height: 300)
		
		let l = UICollectionViewFlowLayout()
		
		l.itemSize = itemSize!
		l.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		l.minimumLineSpacing = 0
		l.minimumInteritemSpacing = 0
		
		self.collectionView.collectionViewLayout.invalidateLayout()
		self.collectionView.collectionViewLayout = l
		self.collectionView.reloadData()
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		setupLayout(width: size.width)
	}
	
	func setUpView()  {
		self.view.backgroundColor = .white
		
		self.collectionView.alwaysBounceVertical = true
		self.refreshControl.tintColor = UIColor.red
		self.refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
		self.collectionView.addSubview(refreshControl)
		
		[collectionView].forEach(view.addSubview)
		
		NSLayoutConstraint.activate([
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo:view.trailingAnchor),
			collectionView.topAnchor.constraint(equalTo: view.topAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
		])
	}
	
	func getInitialData()  {
		API.shared.getMovies(completion: { [unowned self] (movies, error)  in
			self.movies = movies
			DispatchQueue.main.async {
				self.collectionView.reloadData()
				self.isDataLoading = false
				self.stopRefresher()
			}
		})
	}
	
	@objc func loadData() {
		refreshControl.beginRefreshing()
		getInitialData()
	}
	
	func stopRefresher() {
		refreshControl.endRefreshing()
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let contentOffsetY = scrollView.contentOffset.y
		if contentOffsetY >= (scrollView.contentSize.height - scrollView.bounds.height) - 40 /* Needed offset */ {
			guard !self.isDataLoading else { return }
			self.isDataLoading = true
			
			API.shared.getMovies(nextPage: true) { [unowned self] (movies, error) in
				//				self.movies.append(contentsOf: movies)
				DispatchQueue.main.async {
					for i in 0 ..< movies.count {
						DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.25) {
							self.movies.append(movies[i])
							self.collectionView.insertItems(at: [IndexPath(item: self.movies.count - 1, section: 0)])
						}
					}
					
					self.isDataLoading = false
				}
			}
			
		}
	}
}


extension HomeViewController:UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return movies.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell:MovieCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MovieCollectionViewCell
		
		cell.movie = movies[indexPath.row]
		
		return cell
	}
	
	
}

extension HomeViewController:UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let movie = movies[indexPath.row]
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
		
		vc.movie = movie
		
		self.show(vc, sender: nil)
	}
}
