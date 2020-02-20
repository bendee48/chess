# frozen_string_literal: true

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
        send("player#{num}=", Player.new(name))
        break
      end
    end
  end

  def validate_color(num)
    puts "Thanks. Please choose your colour; 'black' or 'white'?"
    loop do
      color = gets.chomp.strip.downcase
      if color != 'black' && color != 'white'
        puts "Sorry, I didn't recognise that colour. PLease try again."
      else
        send("player#{num}").color = color
        puts "Thanks #{player1.name}, you're #{color}."
        break
      end
    end
  end
end
