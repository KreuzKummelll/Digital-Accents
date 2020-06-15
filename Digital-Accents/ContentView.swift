//
//  ContentView.swift
//  Digital-Accents
//
//  Created by Andrew on 07.01.20.
//  Copyright © 2020 Smalli. All rights reserved.
//

import SwiftUI
import AVFoundation


enum Languages: String {
    case enGB = "en-GB", enUS = "en-US"
    case arAE = "ar-AE"
    case frFR = "fr-FR", frCA = "fr-CA"
    case plPL = "pl-PL"
    case deDE = "de-DE"
    case koKR = "ko-KR"
    case heIL = "he-IL"
    case itIT = "it-IT"
    case esMX = "es-MX", esES = "es-ES"
    case svSE = "sv-SE"
    case hiIN = "hi-IN"
    case trTR = "tr-TR"
    case jaJP = "ja-JP"
    case elGR = "el-GR"
    case ruRU = "ru-RU"
    
    var fullLanguageName : String {
        switch self {
        case .arAE: return "Arabic"
        case .deDE: return "German"
        case .elGR: return "Greek"
        case .enGB: return "English (Great Britain)"
        case .enUS: return "English (United States)"
        case .esES: return "Spanish (Spain)"
        case .esMX: return "Spanish (Mexico)"
        case .koKR: return "Korean"
        case .frCA: return "French (Canada)"
        case .frFR: return "French (France)"
        case .heIL: return "Hebrew"
        case .hiIN: return "Hindi"
        case .itIT: return "Italian"
        case .jaJP: return "Japanese"
        case .plPL: return "Polish"
        case .ruRU: return "Russian (Russia)"
        case .svSE: return "Swedish"
        case .trTR: return "Turkish"
            
        }
    }
}

struct ContentView: View {
    
    
    @State var message: String = ""
    
    
    
    let languages: [[Languages]] = [
        [.enGB, .enUS, .arAE],
        [.frFR, .frCA, .plPL],
        [.deDE, .koKR, .heIL],
        [.itIT, .esMX, .esES],
        [.svSE, .hiIN, .trTR],
        [.jaJP, .elGR, .ruRU]
    ]
    
    
    
    @State private var languageSelection : Languages = .enGB
    
    @State var keyboardOffset : CGFloat = 0
    
    @State var showSpeechRateSlider = true
    @State var speechRate: Float = 0.5
    @State var speechPitch: Float = 1.0
    @State var showingLanguageSelection: Bool = false
    @State var speakButtonPressed: Bool = false
    
    
    var speechRatePercentageString : String {
        String(format: "%.0f", Double(speechRate * 100))
    }
    
    var stats: String {
        return String("""
            Current selection:\n\(languageSelection.fullLanguageName.capitalized)
            Rate of Speaking:\n % \(speechRatePercentageString)
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
                                .font(.system(size: 17, weight: .thin, design: .monospaced))
                                .accessibility(label: Text("""
                                    Current selection:\n\(languageSelection.fullLanguageName.capitalized)
                                    Rate of Speaking:\n \(speechRatePercentageString) %
                                    """))
                                .padding(.leading, 5)
                        }.font(.system(size: 10, weight: Font.Weight.medium, design: Font.Design.monospaced))
                        
                        Text("Select Language and Dialect")
                            .font(.system(size: 17, weight: .ultraLight, design: .monospaced))
                            .padding()
                            .border(Color.blue, width: 1)
                            .padding()
                            .accessibility(label: Text("Select Language and Dialect"))
                            .accessibility(addTraits: .isButton)
                            .onTapGesture {
                                self.showingLanguageSelection = true
                        }
                        .sheet(isPresented: self.$showingLanguageSelection) {
                            ScrollView(.vertical, showsIndicators: true) {
                                VStack(spacing: 10) {
                                    HStack {
                                        Text("Current selection:\n\(self.languageSelection.fullLanguageName.uppercased())")
                                            .font(.system(size: 17, weight: Font.Weight.medium, design: Font.Design.monospaced))
                                            .padding()
                                            .accessibility(label: Text("Current language is \(self.languageSelection.fullLanguageName)"))
                                        Spacer()
                                        Button(action: {
                                            self.showingLanguageSelection = false
                                        }) {
                                            Text("Done").padding()
                                        }.accessibility(label: Text("Done"))
                                    }
                                    if self.showSpeechRateSlider {
                                        Text("Rate of speech")
                                        Slider(value: self.$speechRate, in: 0...1, step: 0.01).padding(.horizontal).accessibility(label: Text("Rate of speech"))
                                        
                                        Text("Pitch")
                                        Slider(value: self.$speechPitch, in: 0.5...2, step: 0.01)
                                            .padding(.horizontal).accessibility(label: Text("Pitch"))
                                            
                                           
                                    }
                                    ForEach(self.languages, id: \.self) { row in
                                        HStack(spacing: 10) {
                                            ForEach(row, id: \.self) { button in
                                                Button(action: {
                                                    self.languageSelection = button
                                                }) {
                                                    Text(button.fullLanguageName)
                                                        .padding()
                                                        .frame(width: 100, height: 40)
                                                        .foregroundColor(Color.white)
                                                        .background(Color.black)
                                                        .cornerRadius(30)
                                                    
                                                    
                                                }.accessibility(label: Text(button.fullLanguageName))
                                            }
                                        }
                                    }
                                    .padding(.all, 5)
                                    
                                    
                                }
                                .frame(width: UIScreen.main.bounds.width)
                                
                            }.padding(.bottom, 20)
                        }
                    }.padding(.top, 40)
                    
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
                                TextField("", text: $message)
                                    .padding()
                                    .background(Color.purple)
                                    .foregroundColor(Color.black)
                                    .animation(.default)
                                    .keyboardType(.asciiCapable)
                                    .cornerRadius(10)
                                    .padding([.leading, .vertical], 10)
//                                    .accessibility(label: Text("Text input field"))
                                
                                Button(action: {
                                    self.message = ""
                                }) {
                                    Image(systemName: "xmark.square")
                                        .foregroundColor(Color.red)
                                        .font(.largeTitle)
                                        .padding(5)
                                }
                                
                                .accessibility(label: Text("Clear input field"))
                                
                            }
                            
                            Button(action: {
                                self.speak(text: self.message, language: self.languageSelection, rate: self.speechRate, pitch: self.speechPitch)
                                self.speakButtonPressed = true
                            }) {
                                Text("Speak")
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 30, weight: .thin, design: .serif))
                                    .cornerRadius(10)
                                    .padding()
                                    .accessibility(hint: Text("Tap this to speak"))
                                
                            }
                            .shadow(radius: 3)
                        }
                        .padding(.bottom, keyboard.currentHeight)
                        .animation(.easeOut)
                    }
                }
            }
            .edgesIgnoringSafeArea(.vertical)
        }
        
    }
    
    func speak(text: String, language: Languages, rate: Float = 0.5, pitch: Float = 0.5) {
        var textToSay = text
        if textToSay.count <= 0 {
            textToSay = "Digital Dialectics."
        }
        let utterance = AVSpeechUtterance(string: textToSay)
        utterance.voice = AVSpeechSynthesisVoice(language: language.rawValue)
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

