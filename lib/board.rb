# frozen_string_literal: false

# display methods
module Board
  def display_intro
    puts " ♔ Let's play some chess! ♚ "
  end

  def display_outro(winning_player_name, is_game_draw)
    if is_game_draw
      puts "Game over! It's a draw!"
    else
      puts "Congratulations! #{winning_player_name} won!"
    end
  end

  def print_border(line_num)
    line = case line_num
           when 7 then '┏━━━┳━━━┳━━━┳━━━┳━━━┳━━━┳━━━┳━━━┓'
           when 0..6 then '┣━━━╋━━━╋━━━╋━━━╋━━━╋━━━╋━━━╋━━━┫'
           when 8 then '┗━━━┻━━━┻━━━┻━━━┻━━━┻━━━┻━━━┻━━━┛'
           when 9 then '  1   2   3   4   5   6   7   8'
           end
    puts "  #{line}"
  end

  def clear
    if Gem.win_platform?
      system 'cls'
    else
      system 'clear'
    end
  end
end
