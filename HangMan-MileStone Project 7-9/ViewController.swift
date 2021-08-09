//
//  ViewController.swift
//  HangMan-MileStone Project 7-9
//
//  Created by Igor Polousov on 06.08.2021.
//

import UIKit

class ViewController: UIViewController {
    
    var allWords = [String]() // Массив куда будут записаны слова из текстового файла
    var allClues = [String]()
    var lettersInWord = [String]() // Массив с буквами в слове
    var usedLettersArray = [String]() // Массив с использованными буквами
    var promptWord = ""
    var word = ""
    var clue = ""

    @IBOutlet var wordLabel: UILabel! // Переменная куда будет записываться слово из массива слов
    @IBOutlet var promptLabel: UILabel! // Переменная куда будет записан текст подсказки
    @IBOutlet var scoreLabel: UILabel!  // Переменная где будут записаны очки
    @IBOutlet var usedLettersLabel: UILabel! // Переменная просто текст над полем с использованными буквами
    @IBOutlet var usedLetters: UILabel! // Переменная куда будут попадать использованные буквы
    @IBOutlet var gameRules: UILabel!  // Правила игры на экране
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        usedLetters.text = "Here you'll see used letters"
        usedLettersLabel.text = "Letters below are already used"
        gameRules.text = " Правила Игры.\n Случайным образом из списка.\n слов выбирается слово"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add letter", style: .plain, target: self, action: #selector(addLetter))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(newGame))
        
        scoreLabel.text = "Score: \(score)"
        
        loadLevel()
        
        
        
    }
    
    // Добавление слов из файла
    
    func loadLevel() {
        if let wordsProjectURL = Bundle.main.url(forResource: "wordsProject7-9", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: wordsProjectURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                for line in lines {
                    let parts = line.components(separatedBy: ":")
                    let word = parts[0]
                    let clue = parts[1]
                    allWords.append(word)
                    allClues.append(clue)
                }
                word = allWords[0]
                clue = allClues[0]
                for letter in word {
                    let strLetter = String(letter)
                    lettersInWord.append(strLetter)
                }
                print(lettersInWord)
                
                for letter in word {
                    let strLetter = String(letter)
                    
                    if usedLettersArray.contains(strLetter) {
                        promptWord += strLetter
                    } else {
                        promptWord += "?"
                    }
                }
                
                wordLabel.text = promptWord
                promptLabel.text = clue
            }
        }
    }
    
    
    // Пользователь добавляет букву
    @objc func addLetter() {
        let ac = UIAlertController(title: "Add one letter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submitAnswer(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
        
    }
    
    // Отправка на обработку введенной буквы
    @objc func submitAnswer(_ answer: String) {
        let upperAnswer = answer.uppercased()
        if upperAnswer.count > 1 {
            showMassege(errorMasseges: .moreThanOneLetter)
        } else {
            usedLettersArray.append(upperAnswer)
            promptWord = ""
            for letter in word {
                let strLetter = String(letter)
                if usedLettersArray.contains(strLetter) {
                    promptWord += strLetter
                } else {
                    //showError(errorMasseges: .thereIsNoSuchLetter)
                    promptWord += "?"
                }
               
                wordLabel.text = promptWord
                usedLetters.text = usedLettersArray.joined(separator: " ,")
            }
            
            if score <= -6 {
                showMassege(errorMasseges: .youLoose)
                
            } else if !lettersInWord.contains(upperAnswer) {
                showMassege(errorMasseges: .thereIsNoSuchLetter)
                score -= 1
            } else {
                showMassege(errorMasseges: .rightAnswer)
                score += 1
            }
            
        }
        
        print(usedLettersArray)
        print(promptWord)
    }
    
    
    // Начало новой игры
    @objc func newGame() {
        score = 0
        promptWord = ""
        allClues.removeAll()
        allWords.removeAll()
        lettersInWord.removeAll()
        usedLettersArray.removeAll()
        usedLetters.text = ""
        loadLevel()
    }
    
    enum Masseges{
        case moreThanOneLetter
        case thereIsNoSuchLetter
        case rightAnswer
        case youLoose
    }

    func showMassege(errorMasseges: Masseges) {
        var title = ""
        var massege = ""
        
        switch errorMasseges {
        case .moreThanOneLetter:
            title = "Wrong"
            massege = "You should type only one letter(character) at a time"
            
        case .thereIsNoSuchLetter:
            title = "Wrong"
            massege = "There is no such a letter in the word.\n Your score deducted on 1 "
            
        case .rightAnswer:
            title = "Well done"
            massege = "Good one, you score + 1"
            
        case .youLoose:
            title = "You,ve made 7 mistakes.\n Game over"
        }
        
        let ac = UIAlertController(title: "\(title)", message: "\(massege)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }

}


