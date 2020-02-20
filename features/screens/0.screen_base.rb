require_relative '../support/android_settings'

class ScreenBase
  def initialize
    #Samsung S8, HTC
    @native_bluetooth_settings = Element.new(:xpath, "//*[@text='Bluetooth']")
    @device_details_cog_btn = Element.new(:accessibility_id, "Device settings") # Also for HTC
    @unpair_btn = Element.new(:xpath, "//*[@text= 'Unpair']") # Also for HTC

    #Huawei
    @huawei_device_details_info_btn = Element.new(:accessibility_id, "Details")
    @huawei_unpair_btn = Element.new(:xpath, "//*[@text= 'UNPAIR']")

    #OnePlus
    @oneplus_device_details_cog_btn = Element.new(:accessibility_id, "Settings")
    @bt_forget_btn = Element.new(:id, "android:id/button3")

    # Pixel
    @pixel_device_details_cog_btn = Element.new(:accessibility_id, "Settings")
    @pixel_forget_btn = Element.new(:id, "com.android.settings:id/button1")
    @pixel_forget_popup_btn = Element.new(:id, "android:id/button1")

    # Wifi toggles
    #@wifi_toggle = Element.new(:id, "com.android.settings:id/switch_widget")
    @wifi_toggle = Element.new(:xpath, "//android.widget.Switch")

    # Bluetooth pop up elements
    @bluetooth_pop_up_title = Element.new(:xpath, "//*[contains(@text,'Bluetooth')]")
    @bluetooth_pop_up_allow = Element.new(:id, "android:id/button1")
    @bluetooth_switch = Element.new(:xpath, "//android.widget.Switch")
  end


  def unpair_bluetooth_devices(device_model)
    p "Check paired devices"
    p "Device model: #{device_model}"
    if device_model.to_s.include?("SM")
      p "Checking Samsung"
      begin
        @native_bluetooth_settings.visible(wait_time: 10)
        @native_bluetooth_settings.click
      rescue
        p "Native bluetooth settings button is not visible!"
      end

      begin
        while @device_details_cog_btn.visible(wait_time: 5)
          @device_details_cog_btn.click
          @unpair_btn.click
        end
      rescue
        p "Paired devices are no longer visible!"
      end

    elsif device_model.to_s.include?("ONEPLUS")
      p "Checking ONEPLUS"
      begin
        while @oneplus_device_details_cog_btn.visible(wait_time: 5)
          @oneplus_device_details_cog_btn.click
          @bt_forget_btn.click
        end
      rescue
        p "Paired devices are no longer visible!"
      end

    elsif device_model.to_s.include?("HUAWEI")
      p "Checking Huawei"
      begin
        while @huawei_device_details_info_btn.visible(wait_time: 5)
          @huawei_device_details_info_btn.click
          @huawei_unpair_btn.click
        end
      rescue
        p "Paired devices are no longer visible!"
      end

    elsif device_model.to_s.include?("Pixel")
      begin
        while @pixel_device_details_cog_btn.visible(wait_time: 5)
          @pixel_device_details_cog_btn.click
          @pixel_forget_btn.click
          @pixel_forget_popup_btn.click
        end
      rescue
        p "Paired devices are no longer visible!"
      end
    elsif device_model.to_s.include?("HTC")
      begin
        while @device_details_cog_btn.visible(wait_time: 5)
          @device_details_cog_btn.click
          @unpair_btn.click
        end
      rescue
          p "Paired devices are no longer visible!"
        end
    end
  end

  def toggle_wifi
    p @wifi_toggle.text
    if @wifi_toggle.text == "Off"
      @wifi_toggle.click
    end
  end

  # def toggle_bluetooth
  #   p @bluetooth_switch.text
  #   if @bluetooth_switch.text == "Off"
  #     @bluetooth_switch.click
  #   end
  # end

  def accept_bluetooth_pop_up
    @bluetooth_pop_up_title.visible
    @bluetooth_pop_up_allow.click
  end

end
