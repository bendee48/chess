# frozen_string_literal: true

# maybe change how validation works?
module Validation
  def validate_name(num)
    loop do
      puts "Player #{num} please enter your name."
      name = gets.chomp.strip.capitalize
      if name.empty?
        puts "Name can't be blank."
      elsif name.size > 12
        puts 'Name must be less than 12 characters.'
      else
        send("player#{num}=", Player.new(name, nil, num))
        break
      end
    end
  end

  def validate_color(num)
    puts "Thanks. Please choose your colour; 'black' or 'white'?"
    loop do
      color = gets.chomp.strip.downcase
      if color != 'black' && color != 'white'
        puts "Sorry, I didn't recognise that colour. Please try again."
      else
        send("player#{num}").color = color
        puts "Thanks #{player1.name}, you're #{color}."
        break
      end
    end
  end

  def validate_player_move(start, player)
    start_piece = return_piece(start)
    if start_piece == '-'
      puts "No piece there."
    elsif start_piece.color != player.color
      puts "Not your piece to move."
    else
      start_piece = start_piece.name
    end
    start_piece
  end

  def valid_format?(move)
    move = move.downcase
    move =~ /[a-h][1-8]\s[a-h][1-8]/
  end
end
