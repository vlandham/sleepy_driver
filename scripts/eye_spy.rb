require 'yaml'
IMGDIR = "../data/images/"

Shoes.app :title => "EyeSpy" do
  @images = Dir.new(IMGDIR).to_a.reject {|f| f.to_s !~ /\.jpg$/} 
  @eyes = Array.new
  @ystream = YAML::Stream.new()
  
  # @cross_x = oval
  # @cross_y

  def next_image  
    @images.shift
    @img.path = IMGDIR+@images[0]
    @status.replace "current image: #{@images[0]}"
  end
  
  def save_yaml
    docs = @ystream.documents
    File.open('../data/eyes_raw.yaml', 'w') do |out| 
      out << docs.to_yaml
    end    
  end
  
  def undo
    unless @eyes.empty?
      last_eye = @eyes.pop
      last_eye.remove
    end
  end
  
  def save_eyes
    # add the current eyes to the stream
    unless @eyes.empty?
      @ystream.add(@img.path.split('/')[-1] => {'eye1' => {'x' => @eyes[0].left, 'y' => @eyes[0].top},
      'eye2' => {'x' => @eyes[1].left, 'y' => @eyes[1].top}})
      @eyes.each do |eye|
        eye.remove
      end
      @eyes = Array.new
    end
  end
  
  stack :width => 1.0 do
    @img = image IMGDIR+@images.shift 
    button "Next" do
      save_eyes
      next_image
    end
    
    button "Done" do
      save_yaml
    end
    
    button "Undo" do
      undo
    end
    
    @status = para @img.path  
  end
  
  click do |button, x, y| 
    @eyes.push oval( :top => y, :left => x, :radius => 5, :center => true)
  end
  
  keypress do |key|
    case key
    when 'n'
      save_eyes
      next_image
    end
  end
  
  motion do |x,y|
    
  end 
end