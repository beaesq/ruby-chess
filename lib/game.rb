# frozen_string_literal: true

require_relative 'player'
require_relative 'board'
require_relative 'square'

# chess chess chess
class Game
  def initialize
    @board_array = make_board_array
  end

  def make_board_array
    board_array = []
    line_array = []
    8.times do |x|
      8.times do |y|
        line_array << Square.new([x, y])
      end
      board_array << line_array
      line_array = []
    end
    board_array
  end

  def move_piece
    
  end

  def find(x, y, board_array = @board_array)
    return nil if x.nil? || y.nil?

    board_array[x][y]
  end

  def set_board_start
    8.times do |x|
      sq = find(x, 0)
      sq.piece = get_non_pawn_token(x, 0)
    end
    8.times do |x|
      sq = find(x, 1)
      sq.piece = '♙'
    end
    8.times do |x|
      sq = find(x, 6)
      sq.piece = '♟︎'
    end
    8.times do |x|
      sq = find(x, 7)
      sq.piece = get_non_pawn_token(x, 7)
    end
  end

  private

  def get_non_pawn_token(x, y)
    if y.zero?
      case x
      when 0 then '♖'
      when 1 then '♘'
      when 2 then '♗'
      when 3 then '♕'
      when 4 then '♔'
      when 5 then '♗'
      when 6 then '♘'
      when 7 then '♖'
      end
    else
      case x
      when 0 then '♜'
      when 1 then '♞'
      when 2 then '♝'
      when 3 then '♛'
      when 4 then '♚'
      when 5 then '♝'
      when 6 then '♞'
      when 7 then '♜'
      end
    end
  end
end
