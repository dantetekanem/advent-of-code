class ScratchCard
  attr_reader :id

  def initialize(line)
    @id, @winning_numbers, @scratch_numbers = extract_numbers(line)
  end

  def winning_numbers
    @winning_numbers & @scratch_numbers
  end

  def score
    return 0 if count.zero?
  
    2 ** (count - 1)
  end

  def count
    @count ||= winning_numbers.size
  end

  private

  def extract_numbers(line)
    id, numbers = line.scan(/(\d+): (.+)/).flatten
    left, right = numbers.split('|')
    [id.to_i, left.split(/\s+/).reject(&:empty?), right.split(/\s+/).reject(&:empty?)]
  end
end

# Part 1
sum_of_points = 0
IO.foreach('input.txt') do |line|
  card = ScratchCard.new(line)
  card.id.times do
    sum_of_points += card.score
  end
end
puts "How many points are they worth in total?: #{sum_of_points}"

# Part 2
card_scores = Hash.new { |hash, key| hash[key] = 1 }

IO.foreach('input.txt') do |line|
  card = ScratchCard.new(line)
  
  card_scores[card.id].times do
    card.count.times do |i|
      card_scores[card.id + i + 1] += 1
    end
  end
end
puts "How many total scratchcards do you end up with?: #{card_scores.values.sum}"
