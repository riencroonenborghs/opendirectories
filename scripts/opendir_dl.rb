#!/usr/bin/ruby

require 'getoptlong'

opts = GetoptLong.new(
  [ '--user', '-u', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--password', '-p', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--output', '-o', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--files', '-f', GetoptLong::OPTIONAL_ARGUMENT ]
)

http_user = http_password = output_directory = files = nil

opts.each do |opt, arg|
  case opt
  when '--user'
    http_user = arg
  when '--password'
    http_password = arg
  when '--output'
    output_directory = arg
  when '--files'
    files = arg
  end
end

if ARGV.length != 1
  puts "Missing url argument"
  exit 0
end

url = ARGV[0]

cmd = "wget -r -c -np -e robots=off --random-wait --reject \"index.html*\""
if http_user && http_password
  cmd += " --http-user=\"#{http_user}\" --http-password=\"#{http_password}\" "
end

if output_directory
  cmd += " --directory-prefix=\"#{output_directory}\" "
end

if files
  cmd += " --accept \"#{files}\" "
end

cmd += " \"#{url}\" "

puts cmd

`#{cmd}`