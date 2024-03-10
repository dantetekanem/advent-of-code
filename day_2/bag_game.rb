# The solution for the second game
# I've decide to use a scan again, since I have a mix of numbers to analyze between strings
# I am not a particular fan of spliting words and mapping, i don't own much control over them
# Using a scan and a regex (thank you rubular.com!), I can easily capture the information for mapping
# Which was particulary interesting in this case, as the all? used in the round_valid? was overwriting the repetitions correctly
# If the game rule have been in a different order, this wouldn't work.

class BagGame
  COLOR_REGEX = /(\d+)+\s+(\w+)/ # Capture the color and the count, e.g. 12 red -> [12, red]
  GAME_REGEX = /Game (\d+): (.+)/ # Capture the game id and the game, e.g. Game 1: 12 red; 13 green; 14 blue -> [1, "12 red; 13 green; 14 blue"]

  attr_reader :red, :green, :blue

  def initialize(red, green, blue)
    @red = red
    @green = green
    @blue = blue
  end

  def play(game)
    id, rounds = game.scan(GAME_REGEX).flatten
    game_valid?(rounds) ? id.to_i : nil
  end
  
  def check(game)
    id, rounds = game.scan(GAME_REGEX).flatten
    min_colors_game_be_valid?(rounds)
  end

  def round_valid?(str)
    game = str.scan(COLOR_REGEX).map { |count, color| [color, count.to_i] }.to_h
    game.all? { |color, count| send(color) >= count }
  end

  def min_colors_game_be_valid?(str)
    min_colors = { 'red' => 0, 'green' => 0, 'blue' => 0}
    str.scan(COLOR_REGEX).map do |count, color|
      count = count.to_i
      min_colors[color] = count if min_colors[color] < count
    end

    min_colors
  end

  def game_valid?(str)
    str.split(';').all? { |round| round_valid?(round.strip) }
  end
end

bag_game = BagGame.new(12, 13, 14)

sum_of_ids = 0
IO.foreach('input.txt') do |line|
  result = bag_game.play(line)
  sum_of_ids += result if result
end
puts "Sum of IDs: #{sum_of_ids}"

sum_of_power_min_games = 0
IO.foreach('input.txt') do |line|
  result = bag_game.check(line)
  sum_of_power_min_games += result.values.reduce(&:*)
end
puts "Sum of power min games: #{sum_of_power_min_games}"
