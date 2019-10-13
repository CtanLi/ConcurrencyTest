//
//  ViewController.swift
//  ConcurrencyTest
//


import UIKit

class ViewController: UIViewController {

    var fetchMessage = FetchMessages()
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabel()
        
        label.text = "loading..."
        
        fetchMessage.loadMessage { combinedMessage in
            self.label.text = combinedMessage
        }
    }
}

extension ViewController {
    private func setupLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
