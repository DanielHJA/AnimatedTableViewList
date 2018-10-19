//
//  Extensions.swift
//  PaginationTest
//
//  Created by Daniel Hjärtström on 2018-10-19.
//  Copyright © 2018 Sog. All rights reserved.
//

import UIKit

extension Array {
    func splitToArraysOf(_ number: Int) -> [[String]] {
        var counter: Int = 0
        var result = [[String]]()
        var temp = [String]()
        
        while temp.count < number {
            if counter >= self.count {
                if !temp.isEmpty {
                    result.append(temp)
                }
                break
            }
            
            temp.append(self[counter] as! String)
            counter += 1
            
            if temp.count == number {
                result.append(temp)
                temp.removeAll()
            }
        }
        return result
    }
    
    func splitToArrays(_ number: Int) -> [[String]] {
        var counter: Int = 0
        var result = [[String]]()
        var temp = [String]()
        
        while temp.count < self.count / number {
            if counter >= self.count {
                if !temp.isEmpty {
                    result.append(temp)
                }
                break
            }
            
            temp.append(self[counter] as! String)
            counter += 1
            
            if temp.count == self.count / number {
                result.append(temp)
                temp.removeAll()
            }
        }
        return result
    }
}

extension UIPanGestureRecognizer {
    func direction(_ inView: UIView) -> Direction? {
        let detectionLimit: CGFloat = 50
        let vel : CGPoint = velocity(in: inView)
        if vel.x > detectionLimit {
            return .right
        } else if vel.x < -detectionLimit {
            return .left
        }
        return nil
    }
}

enum Direction {
    case left, right
}

extension UITableView {
    func reloadWithAnimation(_ direction: Direction) {
        self.reloadData()
        let visibleCells = self.visibleCells
        
        for cell in visibleCells {
            switch direction {
            case .left:
                cell.transform = CGAffineTransform(translationX: self.frame.width, y: 0)
            case .right:
                cell.transform = CGAffineTransform(translationX: -self.frame.width, y: 0)
            }
        }
        
        for (index, cell) in direction == .left ? visibleCells.enumerated() : visibleCells.reversed().enumerated() {
            UIView.animate(withDuration: 0.5, delay: Double(index) * 0.06, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                cell.transform = .identity
            }, completion: nil)
        }
    }
}
