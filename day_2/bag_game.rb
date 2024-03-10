class BagGame
  COLOR_REGEX = /(\d+)+\s+(\w+)/
  GAME_REGEX = /Game (\d+): (.+)/

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
