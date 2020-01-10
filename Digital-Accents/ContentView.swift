//
//  ContentView.swift
//  Digital-Accents
//
//  Created by Andrew on 07.01.20.
//  Copyright © 2020 Smalli. All rights reserved.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    
    @State var message: String = ""
    

    
    let languages: [[String]] = [
        ["en-GB", "en-US", "ar-AE"],
        ["fr-FR", "fr-CA", "pl-PL"],
        ["de-DE", "fa-IR", "he-IL"],
        ["it-IT", "es-MX", "es-ES"],
        ["sv-SE", "hi-IN", "tr-TR"],
        ["ja-JP", "el-GR", "ru-RU"]
    ]
    
    @State private var languageSelection = "en-GB"
    
    @State var keyboardOffset : CGFloat = 0
    
    @State var showSpeechRateSlider = true
    @State var speechRate: Float = 0.5
    @State var speechPitch: Float = 1.0
    @State var showingLanguageSelection: Bool = false
    @State var speakButtonPressed: Bool = false
    
    
    var speechRatePercentageString : String {
        String(format: "%2f", Double(speechRate * 100))
    }
    var stats: String {
        return String("""
            Current selection:\n\(languageSelection.uppercased())
            Rate of Speaking:\n \(speechRatePercentageString)
            """)
    }
    
    let keyboard = KeyboardResponder()
    
    var body: some View {
        VStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue, Color.red]), startPoint: .top, endPoint: .bottom)
                VStack {
                    HStack {
                        VStack {
                            Text(stats)
                                .accessibility(label: Text("\(stats)"))
                        }.font(.system(size: 10, weight: Font.Weight.medium, design: Font.Design.monospaced))
                        
                        Text("Select Language and Dialect")
                            .bold()
                            .font(.system(size: 30, weight: .ultraLight, design: .monospaced))
                            .padding()
                            .border(Color.blue, width: 1)
                            .padding()
                            .accessibility(label: Text("Select Language and Dialect Button"))
                            .onTapGesture {
                                self.showingLanguageSelection = true
                        }
                        .sheet(isPresented: self.$showingLanguageSelection) {
                            ScrollView(.vertical, showsIndicators: true) {
                                VStack(spacing: 10) {
                                    HStack {
                                        Text("Current selection:\n\(self.languageSelection.uppercased())")
                                            .font(.system(size: 10, weight: Font.Weight.medium, design: Font.Design.monospaced))
                                            .padding()
                                            .accessibility(label: Text("Current language is \(self.languageSelection)"))
                                        Spacer()
                                        Button(action: {
                                            self.showingLanguageSelection = false
                                        }) {
                                            Text("Done").padding()
                                        }.accessibility(label: Text("Done"))
                                    }
                                    ForEach(self.languages, id: \.self) { row in
                                        HStack(spacing:10) {
                                            ForEach(row, id: \.self) { button in
                                                Button(action: {
                                                    self.languageSelection = button
                                                }) {
                                                    Text(button)
                                                        .padding()
                                                        .frame(width: 100, height: 40)
                                                        .foregroundColor(Color.white)
                                                        .background(Color.black)
                                                        .cornerRadius(30)
                                                    
                                                    
                                                }.accessibility(label: Text(button))
                                            }
                                        }
                                    }
                                    .padding()
                                    .accessibility(label: Text("Language Collection"))
                                    
                                    if self.showSpeechRateSlider {
                                        Text("Rate of speech")
                                        Slider(value: self.$speechRate, in: 0...1, step: 0.01).padding(.horizontal).accessibility(label: Text("Rate of speech"))
                                        Text("Pitch")
                                        Slider(value: self.$speechPitch, in: 0.5...2, step: 0.01).padding(.horizontal).accessibility(label: Text("Pitch"))
                                    }
                                    
                                }
                                .frame(width: UIScreen.main.bounds.width)
                            }
                        }
                    }
                    Spacer()
                    
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack (spacing: 10){
                            
                            Text(message)
                                .padding()
                                .lineLimit(nil)
                                .font(.custom("PT Mono", size: 20))
                                .background(Color.clear)
                                .padding()
                                .frame(width: UIScreen.main.bounds.width - 40)
                                .accessibility(label: Text("A label containing your text, where it is written — \"\(message)\""))
                            
                            HStack {
                                TextField("Write here", text: $message)
                                    .padding()
                                    .background(Color.purple)
                                    .foregroundColor(Color.black)
                                    .animation(.default)
                                    .keyboardType(.asciiCapable)
                                    .cornerRadius(10)
                                    .padding([.leading, .vertical], 10)
                                    .accessibility(label: Text("Text input field"))
                                
                                Button(action: {
                                    self.message = ""
                                }) {
                                    Image(systemName: "xmark.square")
                                        .foregroundColor(Color.red)
                                        .font(.largeTitle)
                                }
                                .padding(.trailing, 5)
                                .accessibility(label: Text("Clear input field"))
                                
                            }
                            
                            Button(action: {
                                self.speak(text: self.message, language: self.languageSelection, rate: self.speechRate, pitch: self.speechPitch)
                                self.speakButtonPressed = true
                            }) {
                                Text("Speak")
                                    .padding()
                                    .background(Color.pink)
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 30, weight: .thin, design: .serif))
                                    .cornerRadius(10)
                                    .accessibility(label: Text("\"Speak\""))
                                }
                            .shadow(radius: 3)
                        }
                        .padding(.bottom, keyboard.currentHeight)
                        .animation(.easeOut)
                    }
                }
            }
        }
        
    }
  
    func speak(text: String, language: String, rate: Float = 0.5, pitch: Float = 0.5) {
        var textToSay = text
        if textToSay.count <= 0 {
            textToSay = "Digital Dialectics."
        }
        let utterance = AVSpeechUtterance(string: textToSay)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = rate
        utterance.pitchMultiplier = pitch
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

