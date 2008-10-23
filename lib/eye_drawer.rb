require 'RMagick'
include Magick

class EyeDrawer
  attr_reader :folder
  
  def initialize(folder_name)
    @folder = folder_name
    @images = ImageList.new()
    @width = 352
    @height = 288
    
    setup_icons
  end
  
  # type can be :awake or :sleep
  def add(image_name, type)
    image = Image.read(@folder+"/"+image_name)[0]
    # @width ||= image.columns
    # @height ||= image.rows
    add_type(image,type)
    @images << image
  end
  
  def add_type(image,type)
    if type == :awake
      @awake.draw(image)
    else
      @sleep.draw(image)
    end
  end
  
  def save(out_folder)
    puts "removing #{out_folder}"
    FileUtils.rm_rf out_folder
    puts "recreating #{out_folder}"
    FileUtils.mkdir_p(out_folder)
    @images.each do |image|
      base_name = image.filename.split("/")[-1]
      image.write("#{out_folder}#{base_name}")
    end
  end
  
  def setup_icons
    pos = [@width-50, @height-50, @width-40,@height-40]
    pos2 = [@width-80, @height-50, @width-70, @height-40]
    
    @awake = Draw.new
    # @awake.fill_opacity(0)
    @awake.stroke('green')
    # @awake.fill('green')
    @awake.stroke_width(8)
    @awake.circle(*pos)
    @awake.circle(*pos2)
    
    @sleep = Draw.new
    # @sleep.fill_opacity(0)
    @sleep.stroke('red')
    @sleep.stroke_width(10)
    @sleep.circle(*pos)
    @sleep.circle(*pos2)
    
  end
end