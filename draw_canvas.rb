class DrawCanvas
  # attr_reader :output
  INPUT_MESSAGE = 'Input file does not exist. Please create input.txt with script'.freeze
  EXCEPTION = 'Not valid input file'.freeze

  def initialize
    @result = []
    @created = false
  end

  def call
    return INPUT_MESSAGE unless File.file?('input.txt')

    read_file
    write_file
    p 'Done'
  end

  private

  def read_file
    File.open('input.txt', 'r') do |f|
      f.each_line do |line|
        read_line(line.split(' '))
      end
    end
  end

  def write_file
    File.open('output.txt', 'w') do |f|
      f.truncate(0)
      @result.each do |field|
        field.each do |line|
          f.puts line
        end
      end
    end
  end

  def read_line(symbols)
    case symbols.first
    when 'C'
      @created = true
      draw_canvas(symbols[1].to_i, symbols[2].to_i)
    when 'L'
      raise EXCEPTION if symbols.size != 5 || !@created

      draw_line(symbols[1].to_i, symbols[2].to_i, symbols[3].to_i, symbols[4].to_i)
    when 'R'
      raise EXCEPTION if symbols.size != 5 || !@created

      draw_rect(symbols[1].to_i, symbols[2].to_i, symbols[3].to_i, symbols[4].to_i)
    when 'B'
      raise EXCEPTION if symbols.size != 4 || !@created

      add_color(symbols[1].to_i, symbols[2].to_i, symbols[3])
    end
  end

  def draw_canvas(cols, rows)
    field = []
    field << '-' * (cols + 2)
    rows.times do
      field << "|#{' ' * cols}|"
    end
    field << '-' * (cols + 2)
    @result << field
  end

  def prepare_line(field, x1, y1, x2, y2)
    (y1..y2).each do |i|
      (x1..x2).each do |j|
        field[i][j] = 'x'
      end
    end
    field
  end

  def draw_line(x1, y1, x2, y2)
    @result << prepare_line(@result.last.map(&:clone), x1, y1, x2, y2)
  end

  def draw_rect(x1, y1, x2, y2)
    field = @result.last.map(&:clone)
    field = prepare_line(field, x1, y1, x2, y1)
    field = prepare_line(field, x2, y1, x2, y2)
    field = prepare_line(field, x1, y1, x1, y2)
    field = prepare_line(field, x1, y2, x2, y2)
    @result << field
  end

  def add_color(x, y, color)
    field = @result.last.map(&:clone)
    field[y][x + 1] = color
    i = 0
    while(!['-','x'].include?(field[y + i][x + 1])) do
      field[y + i][x + 1] = color
      j = 1
      while(!['|','x'].include?(field[y + i][x + 1 + j])) do
        field[y + i][x + 1 + j] = color
        j += 1
      end
      j = -1
      while(!['|','x'].include?(field[y + i][x + 1 + j])) do
        field[y + i][x + 1 + j] = color
        j -= 1
      end
      i += 1
    end
    i = -1
    while(!['-','x'].include?(field[y + i][x + 1])) do
      field[y + i][x + 1] = color
      j = -1
      while(!['|','x'].include?(field[y + i][x + 1 + j])) do
        field[y + i][x + 1 + j] = color
        j -= 1
      end
      j = 1
      while(!['|','x'].include?(field[y + i][x + 1 + j])) do
        field[y + i][x + 1 + j] = color
        j += 1
      end
      i -= 1
    end
    @result << field
  end
end

DrawCanvas.new.call
