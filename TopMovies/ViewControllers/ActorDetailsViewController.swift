//
//  ActorDetailsViewController.swift
//  TopMovies
//
//  Created by Dina Vaingolts on 10/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit

class ActorDetailsViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var portretView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var filmografyContainer: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activiyView: UIActivityIndicatorView!
    
    var selectedMovieId: String?
    weak var filmographyViewController: HorizontalScrollViewController? {
        didSet {
            filmographyViewController?.selectionBlock = { [weak self] (selectedMovie) in
                self?.selectedMovieId = selectedMovie.getId()
                self?.performSegue(withIdentifier: "showMovieDetails", sender: self)
            }
            filmographyViewController?.dataSource = filmography
        }
    }
    var filmography: [CreditInMovie]? {
        didSet{
            filmographyViewController?.dataSource = filmography
        }
    }
    var actorId: String? {
        didSet {
            loadData()
            if self.view != nil {
                updateView()
            }
        }
    }
    
    var personDetails: Person?
    
    func loadData(){
        guard let personId = actorId else { return }
        DataProvider.shared.loadFilmography(personId: personId) {[weak self] (filmCredits) in
            self?.filmography = filmCredits
        }
        DataProvider.shared.loadPersonDetails(personId: personId) {[weak self] (actorDetails) in
            self?.personDetails = actorDetails
            self?.updateView()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.isHidden = false
        self.view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        activiyView.startAnimating()
        updateView()
    }
    
    func updateView(){
        guard let person = personDetails else { return }
        loadingView.isHidden = true
        activiyView.stopAnimating()
        self.title = person.name
        if let posterPath = person.profile_path {
            let url = URL(string: DataProvider.shared.imageUrl(path:posterPath, width: 500))
            portretView.kf.setImage(with: url)
        }
        
        self.nameLabel.text = person.name
        self.birthdayLabel.text = person.birthday
        self.overviewLabel.text = person.biography
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if type(of:segue.destination) == HorizontalScrollViewController.self {
            self.filmographyViewController = segue.destination as? HorizontalScrollViewController
            self.filmographyViewController?.dataSource = filmography
        }else if type(of:segue.destination) == MovieDetailsViewController.self {
            let movieVC = segue.destination as! MovieDetailsViewController
            movieVC.movieId = self.selectedMovieId
        }
    }
        
        
}
