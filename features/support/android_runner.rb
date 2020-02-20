require_relative "adb"
#require_relative "tags"

class RunnerAndroid
  def initialize(device, options, port_counter)
  @options = options
  @options['port'] += port_counter
  @options['boot_port'] += port_counter
  p @options
  @device = device
  @device_name = Adb.device_name(@device)
  if options['tags'].include? 'ask tag'
    @scenario_tag = Tags.enter_tags
  else
    @scenario_tag = options['tags']
  end
  end

  def run
    Dir.mkdir("reports/") unless File.exists?("reports/")
    command = "export platform=Android ; " \
    "export sn=#{@device} ; " \
    "export apk=#{@options['apk']} ; " \
    "export port=#{@options['port']} ; " \
    "export boot_port=#{@options['boot_port']} ; " \
    "cucumber -t #{@scenario_tag} -f pretty -f #{@options['report']} " \
    "-o reports/#{@device_name}.#{@options['report']}"
    p command
    $run_tests_on_next_device = true
    `#{command}`
  end
end
