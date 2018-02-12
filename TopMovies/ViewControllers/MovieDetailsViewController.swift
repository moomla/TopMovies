//
//  MovieDetailsViewController.swift
//  TopMovies
//
//  Created by Dina Vaingolts on 10/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var castContainer: UIView!
    @IBOutlet weak var dataBackGroundView: UIView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activiyView: UIActivityIndicatorView!
    
    weak var castViewController: HorizontalScrollViewController?
    
    var movieId: String? {
        didSet{
            guard let id = movieId else { return }
            DataProvider.shared.loadCastDetails(movieId: id) { [weak self] (cast) in
                self?.cast = cast
            }
            DataProvider.shared.loadMovieDetails(movieId: id) { [weak self] (movieDetails) in
                self?.movieDetails = movieDetails
            }
        }
    }
        
    var movieDetails: MovieDetails? {
        didSet{
            if self.view != nil {
                setupView()
            }
        }
    }
    
    var cast: [Cast]? {
        didSet{
            self.castViewController?.dataSource = cast
        }
    }
    var selectedCast: SmallViewPresentable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.dataBackGroundView.backgroundColor = UIColor(red: 92.0/256.0, green: 172.0/256.0, blue: 238.0/256.0, alpha: 1)
        self.dataBackGroundView.layer.cornerRadius = self.dataBackGroundView.frame.height / 2
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loadingView)
        loadingView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        loadingView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: self.topLayoutGuide.topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.bottomAnchor).isActive = true
//        loadingView.setNeedsLayout()
//        loadingView.layoutIfNeeded()
        loadingView.isHidden = false
        activiyView.startAnimating()
    }
    
    func setupView(){
        guard let movieUnw = movieDetails else { return }
        
        activiyView.stopAnimating()
        loadingView.isHidden = true
        
        self.title = movieUnw.title
        if let posterPath = movieUnw.poster_path {
            let url = URL(string: DataProvider.shared.imageUrl(path:posterPath, width: 500))
            posterView.kf.setImage(with: url)
        }
        
        titleLabel.text = movieUnw.title
        yearLabel.text = movieUnw.year
        rateLabel.text = movieUnw.vote_average
        
        let genres = movieUnw.genres?.map { (genre) in genre.name }
            .flatMap { $0 }
            .joined(separator: ", ")
        if let genreLine = genres{
            genresLabel.text = "Genres: " + genreLine
        }
        
        overviewLabel.text = movieUnw.overview
        if let runtime = movieUnw.runtime {
            self.durationLabel.text = runtime + "min."
        }
        
        self.castViewController?.selectionBlock = {[weak self] (selectedItem: SmallViewPresentable) in
            self?.selectedCast  = selectedItem
            self?.performSegue(withIdentifier: "showActorDetails", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if type(of:segue.destination) == HorizontalScrollViewController.self {
            self.castViewController = segue.destination as? HorizontalScrollViewController
            self.castViewController?.dataSource = cast
        }else if type(of:segue.destination) == ActorDetailsViewController.self {
            let actorVC = segue.destination as! ActorDetailsViewController
            actorVC.actorId = selectedCast?.getId()
        }
    }
}
