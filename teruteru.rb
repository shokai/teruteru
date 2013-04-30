#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
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
  arg :interval, 'weather check interval (sec)', :alias => :i, :default => 600
  arg :help, 'show help', :alias => :h
end

if args.has_option? :help
  STDERR.puts args.help
  STDERR.puts "e.g.  ruby #{$0} -city 鎌倉 -interval 3600"
  exit 1
end

arduino = ArduinoFirmata.connect args[:arduino]

loop do
  begin
    weather = WeatherJp.get args[:city], :today
  rescue => e
    STDERR.puts e
    sleep args[:interval]
    next
  end
  puts weather
  if weather.rain.to_i > args[:rain]
    arduino.digital_write LED_BLUE, true
  else
    arduino.digital_write LED_RED, true
  end
  sleep args[:interval]
end
