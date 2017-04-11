require 'csv'
require 'sinatra'
require 'sinatra/reloader' if development?

use Rack::Session::Pool, :expire_after => 2592000

class Hangman

	attr_reader :encrypted_word, :guesses_left, :bad_guesses, :drawing, :message

	def initialize
		@message = ""
		@guesses_left = 6
		@letters_used = " "
		@word = ""
		word_selection
		encrypt_word
		@bad_guesses = ""
	end
	
	def word_selection
		until @word.length > 4 && @word.length < 13
			@word = File.new("5desk.txt", "r").readlines[rand(61406)][0..-3].upcase
		end
	end
	
	def encrypt_word
		@encrypted_word = @word.gsub(/\w/,'_')
	end
	
	def guess_assessment(guess)
		if guess.length == 1
			@message = ""
			if @letters_used.include?(guess)
				@message = "You have already guessed this letter, try another one."
			elsif guess.between?('A','Z') && @word.include?(guess)
				@letters_used += guess
				encrypted_word_update(guess)
			elsif guess.between?('A','Z') && !@bad_guesses.include?(guess)
				@letters_used += guess
				@guesses_left -= 1
				@bad_guesses += guess
			end
		end
	end	
	
	def encrypted_word_update(guess)
		updated_encryption = ""
		@word.split("").each_with_index do |letter,index|
			if guess == letter
				updated_encryption += "#{letter}"
			elsif "_" != @encrypted_word[index]
				updated_encryption += @encrypted_word[index]
			else
				updated_encryption += "_"
			end
		end
		@encrypted_word = updated_encryption
	end
	
	def ended?
		ended = false
		ended = true if (!(@encrypted_word.include?("_")) || @guesses_left == 0)
		ended
	end

	def won?
		won = false
		won = true if (ended? && @guesses_left > 0)
		won
	end
	
	def guesses_left_message
		if won?
			return "You have won!"
		elsif @guesses_left == 6
			return "#{@guesses_left} guesses remain."
		elsif @guesses_left == 5
			return "#{@guesses_left} guesses remain."
		elsif @guesses_left == 4
			return "#{@guesses_left} guesses remain."
		elsif @guesses_left == 3
			return "#{@guesses_left} guesses remain."
		elsif @guesses_left == 2
			return "#{@guesses_left} guesses remain."
		elsif @guesses_left == 1
			return "#{@guesses_left} guess remains."
		elsif @guesses_left == 0
			return "You have lost! The word was #{@word}!"
		end
	end
end

def new_game
	game = Hangman.new
	game
end

get '/' do
	redirect to session[:game].nil? ? '/reset' : '/play'
end

get '/reset' do
	session[:game] = new_game
	redirect to '/play'
end

get '/play' do
	redirect to '/reset' unless session[:game]
	redirect to '/reset' unless !session[:game].ended?
  if params['guess']
		session[:game].guess_assessment(params['guess'].to_s.upcase)
		bad_guesses = session[:game].bad_guesses.split("").join(", ")
	end
	message = session[:game].message
	encrypted_word = session[:game].encrypted_word.split("").join(" ")
	guesses_left = session[:game].guesses_left
	guesses_left_message = session[:game].guesses_left_message
	game = session[:game]
	erb :index, :locals => {:message => message, :encrypted_word => encrypted_word, :bad_guesses => bad_guesses, :guesses_left => guesses_left, :guesses_left_message => guesses_left_message, :game => session[:game]}
end

get '/save' do
	save_game(session[:game])
	redirect to '/'
end

get '/load' do
	if File.exist?("saves/saved_games.csv")
		saves = CSV.read('saves/saved_games.csv')
		erb :load, :locals => {:saves => saves}
	else
		redirect to '/'
	end
end
		
get '/load/:id' do
		
		@guesses_left = saves[number][1].to_i
		@letters_used = saves[number][2]
		@word = saves[number][3]
		@encrypted_word = saves[number][4]
		@bad_guesses = saves[number][5]
end	

get '/reset' do
	session[:game] = new_game
	redirect to '/play'
end

private

def save_game(game)
	Dir.mkdir('saves') unless Dir.exist? "saves"
	name = game.encrypted_word + " (#{session[:game].guesses_left})"
	csv = File.open('saves/saved_games.csv', "ab")
	csv.write("#{name},#{@guesses_left},#{@letters_used},#{@word},#{@encrypted_word},#{@bad_guesses}")
	csv.close
end
