//
//  StarComponentView.swift
//  StarComponentView
//
//  Created by Aleksandr on 06.01.2022.
//

import UIKit

/**
 StarComponentView that can be used to show rating for the products or something else. Which can select stars by tapping on them on a function tapOnAStar.
 Also you could set rating maximum stars.
 
 By default minimum stars 3 and maximum start 10
Example:
    let starComponentView = StarComponentView(maximumStars: 6)
    starComponentView.rate = 4
Shows: ★★★★☆☆
 
 The mechanism of work StarComponentView pretty Simple.
 When you set maximum stars then called a function configureStars(maximumStars: Int)
 Inside it we adding a count of stars to button and then in property contentStackView adding this buttons to arrangedSubviews.
*/

import UIKit

/// The method adopted by the object you use to manage user interactions with items in a Star Component.
protocol StarComponentDelegate: AnyObject {
    func rate(number: Int, starComponentView: StarComponentView)
}

/// Object StarComponent use for configuring stars for ratings
final class StarComponentView: UIView {
    // MARK: - Properties
    
    /// The container for a stars.
    private lazy var contentStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.alignment = .fill
        $0.spacing = 2
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        return $0
    }(UIStackView(arrangedSubviews: starButtons))
    
    /// The array of stars which helps fullfill container for stars
    private var starButtons: [UIButton] = []
    
    /// The type of value which contains maximum stars
    let maximumElements: Int = 10
    
    /// The type of value which contains minimum stars
    let minimumElements: Int = 3
    
    private var currentNumberOfElements: Int = 3
    
    /// Changes the star component rate.
    /// - parameter rate: The type of the value which sets rate.
    public var rate: Int = 0 {
        didSet {
            configureRating(number: rate)
        }
    }
    
    /// The object that acts as the delegate of the Star Component.
    weak var delegate: StarComponentDelegate?
    
    // MARK: - Init
    
    /// Initialiser with maximumStars parameter.
    init(maximumStars: Int) {
        super.init(frame: .zero)
        
        configureStars(starsCount: maximumStars)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Changes the star component layout and maximum stars.
    /// - parameter starsCount: The type of the value which sets maximum stars.
    ///
    func setCurrentStarsCount(starsCount: Int) {
        configureStars(starsCount: starsCount)
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    // MARK: - Private

    /// This functions responsible for configuring Stars and also has own constraints for example in Task
    /// - parameter maximumStars: The type of the value to to setting maximum stars.
    private func configureStars(starsCount: Int) {
        if starsCount > maximumElements || starsCount < minimumElements {
            assert(starsCount > maximumElements, "You cannot set maximum stars greater then \(maximumElements) or less then \(minimumElements)")
            currentNumberOfElements = maximumElements
            
            return
        }
        
        currentNumberOfElements = starsCount
        
        contentStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        starButtons.removeAll()
        starButtons = configureButtons()
        starButtons.forEach {
            contentStackView.addArrangedSubview($0)
        }
    }
    
    /// This functions responsible configuring buttons, depends on how much set on maximum element
    private func configureButtons() -> [UIButton] {
        var buttons: [UIButton] = []
        for _ in 0..<currentNumberOfElements {
            let starButton = UIButton(frame: .zero)
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
            starButton.addTarget(self,
                                 action: #selector(tapOnAStar(sender:)),
                                 for: .touchUpInside)
            buttons.append(starButton)
        }
        
        return buttons
    }
    
    /// This functions responsible for setting the rating
    /// - parameter number: The type of the value returns count of elements on which you tap.
    /// For example you tap on a third star and then you fill 3 stars
    private func configureRating(number: Int) {
        for index in 0...currentNumberOfElements - 1 {
            starButtons[index].setImage(UIImage(systemName: index < number ? "star.fill" : "star"), for: .normal)
        }
    }
    
    // MARK: - Actions
    
    /// This function responsible for a UIAction event when you tap on star you rate a product
    /// - parameter sender: returns tag because I set it for simplify setting image.
    @objc private func tapOnAStar(sender: UIButton) {
        guard let number = starButtons.firstIndex(of: sender) else {
            return
        }
        
        configureRating(number: number + 1)
        delegate?.rate(number: number + 1, starComponentView: self)
    }
}

