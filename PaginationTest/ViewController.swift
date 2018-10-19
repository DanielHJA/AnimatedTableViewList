//
//  ViewController.swift
//  PaginationTest
//
//  Created by Daniel Hjärtström on 2018-10-19.
//  Copyright © 2018 Sog. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var currentPage: Int = 0 {
        didSet {
            tableview.reloadData()
            indicator.currentPage = currentPage
        }
    }
    
    private var cells = [[String]]()
    private var mockData: [String] {
        return ["Barracuda","Cheetah","Basenji Dog","Basset Hound","Bat","Beagle","Bearded Collie","Bearded Dragon","Beaver","eon","Bear","Chamois","Dormouse","Chicken", "Basking Shark","Chihuahua","Dwarf Crocodile","Chimpanzee","Chinchilla","Chinese Crested Dog","Dolphin", "Donkey","Dragonfly","Drever","Duck","Dunker","Dugong","Dusky Dolphin","Airedale Terrier","Akbash","Akita","Alaskan Malamute","Albatross","Aldabra Giant Tortoise","Alligator","Alpine Dachsbracke","American Bulldog","American Cocker Spaniel","American Coonhound","American Eskimo Dog"]
    }
    
    private lazy var tableview: UITableView = {
        let temp = UITableView()
        temp.delegate = self
        temp.dataSource = self
        temp.tableFooterView = UIView()
        temp.backgroundColor = UIColor.clear
        temp.showsHorizontalScrollIndicator = false
        temp.showsVerticalScrollIndicator = false
        temp.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.insertSubview(temp, aboveSubview: imageView)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0).isActive = true
        temp.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0).isActive = true
        temp.topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0).isActive = true
        temp.bottomAnchor.constraint(equalTo: indicator.topAnchor, constant: -40.0).isActive = true
        return temp
    }()
    
    private lazy var indicator: UIPageControl = {
        let temp = UIPageControl()
        temp.currentPage = currentPage
        temp.currentPageIndicatorTintColor = UIColor.blue
        temp.pageIndicatorTintColor = UIColor.white
        temp.tintColor = UIColor.clear
        temp.hidesForSinglePage = true
        view.insertSubview(temp, aboveSubview: imageView)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        temp.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        temp.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        return temp
    }()
    
    private lazy var imageView: UIImageView = {
        let temp = UIImageView(image: UIImage(named: "space"))
        temp.alpha = 0.9
        temp.contentMode = .scaleAspectFill
        view.addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        temp.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        temp.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        return temp
    }()
    
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        return UIPanGestureRecognizer(target: self, action: #selector(changePage(_:)))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(panGestureRecognizer)
        cells = mockData.splitToArrays(3)
        indicator.numberOfPages = cells.count
        imageView.isHidden = false
        tableview.reloadData()
    }
    
    private var startPos: CGFloat = 0.0
    @objc private func changePage(_ sender: UIPanGestureRecognizer) {
        guard let direction = sender.direction(view) else { return }
        let minimumDistance: CGFloat = 70.0
        
        if sender.state == .began {
            startPos = abs(sender.translation(in: view).x)
        }
        
        if sender.state == .ended {
            let endPos = abs(sender.translation(in: view).x)
            
            if startPos + endPos > minimumDistance {
                switch direction {
                case .left:
                    if currentPage + 1 <= cells.count - 1 {
                        currentPage += 1
                        tableview.reloadWithAnimation(direction)
                    }
                case .right:
                    if currentPage - 1 >= 0 {
                        currentPage -= 1
                        tableview.reloadWithAnimation(direction)
                    }
                }
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[currentPage].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cells[currentPage][indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
