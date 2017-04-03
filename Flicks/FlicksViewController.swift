//
//  FlicksViewController.swift
//  Flicks
//
//  Created by sideok you on 4/1/17.
//  Copyright © 2017 sideok. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class FlicksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    var movies:[NSDictionary] = []
    
    @IBOutlet var FlicksView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 100
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        let now_playing_url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        
        
        
        let request = URLRequest(url: now_playing_url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        MBProgressHUD.showAdded(to: self.view, animated:true)
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        
                        self.movies = responseDictionary["results"] as! [NSDictionary]
                        
                        print("\(self.movies)")
                        
                        self.tableView.reloadData()
                        
                        MBProgressHUD.hide(for: self.view, animated:true)
                    }
                }else{
                   MBProgressHUD.hide(for: self.view, animated:true)
                   self.tableView.isHidden = true
                   let networkErrorLabel:UILabel = UILabel()
                   networkErrorLabel.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
                   networkErrorLabel.textAlignment = .center
                   networkErrorLabel.text = "Network Error"
                   networkErrorLabel.numberOfLines=1
                   networkErrorLabel.textColor=UIColor.red
                   networkErrorLabel.font=UIFont.systemFont(ofSize: 22)
                   networkErrorLabel.backgroundColor=UIColor.lightGray
                    
                   self.FlicksView.addSubview(networkErrorLabel)
                }
        });
        task.resume()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        let now_playing_url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        
        let request = URLRequest(url: now_playing_url!)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let responseDictionary = try! JSONSerialization.jsonObject(
                    with: data, options:[]) as? NSDictionary {
                    
                    self.movies = responseDictionary["results"] as! [NSDictionary]
                    
                    self.tableView.reloadData()
                    refreshControl.endRefreshing()
                }
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomCell
        let movie = movies[indexPath.row]
        
        
        if let posterPath = movie["poster_path"] as? String {
            let posterBaseUrl = "https://image.tmdb.org/t/p/w342"
            let posterUrl = URL(string: posterBaseUrl + posterPath)!
            cell.cellImageView.setImageWith(posterUrl)
        }
        else {
            cell.cellImageView.image = nil
        }
        
        if let movieTitle = movie["title"] as? String{
            cell.movieTitleLabel.text = movieTitle
        }
        
        if let movieOverview = movie["overview"] as? String{
            cell.movieSummaryLabel.text = movieOverview
        }
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DetailViewController
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
        
        let movie = movies[indexPath.row]
        
        if let postPath = movie["poster_path"] as? String{
            let posterBaseUrl = "https://image.tmdb.org/t/p/w342"
            let posterUrl = URL(string: posterBaseUrl + postPath)!
            vc.singlePosterUrl = posterUrl
        }else{
            vc.singlePosterUrl = nil
        }
        
        if let overview = movie["overview"] as? String{
            vc.singleOverview = overview
        }else{
            vc.singleOverview = "There is no overview of this movie"
        }
        
        
        
    }
    

}
