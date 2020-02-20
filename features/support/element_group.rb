class ElementGroup
  attr_accessor :value
  def initialize(type, value)
    @value = Hash[:type => type, :value => value]
  end

  def get_elements(wait_time = 30)
    exception = ""
    start = Time.now
    while (Time.now - start) < wait_time
      begin
        el_list = $driver.find_elements(@value[:type], @value[:value])
        raise "Element list is empty" if el_list.empty?
      return el_list
      rescue => e
        exception = e
        p "again, #{@value[:value]}"
        sleep(0.1)
      end
    end
    raise "Element #{@value[:value]} is not visible after #{wait_time} seconds \n Exception: #{exception}"
  end


  def click_by_text(text)
    get_elements.find_by_text(text).click
  end

  def scroll_to_exact(text)
    get_elements.scroll_to_exact(text)
  end

  def scroll_to_elements(scroll_time = 30)
    window_hash = get_window_sizes
    exception = ""
    start = Time.now
    while (Time.now - start) < scroll_time
      begin
        p "Entering in --begin"
        el = get_elements(2)
        p el
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
      to: window.height / 6,
      middle: window.width / 2,
      duration: 800
    }
    return sizes
  end

end
