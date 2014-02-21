#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
$stdout.sync = true
require 'rubygems'
require 'bundler'
Bundler.require
LED_RED   = 11
LED_GREEN = 12
LED_BLUE  = 13

args = ArgsParser.parse ARGV do
  arg :arduino, 'arduino port', :default => ArduinoFirmata.list[0]
  arg :city, 'city', :alias => :c, :default => '東京'
  arg :rain, '降水確率のしきい値 (%)', :default => 30
  arg :help, 'show help', :alias => :h
end

if args.has_option? :help
  STDERR.puts args.help
  STDERR.puts "e.g.  ruby #{$0} -city 鎌倉"
  exit 1
end

begin
  weather = WeatherJp.get args[:city], :today
rescue StandardError, Timeout::Error => e
  STDERR.puts e
  exit
end
puts "#{weather} - #{Time.now}"

arduino = ArduinoFirmata.connect args[:arduino]
if weather.rain > args[:rain]
  arduino.digital_write LED_RED, false
  arduino.digital_write LED_GREEN, false
  arduino.digital_write LED_BLUE, true
else
  arduino.digital_write LED_RED, true
  arduino.digital_write LED_GREEN, false
  arduino.digital_write LED_BLUE, false
end
