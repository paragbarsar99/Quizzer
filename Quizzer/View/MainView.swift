//
//  MainView.swift
//  Quizzer
//
//  Created by parag on 27/12/24.
//

import Foundation
import UIKit

class MainView {
    
    var container = UIView();
    
    var questions = UILabel();
    var score = UILabel();
    var resetGame = UIButton()
    func Button(title:String,type:String,callback: @escaping (_ type:String) -> Void) -> UIButton{
        let btn = UIButton()
        
        btn.layer.borderWidth = 2;
        btn.layer.cornerRadius = 10
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.contentMode = .scaleAspectFit
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true;
        btn.addAction(UIAction {_ in
            callback(type)
        } , for: .touchUpInside)
        return btn
    }
    
    let VStack:UIStackView = {
        let stack = UIStackView();
        stack.axis = .vertical;
        stack.spacing = 10
        stack.distribution = .fill
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var progressBar:UIView = {
        var view = UIView();
        view.translatesAutoresizingMaskIntoConstraints = false;
        view.heightAnchor.constraint(equalToConstant: 10).isActive = true;
        view.backgroundColor = .yellow;
        view.layer.cornerRadius = 6
        return view
    }()
    
    
    
}
