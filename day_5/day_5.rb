require_relative "input.rb"

class DayFive
  attr_reader :coordinates

  def initialize(raw_coordinates)
    @coordinates = build_coords(raw_coordinates)
    @graph = initialize_graph
  end

  def part_one
    draw_horizontal_and_vertical_lines

    count_crossing_points
  end

  def part_two
    # Reinitialize graph
    @graph = initialize_graph
    # Draw horizontal and vertical lines
    draw_horizontal_and_vertical_lines
    # Draw diagonal lines
    draw_diagonal_lines

    count_crossing_points
  end

  private

  def count_crossing_points
    @graph.reduce(0) do |count, lines|
      count += lines.select { |value| value >= 2 }.length
    end
  end

  def draw_diagonal_lines
    diagonal_lines.each do |line|
      starting_x = line[0][:x]
      starting_y = line[0][:y]
      ending_x = line[1][:x]
      ending_y = line[1][:y]

      y_range = ending_y > starting_y ? (starting_y..ending_y) : (ending_y..starting_y)
      x_range = if y_range.first == starting_y
                  starting_x > ending_x ? starting_x.downto(ending_x) : starting_x.upto(ending_x)
                else
                  ending_x > starting_x ? ending_x.downto(starting_x) : ending_x.upto(starting_x)
                end.to_a

      y_range.each_with_index do |y_idx, idx|
        @graph[y_idx][x_range[idx]] += 1
      end
    end
  end

  def draw_horizontal_and_vertical_lines
    vertical_and_horizontal_lines.each do |line|
      starting_x = line[0][:x]
      starting_y = line[0][:y]

      ending_x = line[1][:x]
      ending_y = line[1][:y]

      if starting_y == ending_y
        range = starting_x < ending_x ? (starting_x..ending_x) : (ending_x..starting_x)
        range.each do |x_index|
          @graph[starting_y][x_index] += 1
        end
      elsif starting_x == ending_x
        range = starting_y < ending_y ? (starting_y..ending_y) : (ending_y..starting_y)
        range.each do |y_index|
          @graph[y_index][starting_x] += 1
        end
      else
        @graph[starting_y][starting_x] += 1
      end
    end
  end

  def build_coords(raw_data)
    raw_data.split("\n").map { |coordinates_pair| coordinates_pair.split(" -> ") }.map do |coordinates_pair|
      coordinates_pair.map do |pair|
        x, y = pair.split(",").map(&:to_i)
        {
          x: x,
          y: y
        }
      end
    end
  end

  def initialize_graph
    max_x = @coordinates.map { |coords_pair| [coords_pair[0][:x], coords_pair[1][:x]].max }.max
    max_y = @coordinates.map { |coords_pair| [coords_pair[0][:y], coords_pair[1][:y]].max }.max
    graph = []

    vertical = 0
    while vertical <= max_y
      horizontal = 0
      row = []
      while horizontal <= max_x
        row << 0
        horizontal += 1
      end
      graph << row
      vertical += 1
    end
    graph
  end

  def vertical_and_horizontal_lines
    @coordinates.select do |line|
      line[0][:x] == line[1][:x] || line[0][:y] == line[1][:y]
    end
  end

  def diagonal_lines
    @coordinates.reject do |line|
      line[0][:x] == line[1][:x] || line[0][:y] == line[1][:y]
    end
  end
end

solution = DayFive.new(Input::DATA)
p solution.part_one # 6113
p solution.part_two # 20373
