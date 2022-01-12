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
    func rate(number: Int)
}

/// Object StarComponent use for configuring stars for ratings
class StarComponentView: UIView {
    // MARK: - Properties
    
    /// The container for a stars.
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: starButtons)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    /// The array of stars which helps fullfill container for stars
    private var starButtons: [UIButton] = []
    
    /// The type of value which contains maximum stars
    private var maximumElements: Int = 10
    
    /// The type of value which contains minimum stars
    private var minimumElements: Int = 0
    
    /// Changes the star component layout and maximum stars.
    /// - parameter setMax: The type of the value which sets maximum stars.
    public var setMax: Int = 0 {
        didSet {
            configureStars(maximumStars: setMax)
        }
    }
    
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
        
        configureStars(maximumStars: maximumStars)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    private func configureStars(maximumStars: Int) {
        if maximumStars > 10 {
            assert(maximumStars > 10, "You cannot set maximum stars greater then 10")
            maximumElements = 10
        } else if maximumStars < 3 {
            assert(maximumStars < 3, "You cannot set maximum stars less then minimum stars")
            maximumElements = 10
        } else {
            maximumElements = maximumStars
        }
        
        contentStackView.arrangedSubviews.forEach {
            contentStackView.removeArrangedSubview($0)
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
        for index in minimumElements..<maximumElements {
            let starButton = UIButton(frame: CGRect(x: .zero, y: .zero, width: 30, height: 30))
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
            starButton.addTarget(self,
                                 action: #selector(tapOnAStar(sender:)),
                                 for: .touchUpInside)
            starButton.tag = index
            buttons.append(starButton)
        }
        
        return buttons
    }
    
    /// This functions responsible for setting the rating
    /// - parameter number: The type of the value returns count of elements on which you tap.
    /// For example you tap on a third star and then you fill 3 stars
    private func configureRating(number: Int) {
        for star in starButtons {
            if star.tag < number {
                star.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                star.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
    
    // MARK: - Actions
    
    /// This function responsible for a UIAction event when you tap on star you rate a product
    /// - parameter sender: returns tag because I set it for simplify setting image.
    @objc private func tapOnAStar(sender: UIButton) {
        for star in starButtons {
            if star.tag <= sender.tag {
                star.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                star.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
        
        delegate?.rate(number: sender.tag + 1)
    }
}

