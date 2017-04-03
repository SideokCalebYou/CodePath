//
//  DetailViewController.swift
//  Flicks
//
//  Created by sideok you on 4/2/17.
//  Copyright © 2017 sideok. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var overView: UILabel!
    
    var singlePosterUrl:URL!
    var singleOverview:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height * 3
        scrollView.contentSize = CGSize(width:contentWidth, height:contentHeight)
        
        detailImageView.setImageWith(singlePosterUrl)
        overView.text = singleOverview
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
