//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Nayan, Neeraj on 23/08/18.
//  Copyright © 2018 Nayan, Neeraj. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: VCLLoggingViewController, UISplitViewControllerDelegate {
    
    override var vclLoggingName: String {
        return "ThemeChooser"
    }
    
    let themes = [
        "Sports": "⚽️🥊🎾🏹🏊🚴🎮🎸🎯🎳🤾‍♀️🎤⛸⛳️🏏🏑🏸🎱",
        "Animals": "🐶🐱🦊🐸🐷🐺🐝🦇🦆🦅🐞🐌🦋🐳🦌🦏🐑🐓",
        "Faces": "🤡🤑🤠🤓😎😇🤣😂😅😆😉😍😚😘🤗☹️😣😤😩",
    ]

    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    // Without this method, in phone, the first view is always ConcentrationViewController (Game page)
    // But first, you must set self as delegate to SplitViewController (Done above)
    // Collapse secondary view controller (detail viewcontroller) onto primary view controller (master view controller)
    //
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true
            }
        }
        return false
    }
    
    // Lecture 7. Multiple MVCs (55 minutes into the lecture video)
    @IBAction func changeTheme(_ sender: Any) {
        // Check if you can find a reference to splitViewController (In tablet)
        // Reuse the old MVC, do not create a new one. This is done to ensure
        // if we are in the middle of the game, the game is not started
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
            // Check if you can find a reference to ConcentrationView (In Phone)
            // Reuse the old MVC, do not create a new one. This is done to ensure
            // if we are in the middle of the game, the game is not started
        } else if let cvc = lastSeguedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
            // Maually push the viewController to navigation controller
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            // Else, create a new MVC
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        // In tablet, splitViewController is a member in current UIViewController
        // which holds the reference to parent splitViewController
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
    }
}
