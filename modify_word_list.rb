# Modifies 'word_list.txt' to contain only words 
# within a certain length range

MINIMUM_WORD_LENGTH = 5
MAXIMUM_WORD_LENGTH = 12

modified_word_list = []

File.readlines('word_list.txt').each do |word|
  word = word.chomp
  if word.length >= MINIMUM_WORD_LENGTH && word.length <= MAXIMUM_WORD_LENGTH
    modified_word_list.push(word.downcase)
  end
end

new_word_list = File.open("word_list_#{MINIMUM_WORD_LENGTH}_to_#{MAXIMUM_WORD_LENGTH}.txt", "w")
modified_word_list.each do |word|
  new_word_list.puts word
end
new_word_list.close
