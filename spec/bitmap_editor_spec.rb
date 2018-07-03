require "bitmap_editor"

describe BitmapEditor do
  describe ".getCommand" do
    context "given an empty string or EOL" do
      it "returns array with empty string" do
        expect(BitmapEditor.new.getCommand('')).to eql([])
        expect(BitmapEditor.new.getCommand("\r")).to eql([])
        expect(BitmapEditor.new.getCommand("\r\n")).to eql([])
        expect(BitmapEditor.new.getCommand("\n")).to eql([])
      end
    end
    context "given a line with EOL" do
      it "returns a correct command" do
        expect(BitmapEditor.new.getCommand("I 5 6\n")).to eql(['I', '5', '6'])
        expect(BitmapEditor.new.getCommand("C\r\n")).to eql(['C'])
        expect(BitmapEditor.new.getCommand("S\r")).to eql(['S'])
      end
    end
    context "given a line with command" do
      it "returns a correct command" do
        expect(BitmapEditor.new.getCommand('I 0 0')).to eql(['I', '0', '0'])
        expect(BitmapEditor.new.getCommand('I 1 1')).to eql(['I', '1', '1'])
        expect(BitmapEditor.new.getCommand('I 50 60')).to eql(['I', '50', '60'])
        expect(BitmapEditor.new.getCommand('C')).to eql(['C'])
        expect(BitmapEditor.new.getCommand('L 10 20 A')).to eql(['L', '10', '20', 'A'])
        expect(BitmapEditor.new.getCommand('V 5 10 20 B')).to eql(['V', '5', '10', '20', 'B'])
        expect(BitmapEditor.new.getCommand('H 10 15 25 C')).to eql(['H', '10', '15', '25', 'C'])
        expect(BitmapEditor.new.getCommand('S')).to eql(['S'])
      end
    end
  end

  describe ".createImage?" do
    context "invalid arguments" do
      it "returns false" do
        expect(BitmapEditor.new.createImage?(0, 0)).to eql(false)
        expect(BitmapEditor.new.createImage?(0, 1)).to eql(false)
        expect(BitmapEditor.new.createImage?(1, 0)).to eql(false)
        expect(BitmapEditor.new.createImage?(300, 300)).to eql(false)
        expect(BitmapEditor.new.createImage?(100, 300)).to eql(false)
        expect(BitmapEditor.new.createImage?(300, 100)).to eql(false)
      end
    end
    context "valid arguments" do
      it "returns true" do
        expect(BitmapEditor.new.createImage?(1, 1)).to eql(true)
        expect(BitmapEditor.new.createImage?(10, 10)).to eql(true)
        expect(BitmapEditor.new.createImage?(250, 250)).to eql(true)
        expect(BitmapEditor.new.createImage?(5, 6)).to eql(true)
        expect(BitmapEditor.new.createImage?(60, 50)).to eql(true)
      end
    end
    context "test new image" do
      it "empty image on create 1x1" do
        bitmap = BitmapEditor.new
        expect(bitmap.createImage?(1, 1)).to eql(true)
        expect(bitmap.getPixels()).to eql(['O'])
      end
      it "empty image on create 2x3" do
        bitmap = BitmapEditor.new
        expect(bitmap.createImage?(2, 3)).to eql(true)
        expect(bitmap.getPixels()).to eql(['O', 'O', 'O', 'O', 'O', 'O'])
      end
    end
  end

  describe ".getIndex" do
    context "callcaulate index by X & Y" do
      it "returns nil value for image 10x10" do
        bitmap = BitmapEditor.new
        bitmap.createImage?(10, 10);
        expect(bitmap.getIndex(0, 0)).to eql(nil)
        expect(bitmap.getIndex(0, 1)).to eql(nil)
        expect(bitmap.getIndex(1, 0)).to eql(nil)
        expect(bitmap.getIndex(11, 1)).to eql(nil)
        expect(bitmap.getIndex(1, 11)).to eql(nil)
        expect(bitmap.getIndex(12, 12)).to eql(nil)
      end
      it "returns value for image 10x10" do
        bitmap = BitmapEditor.new
        bitmap.createImage?(10, 10);
        expect(bitmap.getIndex(1, 1)).to eql(0)
        expect(bitmap.getIndex(2, 1)).to eql(1)
        expect(bitmap.getIndex(3, 1)).to eql(2)
        expect(bitmap.getIndex(10, 1)).to eql(9)
        expect(bitmap.getIndex(11, 1)).to eql(nil)
        expect(bitmap.getIndex(1, 2)).to eql(10)
        expect(bitmap.getIndex(2, 2)).to eql(11)
        expect(bitmap.getIndex(2, 3)).to eql(21)
      end
      it "returns value for image 20x10" do
        bitmap = BitmapEditor.new
        bitmap.createImage?(20, 10);
        expect(bitmap.getIndex(1, 1)).to eql(0)
        expect(bitmap.getIndex(2, 1)).to eql(1)
        expect(bitmap.getIndex(3, 1)).to eql(2)
        expect(bitmap.getIndex(10, 1)).to eql(9)
        expect(bitmap.getIndex(11, 1)).to eql(10)
        expect(bitmap.getIndex(12, 1)).to eql(11)
        expect(bitmap.getIndex(13, 1)).to eql(12)
        expect(bitmap.getIndex(20, 1)).to eql(19)
        expect(bitmap.getIndex(21, 1)).to eql(nil)
        expect(bitmap.getIndex(1, 2)).to eql(20)
        expect(bitmap.getIndex(2, 2)).to eql(21)
        expect(bitmap.getIndex(20, 2)).to eql(39)
        expect(bitmap.getIndex(20, 3)).to eql(59)
      end
    end
  end

  describe ".isCorrectIndex?" do
    context "check index" do
      it "returns false" do
        bitmap = BitmapEditor.new
        bitmap.createImage?(20, 10);
        expect(bitmap.isCorrectIndex?(nil)).to eql(false)
        expect(bitmap.isCorrectIndex?(-1)).to eql(false)
        expect(bitmap.isCorrectIndex?(200)).to eql(false)
        expect(bitmap.isCorrectIndex?(300)).to eql(false)
      end
      it "returns true" do
        bitmap = BitmapEditor.new
        bitmap.createImage?(20, 10);
        expect(bitmap.isCorrectIndex?(0)).to eql(true)
        expect(bitmap.isCorrectIndex?(1)).to eql(true)
        expect(bitmap.isCorrectIndex?(50)).to eql(true)
        expect(bitmap.isCorrectIndex?(100)).to eql(true)
        expect(bitmap.isCorrectIndex?(199)).to eql(true)
      end
    end
  end

  describe ".clearImage" do
    it "correct clear image" do
      bitmap = BitmapEditor.new
      bitmap.createImage?(3, 3)
      expect(bitmap.getPixels()).to eql(['O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O'])
      
      bitmap.clearImage('X')
      expect(bitmap.getPixels()).to eql(['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'])

      bitmap.drawPixel(1, 1, 'A')
      bitmap.drawPixel(2, 1, 'B')
      bitmap.drawPixel(3, 1, 'C')
      expect(bitmap.getPixels()).to eql(['A', 'B', 'C', 'X', 'X', 'X', 'X', 'X', 'X'])

      bitmap.clearImage()
      expect(bitmap.getPixels()).to eql(['O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O'])
    end
  end

  describe ".drawPixel" do
    it "correct draw pixels" do
      bitmap = BitmapEditor.new
      bitmap.createImage?(3, 3)

      bitmap.drawPixel(0, 0, 'X')
      bitmap.drawPixel(4, 4, 'X')
      expect(bitmap.getPixels()).to eql(['O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O'])

      bitmap.drawPixel(1, 1, 'A')
      bitmap.drawPixel(2, 1, 'B')
      bitmap.drawPixel(3, 1, 'C')
      bitmap.drawPixel(1, 2, 'D')
      bitmap.drawPixel(2, 2, 'E')
      bitmap.drawPixel(3, 2, 'F')
      bitmap.drawPixel(1, 3, 'G')
      bitmap.drawPixel(2, 3, 'H')
      bitmap.drawPixel(3, 3, 'I')
      expect(bitmap.getPixels()).to eql(['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'])
    end
  end

  describe ".drawHorizontalLine" do
    it "correct draw horizontal line" do
      bitmap = BitmapEditor.new
      bitmap.createImage?(3, 3)

      bitmap.drawHorizontalLine(1, 3, 1, 'A')
      expect(bitmap.getPixels()).to eql(['A', 'A', 'A', 'O', 'O', 'O', 'O', 'O', 'O'])

      bitmap.drawHorizontalLine(3, 1, 2, 'B')
      expect(bitmap.getPixels()).to eql(['A', 'A', 'A', 'B', 'B', 'B', 'O', 'O', 'O'])

      bitmap.drawHorizontalLine(0, 4, 3, 'C')
      expect(bitmap.getPixels()).to eql(['A', 'A', 'A', 'B', 'B', 'B', 'C', 'C', 'C'])

      bitmap.drawHorizontalLine(2, 2, 2, 'X')
      expect(bitmap.getPixels()).to eql(['A', 'A', 'A', 'B', 'X', 'B', 'C', 'C', 'C'])
    end
  end

  describe ".drawVerticalLine" do
    it "correct draw vertical line" do
      bitmap = BitmapEditor.new
      bitmap.createImage?(3, 3)

      bitmap.drawVerticalLine(1, 1, 3, 'A')
      expect(bitmap.getPixels()).to eql(['A', 'O', 'O', 'A', 'O', 'O', 'A', 'O', 'O'])

      bitmap.drawVerticalLine(2, 3, 1, 'B')
      expect(bitmap.getPixels()).to eql(['A', 'B', 'O', 'A', 'B', 'O', 'A', 'B', 'O'])

      bitmap.drawVerticalLine(3, 0, 4, 'C')
      expect(bitmap.getPixels()).to eql(['A', 'B', 'C', 'A', 'B', 'C', 'A', 'B', 'C'])

      bitmap.drawVerticalLine(2, 2, 2, 'X')
      expect(bitmap.getPixels()).to eql(['A', 'B', 'C', 'A', 'X', 'C', 'A', 'B', 'C'])
    end
  end

  describe ".showImage" do
    it "empty show for empty image" do
      expect do
        bitmap = BitmapEditor.new
        bitmap.showImage()
      end.to output("\n").to_stdout
    end
    it "correct show image 1x1" do
      expect do
        bitmap = BitmapEditor.new
        bitmap.createImage?(1, 1)
        bitmap.showImage()
      end.to output("O\n").to_stdout
    end
    it "correct show image 3x1" do
      expect do
        bitmap = BitmapEditor.new
        bitmap.createImage?(3, 1)
        bitmap.showImage()
      end.to output("OOO\n").to_stdout
    end
    it "correct show image 3x3" do
      expect do
        bitmap = BitmapEditor.new
        bitmap.createImage?(3, 4)
        bitmap.drawHorizontalLine(1, 3, 1, 'A')
        bitmap.drawHorizontalLine(1, 3, 2, 'B')
        bitmap.drawHorizontalLine(1, 3, 3, 'C')
        bitmap.showImage()
      end.to output("AAA\nBBB\nCCC\nOOO\n").to_stdout
    end
  end

  describe ".run" do
    context "scenario" do
      it "data from the test" do
        expect do
          BitmapEditor.new.run(['I 5 6', 'L 1 3 A', 'V 2 3 6 W', 'H 3 5 2 Z', 'S'])
        end.to output("OOOOO\nOOZZZ\nAWOOO\nOWOOO\nOWOOO\nOWOOO\n").to_stdout
      end
      it "image size 12x4" do
        expect do
          BitmapEditor.new.run(['I 12 4', 'L 12 4 X', 'S'])
        end.to output("OOOOOOOOOOOO\nOOOOOOOOOOOO\nOOOOOOOOOOOO\nOOOOOOOOOOOX\n").to_stdout
      end
      it "min image" do
        expect do
          BitmapEditor.new.run(['I 1 1', 'L 1 1 X' , 'S'])
        end.to output("X\n").to_stdout
      end
      it "empty image" do
        expect do
          BitmapEditor.new.run(['S'])
        end.to output("\n").to_stdout
      end
    end

    context "wrong commands" do
      it "wrong image size" do
        expect do
          BitmapEditor.new.run(['I 500 600', 'S'])
        end.to raise_error("Wrong image size")
      end
      it "skip empty lines" do
        expect do
          BitmapEditor.new.run(['', "\r\n", "\r", "\n", 'A'])
        end.to raise_error("Unrecognised command 'A'")
      end
      it "unrecognised command" do
        expect do
          BitmapEditor.new.run(['A'])
        end.to raise_error("Unrecognised command 'A'")
        expect do
          BitmapEditor.new.run(['B'])
        end.to raise_error("Unrecognised command 'B'")
      end
    end
  end
end
