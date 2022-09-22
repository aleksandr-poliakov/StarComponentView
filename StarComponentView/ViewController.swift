//
//  ViewController.swift
//  StarComponentView
//
//  Created by Aleksandr on 06.01.2022.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Properties
    
    let starComponentView = StarComponentView(maximumStars: 6)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        starComponentView.translatesAutoresizingMaskIntoConstraints = false
        starComponentView.delegate = self
        starComponentView.rate = 3
        view.addSubview(starComponentView)
        
        
        NSLayoutConstraint.activate([
            starComponentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            starComponentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            starComponentView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        starComponentView.setCurrentStarsCount(starsCount: 10)
    }
}

// MARK: - StarComponentDelegate

extension ViewController: StarComponentDelegate {
    
    func rate(number: Int, starComponentView: StarComponentView) {
        let alert = UIAlertController(title: "Cool!", message: "You rate this with \(number)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}
