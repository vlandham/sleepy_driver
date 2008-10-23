require 'rubygems'
require 'RMagick'
require 'yaml'
include Magick

class EyeImage
  attr_accessor :image
  attr_accessor :name
  attr_accessor :side
  def initialize(image,file,side)
    @image = image
    @name = file
    @side = side
  end
end

class EyeGrabber
  def initialize(filename,yaml_filename)
    @side_border = 20
    @top_bot_border = 15
    
    @folder = filename
    temp_eyes = YAML::load(File.new(yaml_filename))
    @eyes = Hash.new
    # Get the coordinates into a hash keyed by the name of the image
    # until i look at yaml more
    temp_eyes.map {|t| @eyes[t.keys[0]] = t.values[0]}
    @image_folder = Dir.new(filename).reject {|f| f !~ /.*\.jpg$/}
  end
  
  def each
    @image_folder.each do |imagename|
      image = ImageList.new(@folder+imagename)
      eye_array = Array.new
      2.times do |i|
        return unless @eyes[imagename]
        # puts "looking at: #{imagename}"
        return unless @eyes[imagename]
        x = @eyes[imagename]["eye#{i+1}"]['x'].to_i
        y = @eyes[imagename]["eye#{i+1}"]['y'].to_i
        real_x = x - @side_border
        real_y = y - @top_bot_border
        row = 2 * @top_bot_border
        col = 2 * @side_border
        # puts "x: #{real_x}, #{x} y: #{real_y}, #{y}"
        pixs = image.get_pixels(real_x,real_y,col,row)
        rpixs = pixs.map {|r| r.red}

        new_eye = Image.constitute(col,row, 'R', rpixs)
        new_eye.store_pixels(0,0,col,row,pixs)
        eyeimage = EyeImage.new(new_eye,imagename,i)
        eye_array << eyeimage
        # new_eye.write("eyes/"+"#{imagename.split('.')[0]}-eye#{i+1}.png")
      end
      
      yield eye_array[0], eye_array[1]

    end
  end
end