# frozen_string_literal: false

# generic (?) JSON saving and loading methods
module Saveload
  def load_data
    filename = input_loadfile_name
    data = File.open(filename, 'r') { |file| file.readline }
    JSON.parse(data)
  end

  def save_data(data)
    filename = input_savefile_name
    File.open("#{filename}.json", 'w') { |file| file.puts(JSON.dump(data)) }
  end

  def input_loadfile_name
    puts 'Your save files:'
    puts Dir.glob('*.json').join(' ').gsub('.json', '')
    begin
      print 'Enter the file name: '
      filename = gets.chomp
      raise 'Please enter a valid file name.' unless File.exist?("#{filename}.json")

      "#{filename}.json"
    rescue StandardError => e
      puts e.message
      retry
    end
  end

  def input_savefile_name
    print 'Name your save file (only alphanumberic chars and _ please): '
    name = gets.chomp
    raise 'Only alphanumberic characters and _ please.' unless name.match?(/^[0-9a-zA-Z_]+$/)

    name
  rescue StandardError => e
    puts e.message
    retry
  end
end