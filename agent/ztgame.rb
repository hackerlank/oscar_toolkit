#encoding: utf-8

require 'logger'

$LOG = Logger.new("ztgame_agent.log", File::WRONLY | File::APPEND)
$LOG.level = Logger::INFO
$LOG.formatter = proc { |severity, datetime, progname, msg|
   "#{datetime} #{msg}\n"
}

module Ztgame
   
   def info(msg, *arg)
      realMsg = msg + arg.join(" ")
      puts(realMsg)
      $LOG << realMsg + "\n"
   end

   def warn(msg, *arg)

   end

   def error(msg, *arg)
   end

   def runCmd(cmd)
      info("runCmd: ", cmd)
      #return cmd 
      return `#{cmd}`
   end
end
