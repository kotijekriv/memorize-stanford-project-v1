//
//  ContentView.swift
//  Memorize
//
//  Created by Pero Radich on 25.06.2021..
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack{
            VStack{
                Text(viewModel.themeName)
                    .font(.largeTitle)
                    .padding(.bottom)
                
                Text("SCORE: \(viewModel.score)")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            .padding()
            
            Spacer()
            
            ScrollView{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                    }
                }
            }
            .padding(.horizontal)
//            Spacer()
//            HStack{
//                Button("NEW GAME"){
//                    viewModel.newGame()
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .clipShape(Capsule())
//            }
//            .padding()
        }
        .foregroundColor(viewModel.themeColor)
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    var body: some View{
        ZStack{
            let shape = RoundedRectangle(cornerRadius: 20)
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.largeTitle)
            } else if card.isMatched{
                shape.opacity(0)
            } else{
                shape.fill()
            }
        }
    }
}








struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let game = EmojiMemoryGame(theme: ThemeChooser.Theme.init(name: "BlaBLa", emojis: ["😀","🔮"], numberOfPairsOfCards: 2, color: .init(color: .red), id: 1))
            EmojiMemoryGameView(viewModel: game)
                .preferredColorScheme(.light)
            EmojiMemoryGameView(viewModel: game)
                .preferredColorScheme(.dark)
        }
    }
}
