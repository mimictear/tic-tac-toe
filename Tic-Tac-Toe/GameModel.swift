//
//  GameModel.swift
//  Tic-Tac-Toe
//
//  Created by ANDREY VORONTSOV on 27.03.2023.
//

struct TicTacToe {
    
    static let squareCount = 9
    static let centerSquare = 4
    
    static let winPatterns: Set<Set<Int>> = [[0, 1, 2],
                                             [3, 4, 5],
                                             [6, 7, 8],
                                             [0, 3, 6],
                                             [1, 4, 7],
                                             [2, 5, 8],
                                             [0, 4, 8],
                                             [2, 4, 6]]
    
    static let emptyGameboard: [Move?] = Array(repeating: nil, count: squareCount)
}

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        player == .human ? "xmark" : "circle"
    }
}
