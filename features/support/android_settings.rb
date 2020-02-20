
class AndroidSettings
  attr_reader :unpair_bluetooth_devices
  def initialize(options)
    @sn = options['sn']
    @os_version = `adb -s #{@sn} shell getprop ro.build.version.release`
    @apk = options['app']
    @app_package = options['appPackage']
  end

  def uninstall_app
    # `adb -s #{@sn} uninstall io.appium.uiautomator2.server`
    # `adb -s #{@sn} uninstall io.appium.uiautomator2.server.test`
    #`adb -s #{@sn} uninstall io.appium.unlock`
    #`adb -s #{@sn} uninstall io.appium.settings`
    `adb -s #{@sn} uninstall #{@app_package}`
  end

  def install_app_with_permissions
    `adb -s #{@sn} install -g #{@apk}`
  end

  def install_app_without_permissions
    `adb -s #{@sn} install #{@apk}`
  end

  def reinstall_app_with_permissions
    uninstall_app
    install_app_with_permissions
  end

  def reinstall_app_without_permissions
    uninstall_app
    install_app_without_permissions
  end

  def gps_enabled
    `adb -s #{@sn} shell settings put secure location_providers_allowed +gps`
  end

  def gps_disabled
    `adb -s #{@sn} shell settings put secure location_providers_allowed -gps`
  end

  def bluetooth_disabled
    bluetooth_state = `adb shell dumpsys bluetooth_manager | grep state: | head -1`
    if bluetooth_state.to_s.include?('state: ON')
      bluetooth_bool = `adb shell settings get global bluetooth_disabled_profiles`
      p "bluetooth_state: #{bluetooth_state}"
      p "bluetooth_bool: #{bluetooth_bool}"
      if bluetooth_bool.to_s.include?("1")
        p "if branch"
        `adb shell settings put global bluetooth_disabled_profiles 0`
      else
        p "else branch"
        `adb shell settings put global bluetooth_disabled_profiles 1`
      end
    end
    sleep(2)
  end

  def bluetooth_enabled
    bluetooth_state = `adb shell dumpsys bluetooth_manager | grep state: | head -1`
    unless bluetooth_state.to_s.include?('state: ON')
      `adb -s #{@sn} shell am start -a android.bluetooth.adapter.action.REQUEST_ENABLE`
    end
  end

  # def bluetooth_disabled
  #   unless @os_version.to_i < 8
  #     `adb -s #{@sn} shell am start -a android.bluetooth.adapter.action.REQUEST_DISABLE`
  #   end
  # end

  def navigate_to_bluetooth_settings
    p "Device name #{$device_name}"
    if $device_name.to_s.include?("SM")
      `adb -s #{@sn} shell am start -a android.settings.WIRELESS_SETTINGS`
    else
      `adb -s #{@sn} shell am start -a android.settings.BLUETOOTH_SETTINGS`
    end
  end

  def kill_native_settings_activity
    `adb shell pm clear com.android.settings`
  end

  def close_android_settings
    `adb -s #{@sn} shell am force-stop com.android.settings`
  end

  def open_eargo_app
    `adb -s #{@sn} shell am start -n com.eargo.app/com.eargo.app.activity.SplashActivity`
  end

  def app_activity
    app_activity = `adb -s #{@sn} shell pidof com.eargo.app`
    p app_activity
    unless app_activity.empty?
      sleep(3)
    end
  end

  def check_if_wifi_enabled
    wifi_check = `adb -s #{@sn} shell dumpsys wifi | grep "Wi-Fi is"`
    p wifi_check
    if wifi_check.to_s.include?("disabled")
      sleep(2)
      `adb -s #{@sn} shell am start -a android.settings.WIFI_SETTINGS`
    end
  end

end
