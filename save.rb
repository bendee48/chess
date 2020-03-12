require 'yaml'

module SaveGame
  def self.save(game)
    Dir.mkdir("save_files") unless Dir.exist?("save_files")
    game_obj = YAML.dump(game)
    File.open("./save_files/game_save.yml", 'w') { |f| f.write(game_obj) }
  end

  def self.load
    file = Dir.glob("./save_files/*.yml").first
    read_file = File.read(file)
    YAML.load(read_file)
  end
end