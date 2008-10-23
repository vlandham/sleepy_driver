require 'rubygems'
require 'RMagick'
require 'yaml'
include Magick

filename = "/Users/vlandham/Movies/sleep_driver_movies/images/"
yaml_file = "/Users/vlandham/Movies/sleep_driver_movies/eyes_all.yaml"

side_border = 22
top_bot_border = 17

temp_eyes = YAML::load(File.new(yaml_file))
eyes = Hash.new

# Get the coordinates into a hash keyed by the name of the image
# until i look at yaml more
temp_eyes.map {|t| eyes[t.keys[0]] = t.values[0]}

d = Dir.new(filename).reject {|f| f !~ /.*\.jpg$/}


d.each do |imagename|
  image = ImageList.new(filename+imagename)
  
  2.times do |i|
    puts "looking at: #{imagename}"
    x = eyes[imagename]["eye#{i+1}"]['x'].to_i
    y = eyes[imagename]["eye#{i+1}"]['y'].to_i
    real_x = x - side_border
    real_y = y - top_bot_border
    row = 2 * top_bot_border
    col = 2 * side_border
    puts "x: #{real_x}, #{x} y: #{real_y}, #{y}"
    pixs = image.get_pixels(real_x,real_y,col,row)
    rpixs = pixs.map {|r| r.red}
    
    new_eye = Image.constitute(col,row, 'R', rpixs)
    new_eye.store_pixels(0,0,col,row,pixs)
    new_eye.write("eyes/"+"#{imagename.split('.')[0]}-eye#{i+1}.png")
  end
  
end