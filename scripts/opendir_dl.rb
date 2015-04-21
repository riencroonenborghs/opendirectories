#!/usr/bin/ruby

require 'getoptlong'

opts = GetoptLong.new(
  [ '--user', '-u', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--password', '-p', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--output', '-o', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--files', '-f', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--no-check-cert', '-n', GetoptLong::NO_ARGUMENT ],
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ]
)

http_user = http_password = output_directory = files = no_check_cert = help = nil

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
  when '--no-check-cert'
    no_check_cert = true
  when '--help'
    help = true
  end
end

if help
  puts "#{$0} [--user|-u http_username] [--password|-p http_password] [--output|-o output_directory] [--files|-f file_filter] [--no-check-cert|-n] [--help|-h] URL"
  exit 0
end

if ARGV.length != 1
  puts "Missing url argument"
  exit 0
end

url = ARGV[0]

cmd = "wget  -r -c -np -e robots=off --random-wait --reject \"index.html*\""
cmd += " --http-user=\"#{http_user}\" --http-password=\"#{http_password}\" " if http_user && http_password
cmd += " --directory-prefix=\"#{output_directory}\" " if output_directory
cmd += " --accept \"#{files}\" " if files
cmd += " --no-check-certificate " if no_check_cert
cmd += " \"#{url}\" "

puts cmd

`#{cmd}`