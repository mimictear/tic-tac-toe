//
//  GameViewModel.swift
//  Tic-Tac-Toe
//
//  Created by ANDREY VORONTSOV on 27.03.2023.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @Published var moves: [Move?] = TicTacToe.emptyGameboard
    @Published var isGameboardDisabled = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for position: Int) {
        if isSquareOccopied(in: moves, forIndex: position) { return }
        moves[position] = Move(player: .human, boardIndex: position)
        isGameboardDisabled = true
        if isWinOrDraw(player: .human) {
            return
        }
        
        // weak or not?
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            
            guard let self else { return }
            let computerPosition = self.determineComputerMovePosition(in: self.moves)
            self.moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            self.isGameboardDisabled = false
            if self.isWinOrDraw(player: .computer) {
                return
            }
        }
    }
    
    func resetGame() {
        moves = TicTacToe.emptyGameboard
        isGameboardDisabled = false
    }
    
    // MARK: - Private Methods
    
    private func determineComputerMovePosition(in moves: [Move?]) -> Int {
        /// If AI can win, then win
        if let winPosition = determineWinOrBlockPosition(player: .computer) {
            return winPosition
        }
        /// If AI can't win, then block
        if let blockPosition = determineWinOrBlockPosition(player: .human) {
            return blockPosition
        }
        /// If AI can't block, then take middle square
        if !isSquareOccopied(in: moves, forIndex: TicTacToe.centerSquare) {
            return TicTacToe.centerSquare
        }
        /// If AI can't take middle square, take random available square
        var movePosition = Int.random(in: 0..<TicTacToe.squareCount)
        while isSquareOccopied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<TicTacToe.squareCount)
        }
        return movePosition
    }
    
    private func determineWinOrBlockPosition(player: Player) -> Int? {
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        guard let winPosition = TicTacToe.winPatterns.first(where: { $0.subtracting(playerPositions).count == 1 }) else {
            return nil
        }
        let isAvailable = !isSquareOccopied(in: moves, forIndex: winPosition.first!)
        return isAvailable ? winPosition.first : nil
    }
    
    private func isSquareOccopied(in moves: [Move?], forIndex index: Int) -> Bool {
        moves.contains(where: { $0?.boardIndex == index })
    }
    
    private func checkWinCondition(player: Player, in moves: [Move?]) -> Bool {
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        for pattern in TicTacToe.winPatterns where pattern.isSubset(of: playerPositions) { return true }
        return false
    }
    
    private func checkForDraw(in moves: [Move?]) -> Bool {
        moves.compactMap { $0 }.count == TicTacToe.squareCount
    }
    
    private func isWinOrDraw(player: Player) -> Bool {
        if checkWinCondition(player: player, in: moves) {
            alertItem = player == .human ? AlertContext.humanWin : AlertContext.computerWin
            return true
        }
        if checkForDraw(in: moves) {
            alertItem = AlertContext.draw
            return true
        }
        return false
    }
}
