# This file provides setup and common functionality across all features.  It's
# included first before every test run, and the methods provided here can be
# used in any of the step definitions used in a test.  This is a great place to
# put shared data like the location of your app, the capabilities you want to
# test with, and the setup of selenium.

require 'rspec/expectations'
require 'appium_lib'
require_relative 'server'
require_relative 'android_settings'

# Create a custom World class so we don't pollute `Object` with Appium methods
class AppiumWorld
end

# TODO pass device option dynamicaly to allow simultaneous runs on different devices
options = {
  'port' => ENV['port'],
  'portboot' => ENV['boot_port'],
  'sn' => ENV['sn'],
  'app' => ENV['apk'],
  'appPackage' => 'com.eargo.ultrasound'
}

native_andr_settings = AndroidSettings.new(options)
#native_andr_settings.reinstall_app_with_permissions

server = Server.new(options)
server.start
server.wait_to_boot

# TODO move desired caps to config file
desired_capabilities = {
  'deviceName' => options['sn'],
  'platformName' => 'Android',
  'appActivity' => 'com.eargo.ultrasound.MainActivity',
  'appPackage' => options['appPackage'],
  'noReset' => 'true',
  'automationName' => 'UiAutomator2',
  'autoGrantPermissions' => 'true',
  "unlockType": "pin",
  "unlockKey": "0000"
  #'app' => options['app'],
}
# TODO get rid of global $driver variable
$driver = Appium::Driver.new(caps: desired_capabilities, appium_lib: { server_url: "http://localhost:#{options['port']}/wd/hub" })
World do
  AppiumWorld.new
end

Before do
  @screens = Screens.new
  $driver.start_driver
  $device_name = `adb -s #{options['sn']} shell getprop ro.product.brand ; adb -s #{options['sn']} shell getprop ro.product.model`
  $width = $driver.window_size.width
  $height = $driver.window_size.height
end

def add_screenshot(scenario_name, device)
  scenario_name.tr!(" ", "_")
  local_name = "reports/#{device}-#{scenario_name}.png"
  $driver.screenshot(local_name)
  embed(local_name, 'image/png', "#{device}-SCREENSHOT")
end

After do
  $driver.driver_quit
end


After do |scenario|
  add_screenshot(scenario.name, options['sn']) if scenario.failed?
end

