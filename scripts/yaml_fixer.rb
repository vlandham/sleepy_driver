# !!!!!!!
# Shouldn't be needed anymore -- the eye_spy does this already now.
# !!!!!!!
require 'yaml'
temp_eyes = YAML::load_stream(File.new(yaml_file))
docs = temp_eyes.documents
File.open("all_eyes.yaml","w") do |f|
  f << docs.to_yaml
end
