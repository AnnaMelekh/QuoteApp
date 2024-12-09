//
//  ViewController.swift
//  QuoteApp
//
//  Created by Anna Melekhina on 09.12.2024.
//

import UIKit

class SwipeViewController: UIViewController {
    
    var cards: [UIView] = []
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCards()
    }
    
    func setupCards() {
        let colors: [UIColor] = [.red, .blue, .green, .yellow, .orange]
        
        for color in colors {
            let card = UIView(frame: CGRect(x: 20, y: 100, width: self.view.frame.width - 40, height: self.view.frame.height - 200))
            card.backgroundColor = color
            card.layer.cornerRadius = 10
            card.layer.shadowColor = UIColor.black.cgColor
            card.layer.shadowOpacity = 0.2
            card.layer.shadowOffset = CGSize(width: 0, height: 5)
            card.layer.shadowRadius = 10
            card.isUserInteractionEnabled = true
            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            card.addGestureRecognizer(panGesture)
            
            self.cards.append(card)
            self.view.addSubview(card)
        }
        
         for (index, card) in cards.enumerated() {
            card.transform = CGAffineTransform(translationX: 0, y: CGFloat(index * 10))
        }
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let card = gesture.view else { return }
        
        let translation = gesture.translation(in: self.view)
        let xFromCenter = translation.x
        let screenWidth = self.view.bounds.width
        
        switch gesture.state {
        case .changed:
             let rotation = xFromCenter / screenWidth * 0.3
            card.center = CGPoint(x: self.view.center.x + translation.x, y: self.view.center.y + translation.y)
            card.transform = CGAffineTransform(rotationAngle: rotation)
        case .ended:
             if abs(xFromCenter) > screenWidth / 2 {
                let direction: CGFloat = xFromCenter > 0 ? 1 : -1
                let endPoint = CGPoint(x: card.center.x + direction * screenWidth, y: card.center.y)
                
                 UIView.animate(withDuration: 0.3, animations: {
                    card.center = endPoint
                    card.alpha = 0
                }) { _ in
                    card.removeFromSuperview()
                    self.cards.removeFirst()
                }
            } else {

                UIView.animate(withDuration: 0.3, animations: {
                    card.center = self.view.center
                    card.transform = .identity
                })
            }
        default:
            break
        }
    }
}

#Preview { SwipeViewController() }
