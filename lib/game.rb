# frozen_string_literal: true

# chess chess chess
class Game
  require_relative 'player'
  require_relative 'board'
  require_relative 'square'
  include Board

  def initialize
    @board_array = make_board_array
    @player_a = nil
    @player_b = nil
  end

  def play_game
    display_intro
    set_players
    @current_player = @player_a
    game_loop
    display_board
    display_outro
  end

  def game_loop
    until game_draw?
      display_board
      move_piece
      break if checkmate?(@current_player)

      @current_player = @current_player == @player_a ? @player_b : @player_a
    end
  end

  def game_draw?
    return true if stalemate?

    # add other draw conditions here if u have the energy to
    false
  end

  def stalemate?(current_player = @current_player)
    return false if check?(current_player)

    8.times do |x|
      8.times do |y|
        current_piece = find(x, y).piece
        unless current_piece.nil? || enemy_piece?(current_player.color, current_piece)
          valid_moves = get_valid_moves(current_piece, x, y)
          next if all_moves_in_check?([x, y], valid_moves, current_player)
          return false
        end
      end
    end
    true
  end

  def checkmate?(current_player)
    8.times do |x|
      8.times do |y|
        current_piece = find(x, y).piece
        unless current_piece.nil? || enemy_piece?(current_player.color, current_piece)
          valid_moves = get_valid_moves(current_piece, x, y)
          return false unless all_moves_in_check?([x, y], valid_moves, current_player)
        end
      end
    end
    return false unless check?(current_player)

    true
  end

  def all_moves_in_check?(start_coordinates, valid_moves, current_player)
    valid_moves.each do |end_coordinates|
      board_copy = copy_board_array
      move_piece([start_coordinates, end_coordinates], board_copy)
      return false unless check?(current_player, board_copy)
    end
    true
  end

  def check?(current_player, board_array = @board_array, current_player_king_coordinates = find_king(current_player))
    8.times do |x|
      8.times do |y|
        current_piece = find(x, y, board_array).piece
        if !current_piece.nil? && enemy_piece?(current_player.color, current_piece)
          valid_moves = get_valid_moves(current_piece, x, y)
          return true if valid_moves.include?(current_player_king_coordinates)
        end
      end
    end
    false
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

  def move_piece(move = get_move_input, board_array = @board_array)
    move = get_move_input if move.nil? # in case u need to set a custom board_array only? idk
    start_coordinates = move[0]
    end_coordinates = move[1]
    end_sq = find(end_coordinates[0], end_coordinates[1], board_array)
    start_sq = find(start_coordinates[0], start_coordinates[1], board_array)
    end_sq.piece = start_sq.piece
    start_sq.piece = nil
  end

  def get_move_input
    move = []
    2.times do |count|
      print_move_input(count)
      coordinates = []
      2.times do |coord_count|
        print_coordinate_input(coord_count)
        input = gets.chomp
        raise 'Please enter valid coordinates >:(' unless input.match?(/[1-8]/)

        coordinates.push(input.to_i - 1)
      end
      raise "That square is empty! you can't move nothing" if empty_square?(coordinates) && count.zero?

      move.push(coordinates)
    end
    raise 'Please enter a valid move!' unless valid_move?(move[0], move[1])

    move
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
    directions = case color
                 when 'black' then y == 6 ? [[[0, -1], [0, -2]]] : [[[0, -1]]]
                 when 'white' then y == 1 ? [[[0, 1], [0, 2]]] : [[[0, 1]]]
                 end
    moves = set_moves(x, y, color, directions)
    moves.keep_if { |move| find(move[0], move[1]).piece.nil? }
    diagonals = get_pawn_diagonal_moves(x, y, color)
    moves + diagonals
  end

  def get_pawn_diagonal_moves(x, y, color)
    directions = case color
                 when 'black' then [[[-1, -1], [1, -1]]]
                 when 'white' then [[[1, 1], [-1, 1]]]
                 end
    coordinates = set_moves(x, y, color, directions)
    coordinates.delete_if { |coord| find(coord[0], coord[1]).piece.nil? }
  end

  # need to check color for castling
  def get_king_moves(x, y, color)
    directions = [[[-1, 0]], [[1, 0]], [[0, -1]], [[0, 1]], [[-1, -1]], [[-1, 1]], [[1, -1]], [[1, 1]]]
    set_moves(x, y, color, directions)
    # castling
    # case color
    # when 'white' then
    # when 'black' then
    # end
  end

  def get_queen_moves(x, y, color)
    directions = [
      [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7]],
      [[-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7]],
      [[1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7]],
      [[-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7]],
      [[0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7]],
      [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0]],
      [[0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6], [0, -7]],
      [[-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0]]
    ]
    set_moves(x, y, color, directions)
  end

  def get_knight_moves(x, y, color)
    directions = [[[-1, 2]], [[1, 2]], [[2, 1]], [[2, -1]], [[1, -2]], [[-1, -2]], [[-2, -1]], [[-2, 1]]]
    set_moves(x, y, color, directions)
  end

  def get_bishop_moves(x, y, color)
    directions = [
      [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7]],
      [[-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7]],
      [[1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7]],
      [[-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7]]
    ]
    set_moves(x, y, color, directions)
  end

  def get_rook_moves(x, y, color)
    directions = [
      [[0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7]],
      [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0]],
      [[0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6], [0, -7]],
      [[-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0]]
    ]
    set_moves(x, y, color, directions)
  end

  def find_king(current_player, board_array = @board_array)
    king = current_player.color == 'white' ? '♔' : '♚'
    8.times do |x|
      8.times do |y|
        current_piece = find(x, y, board_array).piece
        return [x, y] if current_piece == king
      end
    end
    nil
  end

  private

  def copy_board_array
    board_copy = make_board_array
    board_copy.each do |line_copy|
      line_copy.each do |square_copy|
        square_copy.piece = find(square_copy.x, square_copy.y).piece
      end
    end
    board_copy
  end

  def set_moves(x, y, color, directions)
    moves = []
    directions.each do |direction|
      direction.each do |move|
        coordinates = [x + move[0], y + move[1]]
        break unless inside_board?(coordinates)

        piece = find(coordinates[0], coordinates[1]).piece  # rewrite this? or split to new method
        if piece.nil?
          moves.push(coordinates)
        else
          moves.push(coordinates) if enemy_piece?(color, piece)
          break
        end
      end
    end
    moves
  end

  def enemy_piece?(color, test_piece)
    test_piece_color = get_color(test_piece)
    return true if test_piece_color != color

    false
  end

  def inside_board?(coordinates)
    a = coordinates[0]
    b = coordinates[1]
    return true if a <= 7 && a >= 0 && b <= 7 && b >= 0

    false
  end

  def get_valid_moves(current_piece, start_x, start_y)
    case current_piece
    when '♟︎', '♙' then get_pawn_moves(start_x, start_y, get_color(current_piece))
    when '♚', '♔' then get_king_moves(start_x, start_y, get_color(current_piece))
    when '♛', '♕' then get_queen_moves(start_x, start_y, get_color(current_piece))
    when '♞', '♘' then get_knight_moves(start_x, start_y, get_color(current_piece))
    when '♝', '♗' then get_bishop_moves(start_x, start_y, get_color(current_piece))
    when '♜', '♖' then get_rook_moves(start_x, start_y, get_color(current_piece))
    end
  end

  def get_color(piece)
    case piece
    when '♟︎', '♚', '♛', '♞', '♝', '♜' then 'black'
    when '♙', '♔', '♕', '♘', '♗', '♖' then 'white'
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

  def print_move_input(move_num)
    message = case move_num
              when 0 then 'Enter which piece to move: '
              when 1 then 'Enter which square to move to: '
              end
    puts message
  end

  def print_coordinate_input(coordinate_num)
    message = case coordinate_num
              when 0 then 'x value (1-8): '
              when 1 then 'y value (1-8): '
              end
    print message
  end

  public
  def display_board(board_array = @board_array)
    clear
    8.times do |line_num|
      print_border(line_num)
      print_squares(line_num, board_array)
    end
    print_border(8)
    print_border(9)
  end

  def print_squares(y, board_array = @board_array)
    print "#{8 - y} "
    8.times do |x|
      print '┃ '
      square = find(x, y, board_array).piece.nil? ? ' ' : find(x, y, board_array).piece
      print square
      print ' '
    end
    puts '┃'
  end
end
