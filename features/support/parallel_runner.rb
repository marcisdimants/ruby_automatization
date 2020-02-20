require_relative 'android_runner'
require_relative 'adb'
require 'yaml'

class ParallelRunner
  def initialize(options)
    @options = options
    all_devices
    @options['port'] = 4005
    @options['boot_port'] = 5005
    @threads = []
    @port_counter = -1
  end

  def all_devices
    @devices_connected = Adb.connected_devices
    puts 'All connected devices:' + @devices_connected.to_s
  end

  def run_parallel
    $run_tests_on_next_device = true
    raise "\n0 devices connected!" if @devices_connected == []
    @devices_connected.each do |device|
      $run_tests_on_next_device = false
      @port_counter += 1
      runner_obj = RunnerAndroid.new(device, @options, @port_counter)
      @threads << Thread.new do
        runner_obj.run
      end
      wait_for_previous_device
    end
  end

  def wait_for_previous_device
    timer = 60
    start = Time.now
    while (Time.now - start) < timer
      sleep(0.1)
      return if $run_tests_on_next_device
    end
  end

  def wait_for_tests
    @threads.each(&:join)
  end
end
