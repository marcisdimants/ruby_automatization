require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'pp'

class Optparser
  CODES = %w(iso-2022-jp shift_jis euc-jp utf8 binary).freeze
  CODE_ALIASES = { 'jis' => 'iso-2022-jp', 'sjis' => 'shift_jis' }.freeze

  def self.parse(args)
    options = OpenStruct.new
    options.apk = './build/*.apk'
    options.report = 'html'
    options.tags = 'ask tag'
    options.reinstallApk = 'false'

    opt_parser = OptionParser.new do  |opts|
      opts.banner = 'Usage: ruby main.rb [options]'

      opts.separator ''

      opts.separator 'Specific options:'

      opts.on('-a', '--apk [app.apk]', 'app .apk file, default *apk') do |apk|
        options.apk = apk
      end

      opts.on('-r', '--report [format]', 'Report file format, default html') do |report|
        options.report = report
      end

      opts.on('-t', '--tags [@tags]', 'Specific tags to be run') do |tags|
        options.tags = tags
      end


      opts.on('-i', '--reintstallApk=false', 'Reinstall apk') do |reinstallApk|
        options.reinstallApk = reinstallApk
      end

      opts.separator ''

      opts.separator 'Common options:'

      opts.on_tail('-h', '--help', 'Show this message') do
        puts opts
        exit
      end

    end
    opt_parser.parse!(args)
    options
  end
end
