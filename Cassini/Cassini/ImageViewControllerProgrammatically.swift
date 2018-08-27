//
//  ImageViewControllerProgrammatically.swift
//  Cassini
//
//  Created by Nayan, Neeraj on 27/08/18.
//  Copyright © 2018 Nayan, Neeraj. All rights reserved.
//

import UIKit

// Scroll View Demo - ScrollView added programatically
class ImageViewControllerProgrammatically: UIViewController, UIScrollViewDelegate {

    var imageURL: URL? {
        didSet {
            image = nil
            
            // Ensure this view is visible, before fetching image
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            // Ensure parent scroll view content area size -
            // which indicates the entire scrollable area
            // is set to current image size. That way entire image is scrollable
            scrollView.contentSize = imageView.frame.size
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // If image is not yet set, fetch the image
        if imageView.image == nil {
            fetchImage()
        }
    }
    
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            // adding zoom
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 10.0
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private var imageView = UIImageView()
    
    private func fetchImage() {
        if let url = imageURL {
            // try? -> Try this and if it throws return nil
            let urlContents = try? Data(contentsOf: url)
            if let imageData = urlContents {
                image = UIImage(data: imageData)
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
