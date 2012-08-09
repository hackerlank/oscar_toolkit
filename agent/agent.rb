#encoding: utf-8

require './ztgame'
require './deploy'
include Ztgame
require './multiclient_tcp_server'



srv = MulticlientTCPServer.new(2000, 1, true)
loop do
   if sock = srv.get_socket
      message = sock.gets().chomp
      if message == 'quit'
         raise SystemExit
      elsif message =~ /patch (.*)$/
         puts($1)
         args = $1.split(' ')
         orderId = args[0]
         version = args[1]
         updates = args[2].split(':')
         updateDir = args[3].split(':')
         apps = []
         appDirs = []
         sqlDir = ""
         dataDir = ""
         updates.each_index { |i|
            if updates[i] == "sql"
               sqlDir = updateDir[i]
            elsif updates[i] == "data"
               dataDir = updateDir[i]
            else
               apps << updates[i]
               appDirs << updateDir[i]
            end
         }

         deploy = Deploy.new
         result = "deploy failed"
         begin
            result = deploy.doPatch(orderId, version, apps, appDirs, dataDir, sqlDir)
         rescue SystemCallError => ex
            result = ex
         end
         sock.puts result
      else
         info("unexpected message from #{sock.peeraddr}: '#{$1}'")
      end
   else
      sleep 0.01
   end
end

