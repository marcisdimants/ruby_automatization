class Element
    def initialize(type, value)
        @value = Hash[:type => type, :value => value]
    end

    def get_element(wait_time = 30)
      exception = ""
      start = Time.now
      while (Time.now - start) < wait_time
        begin
          el = $driver.find_element(@value[:type], @value[:value])
          return el
        rescue => e
          exception = e
          p "again, #{@value[:value]}"
          sleep(0.1)
        end
      end
      raise "Element #{@value[:value]} is not visible after #{wait_time} seconds \n Exception: #{exception}"
    end

    def click
      element = get_element
      element.click
    end

    def send_keys(keys)
      element = get_element
      element.send_keys(keys)
    end

    def enabled?
      element = get_element
      element.enabled?
    end

    def get_attribute(attribute)
      element = get_element
      element.attribute(attribute)
    end

    def clear
      element = get_element
      element.clear
    end

    def text
      element = get_element
      element.text
    end

    def selected
      element = get_element
      element.selected
    end

    def get_location
      element = get_element
      element.location
    end

    def size
      element = get_element
      element.size
    end

    def scroll_to_element(wait_time = 30)
    window_hash = get_window_sizes
    exception = ""
    start = Time.now
    while (Time.now - start) < wait_time
      begin
        p "Entering in --begin"
        el = get_element(2)
        return el
      rescue => e
        exception = e
        p "--scrolling down, #{@value[:type]}: #{@value[:value]}"
        scroll_down(window_hash)
        sleep(0.1)
      end
    end
  end

  def scroll_down(window_hash)
    $driver.swipe(start_x: window_hash[:middle], start_y: window_hash[:from],
                  end_x: window_hash[:middle], end_y: window_hash[:to],
                  duration: window_hash[:duration]
                )
  end


  def get_window_sizes
    window = $driver.window_size
    sizes = {
      width: window.width,
      height: window.height,
      from: window.height/ 2,
      to: window.height / 3,
      middle: window.width / 2,
      duration: 1600
    }
    return sizes
  end


end
