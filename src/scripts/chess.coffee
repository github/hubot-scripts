# Description:
#   Play a game of chess!
#
# Dependencies:
#   "chess": "0.1.3"
#
# Configuration:
#   None
#
# Commands:
#   hubot chess me - Creates a new game between yourself and another person in the room
#   hubot chess status - Gets the current state of the board
#   hubot chess move <to> - Moves a piece to the coordinate position using standard chess notation
#
# Author:
#   thallium205
#

Chess = require 'chess'

module.exports = (robot) ->
  robot.respond /chess me$/i, (msg) ->
    robot.brain.data.chess = Chess.create()
    boardToFen robot.brain.data.chess.getStatus(), (status, fen) ->
      msg.send 'White\'s turn.'
      msg.send 'http://chessup.net/php/pictureParser.php?fen=' + fen + '&coord=on&.png'
  robot.respond /chess status/i, (msg) ->
    try
      boardToFen robot.brain.data.chess.getStatus(), (status, fen) ->
        msg.send status
        msg.send 'http://chessup.net/php/pictureParser.php?fen=' + fen + '&coord=on&.png'
    catch e
      msg.send e

  robot.respond /chess move (.*)/i, (msg) ->
    try
      robot.brain.data.chess.move msg.match[1]
      boardToFen robot.brain.data.chess.getStatus(), (status, fen) ->
        msg.send status
        msg.send 'http://chessup.net/php/pictureParser.php?fen=' + fen + '&coord=on&.png'
    catch e
      msg.send e

boardToFen = (status, callback) ->
  fen = [[],[],[],[],[],[],[],[]]
  blank = 0
  lastRank = 0
  for square in status.board.squares
    if lastRank isnt square.rank
      if blank isnt 0
        fen[lastRank - 1].push(blank)
        blank = 0        
    if square.piece is null
      blank = blank + 1
    else
      if square.piece.type is 'pawn'
        if blank is 0          
          fen[square.rank - 1].push(if square.piece.side.name is 'white' then 'P' else 'p')
        else
          fen[square.rank - 1].push(blank)
          fen[square.rank - 1].push(if square.piece.side.name is 'white' then 'P' else 'p')
          blank = 0
      else
        if blank is 0
          fen[square.rank - 1].push(if square.piece.side.name is 'white' then square.piece.notation.toUpperCase() else square.piece.notation.toLowerCase())
        else
          fen[square.rank - 1].push(blank)
          fen[square.rank - 1].push(if square.piece.side.name is 'white' then square.piece.notation.toUpperCase() else square.piece.notation.toLowerCase())
          blank = 0
    lastRank = square.rank
  for rank in fen
    rank = rank.join()
  fen = fen.reverse().join('/').replace(/,/g,'')

  msg = ''
  if status.isCheck
    msg += 'Check! '
  if status.isCheckmate
    msg += 'Checkmate! '
  if status.isRepetition
    msg += 'Threefold Repetition!  A draw can be called. '
  if status.isStalemate
    msg += 'Stalemate! '
  if Object.keys(status.notatedMoves).length > 0
    if status.notatedMoves[Object.keys(status.notatedMoves)[0]].src.piece.side.name is 'white' then msg += 'White\'s turn. ' else msg += 'Black\'s turn.'


  callback msg, fen


