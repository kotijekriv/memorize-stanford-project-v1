//
//  ThemeChooser.swift
//  Memorize
//
//  Created by Pero Radich on 27.08.2021..
//

import SwiftUI

class ThemeChooserStore: ObservableObject {
    let name: String
    
    @Published var themes = [ThemeChooser.Theme](){
        didSet{
            storeInUserDefaults()
        }
    }
    
    
    private var userDefaultsKey: String {
        "ThemeStore: " + name
    }
    
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(themes), forKey: userDefaultsKey)
    }
    
    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedThemes = try? JSONDecoder().decode(Array<ThemeChooser.Theme>.self, from: jsonData) {
            themes = decodedThemes
        }
    }
    
    init(named name: String) {
        self.name = name
        restoreFromUserDefaults()
        
        if themes.isEmpty {
            print("using built-in themes")
            insertTheme(named: "Transport", emojis: ["🚗", "🚕", "🏎", "🚑", "🚜", "✈️", "🛸", "🚀"], numberOfPairsOfCards: 5, color: .yellow)
            insertTheme(named: "Nature", emojis: ["🐶", "🐢", "🦑", "🐬", "🐛", "🦄", "🦅", "🐧", "🦆", "🐥"], numberOfPairsOfCards: 5, color: .green)
            insertTheme(named: "Tech", emojis: ["⌚️", "📱", "💻", "⌨️", "🖥", "🖨", "🖱", "🖲", "🕹", "💾", "💿", "📷"], numberOfPairsOfCards: 6, color: .gray)
            insertTheme(named: "Faces", emojis: ["😀", "🥳", "🥸", "😍", "😇", "🤗", "😡", "🤯", "😈", "🤡", "🥶"], numberOfPairsOfCards: 7, color: .pink)
            insertTheme(named: "Tools", emojis: ["🪛", "🔧", "🔨", "🛠", "⛏", "🪚", "🔩", "🧲", "🪤"], numberOfPairsOfCards: 6, color: .purple)
            insertTheme(named: "Weapons", emojis: ["🔫", "💣", "🧨", "🪓", "🔪", "🗡", "⚔️", "🛡", "🚬", "⚰️", "🔮", "⚱️"], numberOfPairsOfCards: 5, color: .orange)
        } else {
            print("successfully loaded themes from UserDefaults: \(themes)")
        }
        
    }
    
    
    // MARK: -Intent
    
    func insertTheme(named name: String, emojis: [String]? = nil, numberOfPairsOfCards: Int, color: Color, at index: Int = 0){
        let unique = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
        let chosenColor = RGBAColor(color: color)
        let theme = ThemeChooser.Theme(name: name, emojis: emojis ?? [""], numberOfPairsOfCards: numberOfPairsOfCards, color: chosenColor, id: unique)
        let safeIndex = min(max(index, 0), themes.count)
        themes.insert(theme, at: safeIndex)
    }
    
    @discardableResult
    func removeTheme(at index: Int) -> Int{
        if themes.count > 1, themes.indices.contains(index) {
            themes.remove(at: index)
        }
        return index % themes.count
    }
}
