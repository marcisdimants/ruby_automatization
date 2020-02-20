class Server
  def initialize(options)
    @port = options['port']
    @port_boot = options['portboot']
    @sn = options['sn']
    @apk = options['app']
    @app_package = options['appPackage']
  end

  def start
    stop
    `appium -p #{@port} -bp #{@port_boot} -U #{@sn} >> logs.log 2>&1 &`
  end

  def stop
    lines = `ps ax | grep #{@sn} | grep node`.split("\n")
    lines.each do |line|
      pid = line.split(' ').first
      `kill -9 #{pid}`
    end
    `/usr/bin/killall -KILL node`
  end

  def wait_to_boot
    opened = false
    until opened do
      opened = `nmap -p #{@port} localhost | grep #{@port}`.include?('open')
    end
  end

end
