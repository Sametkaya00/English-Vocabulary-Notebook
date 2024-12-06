//
//  AudioModel.swift
//  ingilizceKelime
//
//  Created by samet kaya on 29.11.2024.
//

import Foundation
import AVFoundation

class AudioModel{
    static let shared = AudioModel()
    func playPronunciation(word:String){
        let syntheiszer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        syntheiszer.speak(utterance)
    }
}
