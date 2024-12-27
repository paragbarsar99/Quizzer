//
//  ViewController.swift
//  Quizzer
//
//  Created by parag on 25/12/24.
//

import UIKit


protocol ANSWERS  {
    var TRUE:Bool {get};
    var FALSE:Bool {get};

}

struct Question {
    let q:String;
    let a:Bool;
}

enum LayouType {
    case INITIAL
    case CENTER
}
    
class ViewController: UIViewController {
    var scoreInitialLayout:[NSLayoutConstraint]?
    var scoreCenterLayout:[NSLayoutConstraint]?

    var progressWidthConstrainr:NSLayoutConstraint?
    var isGameOver = false
    var currentIndex = 0
    var totalScore = 0
    var WINDOW_WIDTH:CGFloat? = nil
    let quizeList: [Question] = [
        Question(q: "A slug's blood is green.", a: true),
        Question(q: "Approximately one quarter of human bones are in the feet.", a: true),
        Question(q: "The total surface area of two human lungs is approximately 70 square metres.", a: true),
        Question(q: "In West Virginia, USA, if you accidentally hit an animal with your car, you are free to take it home to eat.", a: true),
        Question(q: "In London, UK, if you happen to die in the House of Parliament, you are technically entitled to a state funeral, because the building is considered too sacred a place.", a: false),
        Question(q: "It is illegal to pee in the Ocean in Portugal.", a: true),
        Question(q: "You can lead a cow down stairs but not up stairs.", a: false),
        Question(q: "Google was originally called 'Backrub'.", a: true),
        Question(q: "Buzz Aldrin's mother's maiden name was 'Moon'.", a: true),
        Question(q: "The loudest sound produced by any animal is 188 decibels. That animal is the African Elephant.", a: false),
        Question(q: "No piece of square dry paper can be folded in half more than 7 times.", a: false),
        Question(q: "Chocolate affects a dog's heart and nervous system; a few ounces are enough to kill a small dog.", a: true)
    ]
    
    
    var container = UIView();
    
    var questions = UILabel();
    var score = UILabel();
    var resetGame = UIButton()
    func Button(title:String,type:Bool) -> UIButton{
        let btn = UIButton()

        btn.layer.borderWidth = 2;
        btn.layer.cornerRadius = 10

        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.contentMode = .scaleAspectFit
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true;
        btn.addAction(UIAction {_ in
            self.onAnswer(type: type)
        } , for: .touchUpInside)
        return btn
    }
 
    let VStack:UIStackView = {
        let stack = UIStackView();
        stack.axis = .vertical;
        stack.spacing = 10
        
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
    
    
    func onAnswer(type:Bool){
        if(isGameOver == true) {
            return;
        }
   
        if(currentIndex == quizeList.count - 1){
            onStartTimer(currentIndex + 1)
            calScore(ans:type)
            isGameOver = true
            questions.isHidden = true
            
            onUpdateScoreConstraints(LayouType.CENTER)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            return;
        }
        onStartTimer(currentIndex + 1)
        calScore(ans:type)
        currentIndex += 1
        questions.text = quizeList[currentIndex].q
 
      
    }
    
    func calScore(ans:Bool){
        if(ans == quizeList[currentIndex].a){
            totalScore += 1
            score.text = "score: \(totalScore)"
        }
 
    }
    
    func onStartTimer(_ currentIndex:Int){
        guard let windowSize = WINDOW_WIDTH else {
            return;
        }
        let totalLength = (windowSize - 40)/CGFloat(quizeList.count)
        print( totalLength * CGFloat(currentIndex),windowSize,currentIndex)
        let currentProgress = totalLength * CGFloat(currentIndex)
        
        progressWidthConstrainr?.constant = currentProgress

        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }){ finished in
            if finished {
         
                
            }
        }
    }
    func onRestGame(){
        isGameOver = false;
        currentIndex = 0;
        totalScore = 0
        score.text = "score:";
        questions.text = quizeList[currentIndex].q;
        questions.isHidden = false
        onStartTimer(0)
        onUpdateScoreConstraints(LayouType.INITIAL)
     
       
    }
    
    func onUpdateScoreConstraints(_ layoutType:LayouType){
        
        switch layoutType {
        case .CENTER:
            NSLayoutConstraint.deactivate(scoreInitialLayout ?? []);
            NSLayoutConstraint.activate(scoreCenterLayout ?? []);
            self.score.font = UIFont.systemFont(ofSize: 32)
            break;
        default:
            score.font = UIFont.systemFont(ofSize: 16)
            NSLayoutConstraint.activate(scoreInitialLayout ?? []);
            NSLayoutConstraint.deactivate(scoreCenterLayout ?? []);
         

        }
        
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        WINDOW_WIDTH = view.frame.width
        scoreInitialLayout = [
            score.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            score.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20)
        ]
        scoreCenterLayout = [ 
            score.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            score.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier:0.8),
]
        score.text = "score:";

        view.backgroundColor = UIColor(hex:"#4B0082")
        
        view.addSubview(questions);
        view.addSubview(VStack);
        view.addSubview(progressBar)
        view.addSubview(score);
        view.addSubview(resetGame)
        resetGame.translatesAutoresizingMaskIntoConstraints = false
        resetGame.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true;
        resetGame.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20).isActive = true
        resetGame.setTitle("Reset Game!", for: .normal)
      
        resetGame.addAction(UIAction {[weak self] _ in
            self?.onRestGame()
        }, for: .touchUpInside)
        score.translatesAutoresizingMaskIntoConstraints = false
        questions.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            questions.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier:0.8),
            questions.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            questions.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
     
        NSLayoutConstraint.activate(scoreInitialLayout ?? [])
      
        score.textColor = .white
        questions.numberOfLines = 0
        questions.textColor = .white
        questions.textAlignment = .center
        questions.text = quizeList[0].q
        
        NSLayoutConstraint.activate([
            VStack.widthAnchor.constraint(equalToConstant: view.frame.width - 20),
            VStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            VStack.centerYAnchor.constraint(equalTo: questions.bottomAnchor)
        ])

        VStack.addArrangedSubview(Button(title:"True" , type: true))
        VStack.addArrangedSubview(Button(title:"False" , type: false))
     
        progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true;
   
        progressBar.centerYAnchor.constraint(equalTo: view.bottomAnchor,constant: -50).isActive = true
        
        progressWidthConstrainr =  progressBar.widthAnchor.constraint(equalToConstant:0)
        progressWidthConstrainr?.isActive = true
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

