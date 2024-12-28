//
//  QuizBrain.swift
//  Quizzer
//
//  Created by parag on 27/12/24.
//

import Foundation

enum ResultType {
    case QUIZETYPE(QUIZETYPE)
    case MutipleChoice(MutipleChoice)
}

struct QuizeBrain  {
    var quizeType:QUIZETYPE = QUIZETYPE.MULTIPLE
    let quizeList:[Question] = [ Question(q: "A slug's blood is green.", a: "true"),
      Question(q: "Approximately one quarter of human bones are in the feet.", a: "true"),
     Question(q: "The total surface area of two human lungs is approximately 70 square metres.", a: "true"),
     Question(q: "In West Virginia, USA, if you accidentally hit an animal with your car, you are free to take it home to eat.", a: "true"),
     Question(q: "In London, UK, if you happen to die in the House of Parliament, you are technically entitled to a state funeral, because the building is considered too sacred a place.", a: "false"),
    Question(q: "It is illegal to pee in the Ocean in Portugal.", a: "true"),
    Question(q: "You can lead a cow down stairs but not up stairs.", a: "false"),
    Question(q: "Google was origi̛nally called 'Backrub'.", a: "true"),
    Question(q: "Buzz Aldrin's mother's maiden name was 'Moon'.", a: "true"),
    Question(q: "The loudest sound produced by any animal is 188 decibels. That animal is the African Elephant.", a: "false"),
    Question(q: "No piece of square dry paper can be folded in half more than 7 times.", a: "false"),
    Question(q: "Chocolate affects a dog's heart and nervous system; a few ounces are enough to kill a small dog.", a: "true")
    ]
    
    let mutipleChoiseQ:[MutipleChoice] = [
        MutipleChoice(q: "Which is the largest organ in the human body?", a: ["Heart", "Skin", "Large Intestine", "Brain"], correctAnswer: "Skin"),
        MutipleChoice(q: "Five dollars is worth how many nickels?", a: ["25", "50", "100"], correctAnswer: "100"),
        MutipleChoice(q: "What do the letters in the GMT time zone stand for?", a: ["Global Meridian Time", "Greenwich Mean Time", "General Median Time"], correctAnswer: "Greenwich Mean Time"),
        MutipleChoice(q: "What is the French word for 'hat'?", a: ["Chapeau", "Écharpe", "Bonnet"], correctAnswer: "Chapeau"),
        MutipleChoice(q: "In past times, what would a gentleman keep in his fob pocket?", a: ["Notebook", "Handkerchief", "Watch","Nothing"], correctAnswer: "Watch"),
        MutipleChoice(q: "How would one say goodbye in Spanish?", a: ["Au Revoir", "Adiós", "Salir"], correctAnswer: "Adiós"),
        MutipleChoice(q: "Which of these colours is NOT featured in the logo for Google?", a: ["Green", "Orange", "Blue","Red"], correctAnswer: "Orange"),
        MutipleChoice(q: "What alcoholic drink is made from molasses?", a: ["Rum", "Whisky", "Gin","Vodka"], correctAnswer: "Rum"),
        MutipleChoice(q: "What type of animal was Harambe?", a: ["Panda", "Gorilla", "Crocodile",], correctAnswer: "Gorilla"),
        MutipleChoice(q: "Where is Tasmania located?", a: ["Indonesia", "Australia", "Scotland"], correctAnswer: "Australia")
    ]
    var currentIndex = 0
    var totalScore = 0
    var isGameOver = false
    
   mutating func checkAnswer(_ ans:String){
       let haptic = Utils()
       //check if the quize type
       if(quizeType == .MULTIPLE){
           if(ans == mutipleChoiseQ[currentIndex].correctAnswer){
               totalScore += 1
               haptic.triggerImpactFeeback(style: .light)
           }
           haptic.triggerImpactFeeback(style: .heavy)
           return;
       }
        if(ans == quizeList[currentIndex].a){
            totalScore += 1
            haptic.triggerImpactFeeback(style: .light)
        }
        haptic.triggerImpactFeeback(style: .heavy)
      
    }
    
    mutating func onReset(){
        isGameOver = false;
        currentIndex = 0;
        totalScore = 0
    }
    
    func getNextQuestion() -> String {
//        print(currentIndex, " currentIndex")
        switch quizeType {
        case .SINGLE:
     
            return quizeList[currentIndex].q
        case .MULTIPLE:
            return mutipleChoiseQ[currentIndex].q
        }

    }
    
    mutating func pickQuizeType(_ type:QUIZETYPE){
        switch type {
        case .MULTIPLE:
            quizeType = QUIZETYPE.MULTIPLE
            break;
        default:
            quizeType = QUIZETYPE.SINGLE
        }
    }
    
    func getOptions() -> [String]{
        switch quizeType{
        case .SINGLE:
            return ["true","false"]
        default:
            let a = mutipleChoiseQ[currentIndex].a;
            return a
        }
        
    }
    
    func getQuizzListCount() -> Int {
        switch quizeType {
        case .SINGLE:
            return quizeList.count;
        case .MULTIPLE:
           return mutipleChoiseQ.count
        }
    }
    
    //return updated question index
    mutating func onAnswer(_ ans:String) -> (isGameOver:Bool,currentIndex:Int){
        if(isGameOver){
            return (isGameOver,currentIndex)
        }
        if(currentIndex == getQuizzListCount() - 1){
            isGameOver = true;
            checkAnswer(ans)
            return (isGameOver,currentIndex)
        }
        checkAnswer(ans)
        currentIndex += 1
        return (isGameOver,currentIndex)
    }
}
