//
//  GameView.swift
//  Tic-Tac-Toe
//
//  Created by ANDREY VORONTSOV on 24.03.2023.
//

import SwiftUI



struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack {
                            GameSquareView(geometryProxy: geometry)
                            PlayerIndicatorView(systemImageName: viewModel.moves[i]?.indicator ?? "")
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i)
                        }
                    }
                }
                Spacer()
            }
            .disabled(viewModel.isGameboardDisabled)
            .padding()
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: viewModel.resetGame))
            }
        }
    }
}

struct GameSquareView: View {
    
    let geometryProxy: GeometryProxy
    
    var body: some View {
        Circle()
            .foregroundColor(.red)
            .opacity(0.5)
            .frame(width: geometryProxy.size.width / 3 - 15,
                   height: geometryProxy.size.width / 3 - 15)
    }
}

struct PlayerIndicatorView: View {
    
    let systemImageName: String
    
    var body: some View {
        Image(systemName: systemImageName )
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
    }
}

// MARK: - Preview

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
