//
//  Extensions.swift
//  WeatherApp
//
//  Created by Shahar Hillel on 9/30/20.
//

import UIKit

extension UIViewController {
    var isDarkMode: Bool {
        if #available(iOS 13.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark
        }
        else {
            return false
        }
    }

}
extension UILabel{
    
    public convenience init(fontSize: CGFloat){
        self.init(frame: .zero)
        font = UIFont.systemFont(ofSize: fontSize)
    }
}
extension UIView {
    
    @discardableResult
    func clicked(_ target: Any?, _ action: Selector?) -> UIView {
           isUserInteractionEnabled = true
           addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
           return self
    }
    
    func activate(_ constraints : [NSLayoutConstraint]){
        
        for constraint in constraints {
            if !subviews.contains(constraint.firstItem as! UIView){
                addSubview(constraint.firstItem as! UIView)
            }
            (constraint.firstItem as! UIView).translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    func width(_ width : CGFloat) -> NSLayoutConstraint{
        let con = widthAnchor.constraint(equalToConstant: width)
        con.identifier = "width"
        return con
    }
    
    func height(_ height : CGFloat) -> NSLayoutConstraint{
        let con = heightAnchor.constraint(equalToConstant: height)
        con.identifier = "height"
        return con
    }
    
    func start(_ startAnchor : NSLayoutXAxisAnchor,_ constant : Int = 0) -> NSLayoutConstraint{
        return self.leadingAnchor.constraint(equalTo:  startAnchor,constant: CGFloat(constant))
    }
    func end(_ endAnchor : NSLayoutXAxisAnchor,_ constant : Int = 0) -> NSLayoutConstraint{
        return self.trailingAnchor.constraint(equalTo:  endAnchor,constant: CGFloat(constant))
    }
    func top(_ topAnchor : NSLayoutYAxisAnchor,_ constant : Int = 0) -> NSLayoutConstraint{
        return self.topAnchor.constraint(equalTo:  topAnchor,constant: CGFloat(constant))
    }
    func bottom(_ bottomAnchor : NSLayoutYAxisAnchor,_ constant : Int = 0) -> NSLayoutConstraint{
        return self.bottomAnchor.constraint(equalTo:  bottomAnchor,constant: CGFloat(constant))
    }
    func centerX(_ view : UIView) -> NSLayoutConstraint{
        return self.centerXAnchor.constraint(equalTo:  view.centerXAnchor)
    }
    func centerY(_ view : UIView) -> NSLayoutConstraint{
        return self.centerYAnchor.constraint(equalTo:  view.centerYAnchor)
    }
}
