//
//  File.swift
//  deneme
//
//  Created by samet kaya on 3.12.2024.
//

import Foundation
import UIKit
import CoreData
import AVFoundation

class RandomViewController: UIViewController {

    @IBOutlet weak var exampleLabel: UILabel!
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    @IBOutlet weak var ViewBacg: UIView!
    @IBOutlet weak var audioImage: UIImageView!
    @IBOutlet weak var buttonOutlet: UIButton!
    var wrongAnswersArray: [String] = []
    var currentWord: (ingilizce: String, turkce: String)?
    var options: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        loadNewWord()
        buttonOutletDizayn()
    }

    func setupUI() {
        ViewBacg.layer.cornerRadius = 10

        let configuration = UIImage.SymbolConfiguration(pointSize: 3, weight: .medium, scale: .small)
        audioImage.image = UIImage(systemName: "speaker.wave.3.fill", withConfiguration: configuration)
        audioImage.tintColor = UIColor(named:"Color6")
        audioImage.isUserInteractionEnabled = true

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(audioImageTapped))
        audioImage.addGestureRecognizer(recognizer)
    }

    func loadNewWord() {
        guard let randomWordExample = RandomExampleModel.shared.fetcWords().randomElement() else { return }

        currentWord = (randomWordExample.ingilizce, randomWordExample.turkce)
        exampleLabel.text = currentWord?.ingilizce

        prepareOptions(correctAnswer: randomWordExample.turkce)
        updateButtons()
    }

    func prepareOptions(correctAnswer: String) {
        var choices = [correctAnswer]
        let wrongAnswers = RandomExampleChicModel.shared.fetcWords()
            .filter { $0 != correctAnswer }
            .shuffled()
            .prefix(3)

        choices.append(contentsOf: wrongAnswers)
        options = choices.shuffled()
    }

    func updateButtons() {
        let buttons = [buttonA, buttonB, buttonC, buttonD]

        for (index, button) in buttons.enumerated() {
            button?.setTitle(options[index], for: .normal)
            button?.tintColor = UIColor(named: "Color6")
            button?.backgroundColor = .clear
            button?.layer.cornerRadius = 10
            button?.layer.masksToBounds = true
            
            button?.removeTarget(nil, action: nil, for: .allEvents) // Eski aksiyonları temizle
            button?.addAction(UIAction(handler: { [weak self] _ in
                self?.handleButtonTap(selectedOption: self?.options[index] ?? "", button: button)
            }), for: .touchUpInside)
        }
    }

    func handleButtonTap(selectedOption: String, button: UIButton?) {
        guard let currentWord = currentWord else { return }

        if selectedOption == currentWord.turkce {
            button?.backgroundColor = .green
           
            
        } else {
            button?.backgroundColor = .red
            saveWrongAnswer(word: currentWord.ingilizce)
            saveWrongTurkhisAnswer(wordTurkhis: currentWord.turkce)
        }
    }
func saveWrongTurkhisAnswer(wordTurkhis: String) {
    let turkhisWords = CoreDataManager.shared.fetchWords(entityName: "Deneme", key: "wrongWordTurkce")
    
    if !turkhisWords.contains(wordTurkhis) {
        wrongAnswersArray.append(wordTurkhis)
        CoreDataManager.shared.saveWord(word: wordTurkhis, entityName: "Deneme", key: "wrongWordTurkce")
        print("Kaydedilen kelime: \(wordTurkhis)")
    }
    else {
             print("keliye zaten kayıtlı: \(wordTurkhis)")
         }
        
    
    }
    func saveWrongAnswer(word: String) {
        let existingWords = CoreDataManager.shared.fetchWords(entityName: "Deneme", key: "wrongWord")

        if !existingWords.contains(word) {
            wrongAnswersArray.append(word)
            CoreDataManager.shared.saveWord(word: word, entityName: "Deneme", key: "wrongWord")
            print("Kaydedilen kelime: \(word)")
          
        } else {
            print("Kelime zaten kayıtlı: \(word)")
        }
    }

    @IBAction func refresClick(_ sender: Any) {
        wrongAnswersArray.removeAll(keepingCapacity: false)
        loadNewWord()
    }

    @objc func audioImageTapped() {
        guard let word = exampleLabel.text else { return }//
        AudioModel.shared.playPronunciation(word: word)
        print("basıldı")
    }
    func buttonOutletDizayn() {
        buttonOutlet.layer.cornerRadius = 10
        
    }
}
