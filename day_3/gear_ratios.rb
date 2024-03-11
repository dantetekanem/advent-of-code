# This was a bit more tricky to handle. I have used again a regex to match the numbers, as it is easier to handle in the middle of many strings.
# The first solution, to find the matching neighbours, I decided to store an array of surroundings, easily navigating through the matrix.
# This allowed me to initially fetch all strings, and compare them looking for only "." as no symbol.
# When the second part came it became much more tricker, I had to connect them like graphs, but I didn't want to change my entire 
# implementation to use graphs at this point. I did modified a few bits here and there to instead of only a single string, I would store
# a hash with the character and the position, the position being an encoded character for (line:char position)
# with this in place, I could run a few loops and make an array of connections, and easily finish the second part of the challenge.

class GearRatios
  NUM_REGEX = /\d+/
  attr_accessor :sum, :engine_matrix, :engine_matches

  def initialize
    @sum = 0
    @engine_matrix = []
    @engine_matches = []
  end

  def add(gear_ratio)
    engine_matrix << gear_ratio
    matches = scan_nums(gear_ratio)
    engine_matches << schematic_engine(matches, engine_matrix.size - 1) if matches.any?
  end

  def numbers_with_neighbours
    neighbours = []
    engine_matches.flatten.each do |em|
      next if em.empty?
      neighborhood = (get_top(em) + get_bottom(em) + get_left(em) + get_right(em)).map { |c| c[:char] }.join.split('').uniq
      neighbours << em[:num] if neighborhood.size > 1
    end
    neighbours
  end

  def ratio_of_neighbours
    matching_neighbors = {}
    engine_matches.flatten.each do |em|
      next if em.empty?

      (get_top(em) + get_bottom(em) + get_left(em) + get_right(em)).select do |c|
        (matching_neighbors[c[:pos]] ||= []) << em[:num] if c[:char] == "*"
      end
    end

    matching_neighbors.select { |k, v| v.size > 1 }.reduce(0) do |acc, (k, v)|
      acc + v.reduce(:*)
    end
  end

  private

  def get_top(em)
    return [ {char: ".", pos: nil } ] if em[:line] == 0
    top = engine_matrix[em[:line] - 1]
    top_start = [em[:start]-1, 0].max
    top_end = [em[:end]+1, top.size].min
    top[top_start..top_end].chars.map.with_index do |t, i|
      { char: t, pos: "#{em[:line]-1}:#{top_start + i}" }
    end
  end

  def get_bottom(em)
    return [ {char: ".", pos: nil } ] if em[:line] == engine_matrix.size - 1
    bottom = engine_matrix[em[:line]+1]
    bottom_start = [em[:start]-1, 0].max
    bottom_end = [em[:end]+1, bottom.size].min
    bottom[bottom_start..bottom_end].chars.map.with_index do |t, i|
      { char: t, pos: "#{em[:line]+1}:#{bottom_start + i}" }
    end
  end

  def get_left(em)
    return [ {char: ".", pos: nil } ] if em[:start] == 0
    [{ char: engine_matrix[em[:line]][em[:start]-1], pos: "#{em[:line]}:#{em[:start]-1}" }]
  end

  def get_right(em)
    return [ {char: ".", pos: nil } ] if em[:end] == engine_matrix[em[:line]].size
    [{ char: engine_matrix[em[:line]][em[:end]+1], pos: "#{em[:line]}:#{em[:end]+1}" }]
  end

  def scan_nums(str)
    results = []
    str.scan(NUM_REGEX) do |match|
      results << [match, Regexp.last_match.begin(0), Regexp.last_match.end(0) - 1]
    end
    results
  end

  def schematic_engine(matches, line)
    matches.map do |c|
      { num: c[0].to_i, start: c[1], end: c[2], line: line }
    end
  end
end

gear_ratios_1 = GearRatios.new
IO.foreach('input.txt') do |line|
  gear_ratios_1.add line.strip
end
result = gear_ratios_1.numbers_with_neighbours.sum
puts "What is the sum of all of the part numbers in the engine schematic? #{result}"

# now we need to check the ones with * for the gear ratios
# For this one to work I can make a connection link, marking an area
gear_rations_2 = GearRatios.new
IO.foreach('input.txt') do |line|
  gear_rations_2.add line.strip
end
result_2 = gear_rations_2.ratio_of_neighbours
puts "What is the sum of all of the gear ratios in your engine schematic? #{result_2}"
