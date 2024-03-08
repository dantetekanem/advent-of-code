test_line = '1abc2twone'
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

# puts trebuchet(test_line)

total = 0
IO.foreach('input.txt') do |line|
  calc = trebuchet(line.strip)
  total += calc
  puts "#{line.strip} = #{calc}"
end

puts "Result of all trebuchet numbers: #{total}"
