require 'csv'

class Hangman
	def welcome_menu
		set_default_variables
		puts "Welcome to Hangman!\nDo you want to play a new game or load one?\nType 'new' or 'load'."
		decision = gets.chomp
		if decision == 'new'
			game
		elsif decision == 'load'
			load_game
		end
	end

	def game
		drawing
		game_loop
		puts "\nWould you like to play again? Type 'Yes' or 'No'."
		play_again = gets.chomp
		if play_again == "Yes"
			set_default_variables
			game
		end
	end
		
	def game_loop
		while @guesses_left > 0
			player_move
			drawing
			if (@guess.length > 1) && (@word.include? @guess)
				puts "\nYou win! You guessed the word!"
				break
			end
		end
	end

	def set_default_variables
		@guesses_left = 6
		@letters_used = ""
		@word = ""
		word_selection
		encrypt_word
		@guess = ""
	end

	#method selects random word from .txt dictionary with appropriate character length
	def word_selection
		until @word.length > 4 && @word.length < 13
			@word = File.new("5desk.txt", "r").readlines[rand(61406)][0..-3].upcase
		end
	end
	
	def encrypt_word
		@encrypted_word = @word.gsub(/\w/,'_')
	end
	
	def player_move
		puts "\nYou may guess a letter, guess the full word, or type 'save' to save the game"
		@guess = gets.chomp.upcase
		word_update
	end
	
	def word_update
		if @guess == "SAVE"
			save_game
		elsif @guess.length == 0
			puts "\nInvalid entry, please try again."
			player_move
		elsif @guess.length == 1
			if @letters_used.include? @guess
				puts "\nYou have already guessed this letter, try another one."
				player_move
			elsif @word.include? @guess
				puts "\nGood guess!"
				@letters_used += @guess
				encrypted_word_update
			else
				puts "\nBad guess."
				@letters_used += @guess
				@guesses_left -= 1
			end
		elsif @guess.length > 1
			if @word.include? @guess
				@encrypted_word = @word
			else
				puts "\nBad guess."
				@guesses_left -= 1
			end
		end
	end
			
	def encrypted_word_update
		updated_encryption = ""
		@word.split("").each_with_index do |letter,index|
			if @guess == letter
				updated_encryption += "#{letter}"
			elsif "_" != @encrypted_word[index]
				updated_encryption += @encrypted_word[index]
			else
				updated_encryption += "_"
			end
		end
		@encrypted_word = updated_encryption
	end
	
	def save_game
		Dir.mkdir('saves') unless Dir.exist? "saves"
		puts "Write the name of your save."
		name = gets.chomp
		csv = File.open('saves/saved_games.csv', "ab")
		csv.write("#{name},#{@guesses_left},#{@letters_used},#{@word},#{@encrypted_word}")
		csv.close
	end
	
	def load_game
		if !(File.exist?("saves/saved_games.csv"))
			puts "There are no saved games\nNew game"
			game
		end
		
		puts "\nSaved Games:\n"
		saves = CSV.read('saves/saved_games.csv')
		saves.each_with_index do |save,index|
			puts "#{index +1}. #{save[0]}"
		end
		
		load_save(saves)
		
		game
	end
	
	def load_save(saves)
		number = which_save(saves.size)
		@guesses_left = saves[number][1].to_i
		@letters_used = saves[number][2]
		@word = saves[number][3]
		@encrypted_word = saves[number][4]
		puts "#{saves[number][0]} loaded"
	end
	
	def which_save(number_of_saves)
		puts "\nEnter the save number that you want to load."
		answer = gets.chomp.to_i
		if answer < 1 || answer > number_of_saves
			puts "There's no save number #{answer}."
			which_save(number_of_saves)
		else
			return answer-1
		end
	end
	
	def drawing
		if @guesses_left == 6
			puts "
 ___
|   |
|			 #{@encrypted_word}
|			 #{@guesses_left} guesses remain.
|
|____   "
		elsif @guesses_left == 5
			puts "
 ___
|   |
|   O	 		 #{@encrypted_word}
|			 #{@guesses_left} guesses remain.
|
|____   "
		elsif @guesses_left == 4
			puts "
 ___
|   |
|   O	 		 #{@encrypted_word}
|   |	 		 #{@guesses_left} guesses remain.
|
|____   "
		elsif @guesses_left == 3
			puts "
 ___
|   |
|   O	 		 #{@encrypted_word}
|  \\| 			 #{@guesses_left} guesses remain.
|
|____   "
		elsif @guesses_left == 2
			puts "
 ___
|   |
|   O	 		 #{@encrypted_word}
|  \\|/ 			 #{@guesses_left} guesses remain.
|
|____   "
		elsif @guesses_left == 1
			puts "
 ___
|   |
|   O	 		 #{@encrypted_word}
|  \\|/	 		 #{@guesses_left} guess remains.
|  /
|____   "
		elsif @guesses_left == 0
			puts "
 ___
|   |
|   O	 		 #{@encrypted_word}
|  \\|/	 		 You have lost! The word was #{@word}!
|  / \\
|______"
		end
	end
end

Hangman.new.welcome_menu









