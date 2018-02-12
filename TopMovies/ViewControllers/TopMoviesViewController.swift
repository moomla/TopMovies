//
//  TopMoviesViewController.swift
//  TopMovies
//
//  Created by Dina Vaingolts on 09/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit
import Kingfisher

class TopMoviesViewController: UIViewController {
    
    var totalPages: Int = 0
    var lastLoadedPage: Int = 0
    var resultsPerPage: Int = 0
    var movies = [Movie]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortButton: UIButton!
    
    var selectedMovieId: String?
    var selectedSort: MovieSortOption = .popularity(asc: false) {
        didSet {
            sortButton.setTitle(selectedSort.name, for: .normal)
            reloadMovies()
        }
    }
    var selectedGenre: Genre? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Top Movies"
        self.reloadMovies()
        sortButton.setTitle(selectedSort.name, for: .normal)
    }
    
    
    func reloadMovies() {
        self.movies.removeAll()
        loadMoviesForPage(page:1)
    }
    
    func loadMoviesForPage(page: Int) {
        lastLoadedPage = page
        
        let request = MovieRequestData(page: lastLoadedPage,
                                       sortOption: selectedSort,
                                       genres: [selectedGenre])
        
        DataProvider.shared.loadMovies(requestData: request){ [unowned self] (responce) in
            if responce?.page != self.lastLoadedPage {
                return
            }
            if let newMovies = responce?.results {
                self.movies.append(contentsOf:newMovies)
                self.resultsPerPage = newMovies.count
                self.tableView.reloadData()
            }
            self.totalPages = responce?.total_pages ?? 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if type(of:segue.destination) == MovieDetailsViewController.self {
            let moviewDetailsVC = segue.destination as! MovieDetailsViewController
            moviewDetailsVC.movieId = selectedMovieId
        }
    }
}

extension TopMoviesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if lastLoadedPage != totalPages && indexPath.row == movies.count - 1 {
            loadMoviesForPage(page:lastLoadedPage + 1);
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == self.movies.count) {
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath)
            let activityIndicator = cell.contentView.viewWithTag(100) as! UIActivityIndicatorView
            activityIndicator.startAnimating()
            return cell
        } else {
            
        let cell : MovieSummaryCell = tableView.dequeueReusableCell(withIdentifier: "MovieSummaryCell", for: indexPath) as! MovieSummaryCell
        let movie = movies[indexPath.row]
        if let posterPath = movie.poster_path {
            let url = URL(string: DataProvider.shared.imageUrl(path:posterPath))
            cell.posterView.kf.setImage(with: url)
        }
        cell.titleLabel.text = movie.title
        cell.yearLabel.text = movie.year
        cell.descriptionLabel.text = movie.overview
        cell.rateLabel.text = movie.vote_average
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  (lastLoadedPage == totalPages) ? movies.count : movies.count + 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        self.selectedMovieId = movie.id
        self.performSegue(withIdentifier: "showMovieDetails", sender: self)
    }

}

//#pragma mark filters, sort

extension TopMoviesViewController {

    @IBAction func sortButtonClicked(_ sender: Any) {
        
        let currentSort = "popularity"
        let title =  "Sort by:(\(currentSort))"
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        for sort in MovieSortOption.array {
            alert.addAction(UIAlertAction(title: sort.name, style: .default , handler:{ (UIAlertAction)in
                self.selectedSort = sort
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func filterButtonClicked(_ sender: Any) {
        
        let currentSort = "popularity"
        let title =  "Sort by:(\(currentSort))"
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "clean selection", style: .default , handler:{ (UIAlertAction)in
            self.selectedGenre = nil
            self.reloadMovies()
        }))
        
        guard let genres = DataProvider.shared.genres else { return }
        for genre in genres {
            alert.addAction(UIAlertAction(title: genre.name, style: .default , handler:{ (UIAlertAction)in
                self.selectedGenre = genre
                self.reloadMovies()
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
    }

}
