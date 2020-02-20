def swipe(start_x:, start_y:, end_x:, end_y:, duration: 300)
  $swipe = Appium::TouchAction.new.swipe(start_x: start_x,
                                         start_y: start_y,
                                         end_x: end_x,
                                         end_y: end_y,
                                         duration: duration
                                         ).perform
end

def width
  $width = $driver.window_size.width
end

def height
  $height = size_of_screen.height
end

def close_app
 $driver.close_app
end

def open_app
 $driver.launch_app
end

def back_button
 $driver.back
end

def background_app
  $driver.background_app(3)
end

def lock_device
  $driver.lock(5)
end

def unlock_device
  $driver.unlock
end