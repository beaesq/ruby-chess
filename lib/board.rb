# frozen_string_literal: false

# display methods
module Board
  def print_border(line_num)
    line = case line_num
           when 0 then '┏━━━┳━━━┳━━━┳━━━┳━━━┳━━━┳━━━┳━━━┓'
           when 1..7 then '┣━━━╋━━━╋━━━╋━━━╋━━━╋━━━╋━━━╋━━━┫'
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
