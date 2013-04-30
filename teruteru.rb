#!/usr/bin/env ruby
require 'rubygems'
require 'arduino_firmata'
require 'weather_jp'

if ARGV.empty?
  STDERR.puts "  % ruby #{$0} yokohama"
  exit 1
end
weather = WeatherJp.get ARGV.shift
puts weather.today
arduino = ArduinoFirmata.connect ARGV.shift

LED_RED   = 11
LED_GREEN = 12
LED_BLUE  = 13

if weather.today.rain.to_i > 30
  arduino.digital_write LED_BLUE, true
else
  arduino.digital_write LED_RED, true
end
