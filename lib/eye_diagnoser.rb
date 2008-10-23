require 'RMagick'
include Magick

# can be :awake or :sleep
class EyeDiagnoser
  def initialize(eye_folder)
    @count = 0
    @threshold = 1000
    @eye_folder = eye_folder
    
    puts "removing #{@eye_folder}"
    FileUtils.rm_rf @eye_folder
    puts "recreating #{@eye_folder}"
    FileUtils.mkdir_p @eye_folder
  end
  
  def diagnose(eye_image)
    rmagick_image = eye_image.image
    rmagick_image = rmagick_image.normalize
    # rmagick_image = rmagick_image.equalize
    # rmagick_image = rmagick_image.adaptive_sharpen(2,1)
    # rmagick_image = rmagick_image.edge(4.0)
    # rmagick_image = rmagick_image.despeckle
    rmagick_image = rmagick_image.threshold(Magick::QuantumRange*0.18)
    
    base_name = eye_image.name
    puts base_name
    rmagick_image.write("#{@eye_folder}/eye-#{base_name}")
    @count += 1;
    pixels = rmagick_image.get_pixels(0,0,rmagick_image.columns, rmagick_image.rows)
    pixels.map! {|r| (r.red.to_f/QuantumRange.to_f - 1 ).abs} # !! Flipping binary values !!
    # puts "pixels size: #{pixels.size}"
    
    sum = pixels.inject(0) {|su,val| su += val}
    puts "sum: #{sum}"
    
    cols = rmagick_image.columns
    rows = rmagick_image.rows
    
    # puts "cols: #{cols} rows: #{rows}"
    
    xy_mom = moment(pixels,cols, rows, 1,1)
    
    y_mom = moment(pixels,cols, rows, 0,1)
    x_mom = moment(pixels,cols,rows, 1,0)
    area =  moment(pixels, cols, rows, 0,0)
    # puts "area: #{area}"
    # puts "x y mom: #{xy_mom}"
    
    u_xy =( xy_mom - (y_mom*x_mom / area))
    # puts "mom u_xy: #{u_xy}"
    
    # u_yy = moment(pixels,cols,rows,0,2) - ((moment(pixels,cols,rows,0,1)**2)/moment(pixels,cols,rows,0,0))
    # puts "mom: u_yy: #{u_yy}"
    
    total = u_xy.abs
    puts "result : #{total}"

    value = nil
    # puts total
    if total < @threshold
      value = :awake
    else
      value = :sleep
    end
    puts value
    value
  end
  
  def moment(array,cols,rows,x_power,y_power)
    # puts "#{cols} cols and #{rows} rows"
    # puts "array size: #{array.length}"
    sum = 0
    (0...rows).each do |cur_row|
      (0...cols).each do |cur_col|
        tmp = ((cur_row**x_power) * (cur_col**y_power) * array[cols*cur_row+cur_col])
        # puts "tmp: #{tmp}"
        sum += tmp
      end #cur col
    end #cur row
    sum
  end
  
end