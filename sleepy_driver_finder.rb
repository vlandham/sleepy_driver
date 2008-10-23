require 'fileutils'
require './lib/eye_grabber'
require './lib/eye_diagnoser'
require './lib/eye_drawer'

filename = "./data/images/"
yaml_file = "./data/all_eyes.yaml"
out_folder = "./data/result/"
eye_folder = "./data/eyes/"

eyes = EyeGrabber.new(filename,yaml_file)

doctor = EyeDiagnoser.new(eye_folder)
drawer = EyeDrawer.new(filename)

count = 0
min_to_sleep = 3

eyes.each do |left_eye, right_eye| 
  # puts left_eye.name
  diagnosis_l = doctor.diagnose(left_eye)
  diagnosis_r = doctor.diagnose(right_eye)
  
  # diagnosis depends on both eyes
  if(diagnosis_l == diagnosis_r)
    diagnosis = diagnosis_l
  else
    diagnosis = :awake
  end
 
  # is he really sleeping?
  if(diagnosis == :awake)
    count -= 1
    count = 0 if count < 0
  elsif count < min_to_sleep
    diagnosis = :awake
    count += 1
    count = (min_to_sleep*2) if count > (min_to_sleep*2)
  else
    count += 1
  end
  
  # puts diagnosis.to_s
  # puts count.to_s
  
  # both left eye and right eye should have the same name
  drawer.add(left_eye.name, diagnosis)
end

drawer.save(out_folder)
