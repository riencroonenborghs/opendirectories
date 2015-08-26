#!/usr/bin/ruby

require 'getoptlong'

opts = GetoptLong.new(
  [ '--force', '-f', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--help', '-h', GetoptLong::OPTIONAL_ARGUMENT ]
)

force = help = false

opts.each do |opt, arg|
  case opt
  when '--force'
    force = true
  when '--help'
    help = true
  end
end

if help
  puts "#{$0} [--force|-f] [--help|-h] URL"
  exit 0
end

if ARGV.length != 1
  puts "Missing url argument"
  exit 0
end

url = ARGV[0]

cmd = "get_iplayer --proxy <PROXYGOESHERE> --modes best"
cmd += " --force " if force
cmd += " --get \"#{url}\" "

puts cmd

`#{cmd}` 