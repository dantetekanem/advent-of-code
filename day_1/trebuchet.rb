# My solution is not the most elegant, instead of trying to loop the string for each match and capture the current index
# I've decided to be more simple as the request. I'll check the first and the last match, just reversing data
# This way I can find a match for the use case of 1twone, which in a singular scan goes 12
# But the correct answer is supposed to be 11, since there are 3 matches in there, 1, two and one.
# Using a reverse approach, I match the first result: 1, and the last result: one.

NUM_WORDS = %w[one two three four five six seven eight nine]
REGEX = /\d|#{NUM_WORDS.join('|')}/
REGEX_REVERSE = /\d|#{NUM_WORDS.map(&:reverse).join('|')}/
NUM_WORDS_TO_NUM = NUM_WORDS.map.with_index { |word, i| [word, i + 1] }.to_h
NUM_WORDS_TO_NUM_REVERSE = NUM_WORDS.map.with_index { |word, i| [word.reverse, i + 1] }.to_h

def trebuchet(line)
  first = line.scan(REGEX).map { |word| NUM_WORDS_TO_NUM[word] || word.to_i }.first
  last = line.reverse.scan(REGEX_REVERSE).map { |word| NUM_WORDS_TO_NUM_REVERSE[word] || word.to_i }.first

  "#{first}#{last}".to_i
end

total = 0
IO.foreach('input.txt') do |line|
  calc = trebuchet(line.strip)
  total += calc
  puts "#{line.strip} = #{calc}"
end

puts "Result of all trebuchet numbers: #{total}"
