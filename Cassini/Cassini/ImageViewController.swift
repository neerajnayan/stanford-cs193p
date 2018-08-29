//
//  ImageViewControllerProgrammatically.swift
//  Cassini
//
//  Created by Nayan, Neeraj on 27/08/18.
//  Copyright © 2018 Nayan, Neeraj. All rights reserved.
//

import UIKit

// Scroll View Demo - ScrollView added programatically
class ImageViewController: UIViewController, UIScrollViewDelegate {

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
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // If image is not yet set, fetch the image
        if imageView.image == nil {
            fetchImage()
        }
    }
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
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
            spinner.startAnimating()
            // Closure does not introduce memory cycle here, because
            // though closure does point to self, self does not point to closure.
            // The closure is just an argument to async method.
            // However, use ever leaves this view controller, without API being
            // returned, closure will not let the viewController to cleanup as
            // it holds the reference to self. Hence [weak self] must be added
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                // try? -> Try this and if it throws return nil
                let urlContents = try? Data(contentsOf: url)
                // Run the UI code in UI thread
                // Also ensure that user has not requested for different image
                // while the first one is loaded, hence the second condition
                // in the if statement below
                DispatchQueue.main.async {
                    if let imageData = urlContents, url == self?.imageURL {
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if imageURL == nil {
//            imageURL = DemoURLs.stanford
//        }
    }
}
