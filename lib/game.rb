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
    move = get_move_input
    start_coordinates = move[0]
    end_coordinates = move[1]
    end_sq = find(end_coordinates[0], end_coordinates[1])
    start_sq = find(start_coordinates[0], start_coordinates[1])
    end_sq.piece = start_sq.piece
    start_sq.piece = nil
  end

  def get_move_input
    #aks for input
    input = gets.chomp
    raise 'Please enter valid coordinates >:(' unless input.match?(/[0-7]/)
    raise "That square is empty! you can't move nothing" if empty_square?(start_coordinates)
    raise 'Please enter a valid move!' unless valid_move?(start_coordinates, end_coordinates)
  rescue StandardError => e
    print e.message
    retry
  end

  # this assumes that the start square is not empty and the coordinates are within the board
  def valid_move?(start_coordinates, end_coordinates)
    start_x = start_coordinates[0]
    start_y = start_coordinates[1]
    current_sq = find(start_x, start_y)
    current_piece = current_sq.piece
    valid_moves = get_valid_moves(current_piece, start_x, start_y)
    return true if valid_moves.include?(end_coordinates)

    false
  end

  def empty_square?(start_coordinates)
    current_sq = find(start_coordinates[0], start_coordinates[1])
    return true if current_sq.piece.nil?

    false
  end

  def find(x, y, board_array = @board_array)
    return nil if x.nil? || y.nil?
    return nil if x.negative? || x > 7
    return nil if y.negative? || y > 7

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

  def get_pawn_moves(x, y, color)
    moves = []
    if color == 'white'
      if y == 1
        moves.push([x, y + 1], [x, y + 2])
      else
        moves.push([x, y + 1])
      end
      moves.push([x - 1, y + 1]) unless find(x - 1, y + 1).nil? || find(x - 1, y + 1).piece.nil?
      moves.push([x + 1, y + 1]) unless find(x + 1, y + 1).nil? || find(x + 1, y + 1).piece.nil?
      # hello start here (en passant)
    end
    if color == 'black'
      if y == 6
        moves.push([x, y - 1], [x, y - 2])
      else
        moves.push([x, y - 1])
      end
      moves.push([x - 1, y - 1]) unless find(x - 1, y - 1).nil? || find(x - 1, y - 1).piece.nil?
      moves.push([x + 1, y - 1]) unless find(x + 1, y - 1).nil? || find(x + 1, y - 1).piece.nil?
    end
    moves
  end

  private

  def get_valid_moves(current_piece, start_x, start_y)
    case current_piece
    when '♟︎' then get_pawn_moves(start_x, start_y, 'black')
    when '♙' then get_pawn_moves(start_x, start_y, 'white')
    when '♚', '♔' then get_king_moves(start_x, start_y)
    when '♛', '♕' then get_queen_moves(start_x, start_y)
    when '♞', '♘' then get_knight_moves(start_x, start_y)
    when '♝', '♗' then get_bishop_moves(start_x, start_y)
    when '♜', '♖' then get_rook_moves(start_x, start_y)
    end
  end

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
