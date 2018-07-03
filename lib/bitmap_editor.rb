class BitmapEditor

  COLOR_DEFAULT = 'O';

  WIDTH_MIN = 1;
  WIDTH_MAX = 250;

  HEIGHT_MIN = 1;
  HEIGHT_MAX = 250;

  def initialize()
     @width = 0
     @height = 0
     @size = 0
     @pixels = nil
  end

  def run(lines)
    lines.each do |line|
      command = getCommand(line)
      case command[0]
      when 'I'
        if true != createImage?(command[1].to_i, command[2].to_i)
           raise "Wrong image size"
        end
      when 'L'
        drawPixel(command[1].to_i, command[2].to_i, command[3])
      when 'H'
        drawHorizontalLine(command[1].to_i, command[2].to_i, command[3].to_i, command[4])
      when 'V'
        drawVerticalLine(command[1].to_i, command[2].to_i, command[3].to_i, command[4])
      when 'S'
        showImage()
      when nil
        # skip empty line
      when ''
        # skip empty line
      else
        raise "Unrecognised command '#{command[0]}'"
      end
    end
  end

  def getCommand(line)
    return line.chomp.split
  end

  def createImage?(width, height)
    if width < WIDTH_MIN || width > WIDTH_MAX || height < HEIGHT_MIN || height > HEIGHT_MAX
      return false;
    end
    @size = width * height
    @width = width
    @height = height
    @pixels = Array.new(@size, COLOR_DEFAULT)
    return true;
  end

  def clearImage(color = COLOR_DEFAULT)
    @size.times do |i|
      @pixels[i] = color;
    end
  end

  def getIndex(x, y)
    if x < 1 || x > @width || y < 1 || y > @height
      return nil
    end
    return (x - 1) + ((y - 1) * @width);
  end

  def isCorrectIndex?(index) 
    return index != nil && index >= 0 && index < @size
  end

  def drawPixel(x, y, color)
    index = getIndex(x, y)
    if isCorrectIndex?(index)
      @pixels[index] = color
    end
  end

  def drawHorizontalLine(x1, x2, y, color)
    if x1 > x2 
      x1, x2 = x2, x1
    end
    for x in x1..x2
      drawPixel(x, y, color)
    end
  end

  def drawVerticalLine(x, y1, y2, color)
    if y1 > y2 
      y1, y2 = y2, y1
    end
    for y in y1..y2
      drawPixel(x, y, color)
    end
  end

  def getPixels()
    return @pixels
  end

  def showImage()
    if @size != 0
      @size.times do |index|
        if index > 0 && index % @width === 0
          puts ''
        end
        print @pixels[index]
      end
    end
    puts ''
  end

end
