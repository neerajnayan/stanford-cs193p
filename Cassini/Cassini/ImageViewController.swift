//
//  ImageViewController.swift
//  Cassini
//
//  Created by Nayan, Neeraj on 27/08/18.
//  Copyright © 2018 Nayan, Neeraj. All rights reserved.
//

import UIKit

// Scroll View Demo - ScrollView added through interface builder
class ImageViewController: UIViewController {

    var imageURL: URL? {
        didSet {
            imageView.image = nil
            // Ensure this view is visible, before fetching image
            if view.window != nil {
                fetchImage()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // If image is not yet set, fetch the image
        if imageView.image == nil {
            fetchImage()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    private func fetchImage() {
        if let url = imageURL {
            // try? -> Try this and if it throws return nil
            let urlContents = try? Data(contentsOf: url)
            if let imageData = urlContents {
                imageView.image = UIImage(data: imageData)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if imageURL == nil {
            imageURL = DemoURLs.stanford
        }
    }
}
