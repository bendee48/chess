# frozen_string_literal: true

require 'yaml'
require_relative 'game'

# Module to save and load game.
module SaveGame
  def self.save(game)
    Dir.mkdir('save_files') unless Dir.exist?('save_files')
    game_obj = YAML.dump(game)
    File.open('./save_files/game_save.yml', 'w') { |f| f.write(game_obj) }
  end

  def self.load
    file = Dir.glob('./save_files/*.yml')
    if file.empty?
      puts 'No save file found.'
      puts 'Starting new game instead.'; sleep 2
      Game.new.new_game
    else
      read_file = File.read(file.first)
      YAML.load(read_file)
    end
  end
end
