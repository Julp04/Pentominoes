//
//  HintViewController.swift
//  Pentominoes
//
//  Created by Julian Panucci on 9/18/16.
//  Copyright © 2016 Julian Panucci. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class HintViewController: UIViewController {
    
    
    var model:PentominoeModel? = nil
    
    //Array of pieces passed from ViewController so we can make reference to what pieces are on the board in ViewController, so we know what pieces to show in the hint (These are never actually seen)
    var boardPieces = [PieceImageView]()
    
    //New array of pieces that we create separately in this view controller and add to board. These are the pieces that are shown or not shown on the hint board
    var hintPieces = [PieceImageView]()
    
    let kSideOfSquare:CGFloat = 30.0
    
    @IBAction func nextHintAction(_ sender: AnyObject) {
        revealNextHint()
    }
    
    @IBOutlet weak var boardImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let model = model {
              self.boardImageView.image = UIImage(named: model.imageBoardNameAtIndex((model.currentBoardNumber)))
        }
        
        addAllPiecesToBoard()
        revealNextHint()
    }
    
    /**
     Adds all pieces to the current board sent from the original view controller. Sets all of them to hidden. Very similar to method in ViewController that adds the pieces to the board, but with no animation
     */
    func addAllPiecesToBoard()
    {
        var pieceIndex = 0
        
        if let model = model {
            for letter in model.pieceLetters {
                
                let name = model.imagePieceNameAtIndex(pieceIndex)
                let pieceImage = UIImage(named: name)
                let pieceImageView = PieceImageView(image: pieceImage)
                pieceImageView.letter = letter
                hintPieces.append(pieceImageView)
                
                let solution = model.solutionForPiece(pieceWithLetter: letter, onBoard: model.currentBoardNumber)
               

                //Get all info needed for the transition of the piece
                let xcord = CGFloat(solution["x"]!) * kSideOfSquare
                let ycord = CGFloat(solution["y"]!) * kSideOfSquare
                let flips = solution["flips"]
                let rotations = solution["rotations"]
                
                pieceImageView.numberOfRotations = rotations!
                pieceImageView.numberOfFlips = flips!
               
                if(rotations > 0) {
                    pieceImageView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2 * Double(rotations!)))
                }
                if(flips > 0) {
                    pieceImageView.transform = pieceImageView.transform.scaledBy(x: -1.0, y: 1.0);
                }
                
                pieceImageView.frame = CGRect(x: xcord, y: ycord, width: pieceImageView.frame.size.width, height: pieceImageView.frame.size.height)
                self.boardImageView.addSubview(pieceImageView)
                pieceImageView.isHidden = true
            
            
                pieceIndex += 1;
                }
            }
    }
    
    func revealNextHint()
    {
        var hintCount = 0;
        //Traverse through boardPieces and identify which one should be included in the hint or not. If it should we break out of the for loop because we want to reveal one hint at a time, and remove from boardPieces
        for piece in self.boardPieces {
            
            if piece.shouldBeInHint {
                showPieceWithLetter(piece.letter)
                self.boardPieces.remove(at: hintCount)
                break
            }
            hintCount += 1
        }
        
    }
    
    /**
     Traverse through hintPieces (pieces that are actually added to the hint board) We compare the letter of the current piece to letter passed through, if they are the same then we reveal the current piece on the board setting hidden to true
     
     - parameter letter: letter of piece we want to reveal
     */
    func showPieceWithLetter(_ letter:String) {
        for piece in hintPieces {
            if piece.letter == letter {
                piece.isHidden = false
            }
        }
    }
  
    
    @IBAction func dismiss(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

}
