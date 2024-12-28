//
//  ViewController.swift
//  Quizzer
//
//  Created by parag on 25/12/24.
//

import UIKit


class ViewController: UIViewController {
    var quizzeBrain = QuizeBrain()
    var mainview = MainView()
    var scoreInitialLayout:[NSLayoutConstraint]?
    var scoreCenterLayout:[NSLayoutConstraint]?
    
    var progressWidthConstrainr:NSLayoutConstraint?

    var WINDOW_WIDTH:CGFloat? = nil
   
    

    func onAnswer(type:String){
        let result = quizzeBrain.onAnswer(type)
        
        onStartTimer(result.currentIndex + 1 )
        mainview.score.text = "score: \(quizzeBrain.totalScore)"
        
        if(result.isGameOver){
            mainview.questions.isHidden = true
            onUpdateScoreConstraints(LayouType.CENTER)
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            return;
        }
//        print(result.isGameOver,quizzeBrain.currentIndex)
        onPrepairQuizDashBoard()
    }
    
  
    
    func onStartTimer(_ currentIndex:Int){
        guard let windowSize = WINDOW_WIDTH else {
            return;
        }
        let totalLength = (windowSize - 40)/CGFloat(quizzeBrain.getQuizzListCount())

        let currentProgress = totalLength * CGFloat(currentIndex)
        
        progressWidthConstrainr?.constant = currentProgress

        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func onRestGame(){
        quizzeBrain.onReset()
        mainview.score.text = "score:";
        mainview.questions.isHidden = false
        onStartTimer(0)
        onUpdateScoreConstraints(LayouType.INITIAL)
        onPrepairQuizDashBoard()
    }
    
    func onUpdateScoreConstraints(_ layoutType:LayouType){
        switch layoutType {
        case .CENTER:
            NSLayoutConstraint.deactivate(scoreInitialLayout ?? []);
            NSLayoutConstraint.activate(scoreCenterLayout ?? []);
            self.mainview.score.font = UIFont.systemFont(ofSize: 32)
            break;
        default:
            mainview.score.font = UIFont.systemFont(ofSize: 16)
            NSLayoutConstraint.activate(scoreInitialLayout ?? []);
            NSLayoutConstraint.deactivate(scoreCenterLayout ?? []);
    
        }
    }
    
    func onPrepairQuizDashBoard(){
        //add next question
        mainview.questions.text = quizzeBrain.getNextQuestion()
        //first remove previous arranged view
        mainview.VStack.arrangedSubviews.forEach{$0.removeFromSuperview()}
        switch quizzeBrain.quizeType {
            //add view based on quizee type
        case .MULTIPLE:
            let answers = quizzeBrain.mutipleChoiseQ[quizzeBrain.currentIndex].a
            answers.forEach{ ans in
                mainview.VStack.addArrangedSubview(mainview.Button(title: ans,type:ans,callback:onAnswer))
            }

            break;
        default:
            quizzeBrain.getOptions().forEach{ ans in
                mainview.VStack.addArrangedSubview(mainview.Button(title: ans,type:ans,callback:onAnswer))
            }
           
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WINDOW_WIDTH = view.frame.width
        scoreInitialLayout = [
            mainview.score.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            mainview.score.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20)
        ]
        scoreCenterLayout = [ 
            mainview.score.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainview.score.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier:0.8),
]
        mainview.score.text = "score:";

        view.backgroundColor = UIColor(hex:COLORS.PRIMARY.rawValue)
        
        view.addSubview(mainview.questions);
        view.addSubview(mainview.VStack);
        view.addSubview(mainview.progressBar)
        view.addSubview(mainview.score);
        view.addSubview(mainview.resetGame)
        mainview.resetGame.translatesAutoresizingMaskIntoConstraints = false
        mainview.resetGame.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true;
        mainview.resetGame.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20).isActive = true
        mainview.resetGame.setTitle("Reset Game!", for: .normal)
      
        mainview.resetGame.addAction(UIAction {[weak self] _ in
            self?.onRestGame()
        }, for: .touchUpInside)
        mainview.score.translatesAutoresizingMaskIntoConstraints = false
        mainview.questions.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            mainview.questions.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier:0.4),
            mainview.questions.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainview.questions.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainview.questions.topAnchor.constraint(equalTo: mainview.score.bottomAnchor),
            mainview.questions.bottomAnchor.constraint(equalTo: mainview.VStack.topAnchor)
        ])
     
        NSLayoutConstraint.activate(scoreInitialLayout ?? [])
        
        NSLayoutConstraint.activate([
            mainview.VStack.widthAnchor.constraint(equalToConstant: view.frame.width - 20),
            mainview.VStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            mainview.VStack.centerYAnchor.constraint(equalTo: view.bottomAnchor,constant: 0),
//            mainview.VStack.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.4),
            mainview.VStack.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -60)
        ])
           
        mainview.score.textColor = .white
        mainview.questions.numberOfLines = 0
        mainview.questions.textColor = .white
        mainview.questions.textAlignment = .center
    
     
       
        mainview.progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true;
   
        mainview.progressBar.centerYAnchor.constraint(equalTo: mainview.VStack.bottomAnchor,constant: 20).isActive = true
        
        progressWidthConstrainr =  mainview.progressBar.widthAnchor.constraint(equalToConstant:0)
        progressWidthConstrainr?.isActive = true
        
        onPrepairQuizDashBoard()
    }

}



extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}


#Preview {
    ViewController()
}

