require 'fileutils'
dirname = "./data/images/"
dir = Dir.new(dirname)
FileUtils.cd(dirname)
dir.each do |mov|
  if(mov == "." || mov == "..")
    next
  else
    num = mov.split(".")[0].to_i
    if(num != 1 && num % 10 != 0)
      FileUtils.rm(mov)
    end
  end
end