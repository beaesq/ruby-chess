# frozen_string_literal: true

# player details
class Player
  def initialize(color, name = nil)
    @name = name
    @color = color
    # color == 'white' ? set_white_pieces : set_black_pieces
  end

  attr_accessor :name, :color#, :pieces

  # def set_white_pieces
  #   @king = { token: '♔', coordinates: [4, 0] }
  #   @queen = { token: '♕', coordinates: [3, 0] }
  #   @bishop = {
  #     1 => { token: '♗', coordinates: [2, 0] },
  #     2 => { token: '♗', coordinates: [5, 0] }
  #   }
  #   @knight = {
  #     1 => { token: '♘', coordinates: [1, 0] },
  #     2 => { token: '♘', coordinates: [6, 0] }
  #   }
  #   @rook = {
  #     1 => { token: '♖', coordinates: [0, 0] },
  #     2 => { token: '♖', coordinates: [7, 0] }
  #   }
  #   @pawn = {
  #     1 => { token: '♙', coordinates: [0, 1] },
  #     2 => { token: '♙', coordinates: [1, 1] },
  #     3 => { token: '♙', coordinates: [2, 1] },
  #     4 => { token: '♙', coordinates: [3, 1] },
  #     5 => { token: '♙', coordinates: [4, 1] },
  #     6 => { token: '♙', coordinates: [5, 1] },
  #     7 => { token: '♙', coordinates: [6, 1] },
  #     8 => { token: '♙', coordinates: [7, 1] },
  #   }
  # end

  # def set_black_pieces
  #   @king = { token: '♚', coordinates: [4, 7] }
  #   @queen = { token: '♛', coordinates: [3, 7] }
  #   @bishop = {
  #     1 => { token: '♝', coordinates: [2, 7] },
  #     2 => { token: '♝', coordinates: [5, 7] }
  #   }
  #   @knight = {
  #     1 => { token: '♞', coordinates: [1, 7] },
  #     2 => { token: '♞', coordinates: [6, 7] }
  #   }
  #   @rook = {
  #     1 => { token: '♜', coordinates: [0, 7] },
  #     2 => { token: '♜', coordinates: [7, 7] }
  #   }
  #   @pawn = {
  #     1 => { token: '♟︎', coordinates: [0, 6] },
  #     2 => { token: '♟︎', coordinates: [1, 6] },
  #     3 => { token: '♟︎', coordinates: [2, 6] },
  #     4 => { token: '♟︎', coordinates: [3, 6] },
  #     5 => { token: '♟︎', coordinates: [4, 6] },
  #     6 => { token: '♟︎', coordinates: [5, 6] },
  #     7 => { token: '♟︎', coordinates: [6, 6] },
  #     8 => { token: '♟︎', coordinates: [7, 6] },
  #   }
  # end
end