class Game
  attr_reader :tries

  def initialize
    @computer = ComputerPlayer.new
    @human = HumanPlayer.new
    @hangman = HangmanGraphic.new
    @good_guesses = []
    @bad_guesses = []
    @code_word = ''
    @bad_guesses_used = 0
  end

  def introduction
    puts "\n\n\n\n\n"
    puts "Welcome to Hangman!"
    puts "Try to guess the hidden word, you're allowed"
    puts "6 incorrect guesses before you lose."
  end

  def play_new_game
    @code_word = @computer.choose_code_word
    introduction
    game_loop
  end

  def game_loop
    while @bad_guesses_used < 6
      @hangman.draw_hangman(@bad_guesses_used)
      puts generate_word_display(@code_word, @good_guesses)
      display_guesses
      letter = @human.get_new_letter
      evaluate_guess(letter)
      if win?
        puts "Congrats! You guessed the word: #{@code_word}"
        break
      end
    end
    unless win?
      @hangman.draw_hangman(@bad_guesses_used)
      puts "\nBetter luck next time!"
      puts "The hidden word was: #{@code_word}"
    end
  end


  def generate_word_display(code_word, good_guesses)
    code_word_array = code_word.split("")
    code_word_array.map { |let| good_guesses.include?(let) ? let : "_"}.join(" ")
  end

  def evaluate_guess(letter)
    if @code_word.split("").include?(letter)
      @good_guesses.append(letter)
    else
      @bad_guesses.append(letter)
      @bad_guesses_used += 1
    end
  end

  def display_guesses
    guessed_letters = (@good_guesses + @bad_guesses).join(" ")
    puts "\nGuessed letters: #{guessed_letters}"
  end

  def win?
    @code_word.split("").uniq.sort == @good_guesses.sort
  end


end

class HumanPlayer
  attr_reader :guess

  def initialize
    @guess = ''
    @guessed_letters = ''
  end

  # gets guessed letter from user
  def get_new_letter
    loop do 
      puts "\n"
      print "Enter a letter: "
      @guess = gets.chomp.downcase
      if valid_guess?(@guess)
        if letter_already_guessed?(@guess)
          puts "You've already guessed that letter!"
        else
          @guessed_letters += @guess
          return @guess
          break
        end
      else
        puts "** Invalid input **"
      end
    end
  end

  private

  def valid_guess?(letter)
    valid_letters = 'abcdefghijklmnopqrstuvwxyz'
    letter.length == 1 && valid_letters.include?(letter)
  end

  def letter_already_guessed?(letter)
    @guessed_letters.include?(letter)
  end

end

class ComputerPlayer
  attr_reader :code_word

  def initialize
    @code_word = ''
  end

  def choose_code_word
    random_word = nil
    File.foreach('word_list_5_to_12.txt').each_with_index do |word, num|
      random_word = word.chomp if rand < 1.0/(num + 1)
    end
    return random_word
  end
end

class HangmanGraphic
  # draws the current state of the hangman

  def initialize
    @hangman_graphics = ['''
      +---+
      |   |
          |
          |
          |
          |
    =========''', '''
      +---+
      |   |
      O   |
          |
          |
          |
    =========''', '''
      +---+
      |   |
      O   |
      |   |
          |
          |
    =========''', '''
      +---+
      |   |
      O   |
     /|   |
          |
          |
    =========''', '''
      +---+
      |   |
      O   |
     /|\  |
          |
          |
    =========''', '''
      +---+
      |   |
      O   |
     /|\  |
     /    |
          |
    =========''', '''
      +---+
      |   |
      O   |
     /|\  |
     / \  |
          |
    =========''']
  end

  def draw_hangman(incorrect_guesses)
    puts @hangman_graphics[incorrect_guesses]
  end
end


g = Game.new
g.play_new_game