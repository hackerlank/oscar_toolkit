#encoding: utf-8
#分析游戏日志
#1. 打开角色创建面板的玩家uid
#2.
#
#
#
#1. 点击［开始游戏］的玩家uid
#2. 打开［角色创建］面板的玩家uid
#3. 所有创建角色的玩家uid
#
#
#4. 任务完成情况：完成N任务的玩家有M人
#5. 脚本完成情况：完成XXX脚本的玩家有M人
#6. 冒险战斗情况：完成X副本Y战斗的玩家有M人
#
#

require 'getoptlong'
require 'set'

class ClientLog
   attr_accessor :quests, :scripts, :roleCreating
   def parse(lines)
      @quests = {}
      @scripts = {}
      @roleCreating = []
      questRegex = /QUEST\?roleId=(\w+)&action=submit&templateId=(\d+)/
         scriptRegex = /GUIDE\?roleId=(\w+)&tableName=(\w+)&funcName=(\w+)/
         roleCreatingRegex = /ROLE_CREATING\?(.+)sid=([0-9A-Z]+)/
         lines.each { |line|
         if line.start_with?("session")
            line.slice!(0..25)
         end

         m = questRegex.match(line)
         if m != nil
            templateId = m[2].to_i
            @quests[templateId] = [] unless @quests.key? templateId
            @quests[templateId] << m[1]
            next
         end

         m = scriptRegex.match(line)
         if m != nil
            scriptName = m[2]+"&"+m[3]
            @scripts[scriptName] = [] unless @scripts.key? scriptName
            @scripts[scriptName] << m[1]
            next
         end

         m = roleCreatingRegex.match(line)
         if m != nil
            roleCreating << m[2]
            next
         end
      }
   end

   def statQuest(outputFile)
      puts "任务完成情况"
      @quests.sort.map { |k, v|
         outputFile.puts "#{k}\t#{v.length}"
      }
   end

   def statScript(outputFile)
      puts "引导完成情况"
      @scripts.sort.map { |k, v|
         outputFile.puts "#{k} : #{v.length}"
      }
   end

   def statRoleCreating(outputFile)
      puts "打开角色注册面板"
      @roleCreating.each { |uid|
         outputFile.puts uid
      }
   end
end


def analyzeNginxAccessLog(inputFile, outputFile)
   puts "分析nginx acesss.log"
   uid = Set.new
   inputFile.each { |line|
      m = /openid=(\w+)/.match(line)
      if m != nil
         uid << m[1]
      end
   }

   uid.each { |uid|
      outputFile.puts uid
   }
end


def analyzeBattleLog(inputFile, outputFile)
   puts "分析服务器日志"
   battle = {}
   battleRegex = /transcriptTemplateId=(\d+)#monsterSpreadId=(\d+)#isWin=(\d)#roleId=(\d+)/
   inputFile.each { |line|
      m = battleRegex.match(line)
      if m != nil
         tid = m[1].to_i
         mid = m[2].to_i
         win = m[3].to_i
         roleId = m[4]
         next unless win == 1
         battle[tid] = {} unless battle.key? tid
         battle[tid][mid] = [] unless battle[tid].key? mid
         battle[tid][mid] << roleId
      end
   }

   battle.sort.map { |transcriptTemplateId, v|
      v.sort.map { |monsterSpreadTemplateId, roleIds|
         outputFile.puts("#{transcriptTemplateId}\t#{monsterSpreadTemplateId}\t#{roleIds.length}")
      }
   }

end

def main()
   opts = GetoptLong.new(
      ['--help', GetoptLong::NO_ARGUMENT],
      ['--output', '-o', GetoptLong::REQUIRED_ARGUMENT],
      ['--input', '-i', GetoptLong::REQUIRED_ARGUMENT],
      ['--mode', '-m', GetoptLong::REQUIRED_ARGUMENT]
   )
   mode = "invalid"
   inputFile = $stdin
   outputFile = $stdout
   opts.each do |opt, arg|
      case opt
      when '--help'
         puts <<-EOF 
            ruby pla.rb [OPTIONS]

            --help:
               显示帮助

            -m, --mode [quest|script|battle|roleCreated|roleCreating|loading]:
               不同的分析模式

            -i FILE, --input FILE:
               输入文件，默认是标准输入

            -o FILE, --output FILE:
               输出文件，默认是标准输出

            例子：
            ruby pla.rb -m quest -i client_log.txt 分析任务完成情况
            ruby pla.rb -m loading -i access.log  通过分析nginx的access.log获得点击［开始游戏］的uid列表
            ruby pla.rb -m roleCreated -h 127.0.0.1 -u root -p 123456 -d snsgame获得已经创建角色的uid列表

         EOF
      when '--input'
         inputFile = File.new(arg)
      when '--output'
         outputFile = File.new(arg, "w+")
      when '--mode'
         mode = arg
      end  
   end

   if mode == "invalid"
      puts "请使用正确的分析模式，ruby pla.rb --help"
      exit()
   end

   if mode == "quest"
      clientLog = ClientLog.new
      clientLog.parse(inputFile)
      clientLog.statQuest(outputFile)
   elsif mode == "script"
      clientLog = ClientLog.new
      clientLog.parse(inputFile)
      clientLog.statScript(outputFile)
   elsif mode == "roleCreating"
      clientLog = ClientLog.new
      clientLog.parse(inputFile)
      clientLog.statRoleCreating(outputFile)
   elsif mode == "loading"
      analyzeNginxAccessLog(inputFile, outputFile)
   elsif mode == "battle"
      analyzeBattleLog(inputFile, outputFile)
   else
      puts("invalid mode: #{mode}")
   end

   puts "finished"
   inputFile.close
   outputFile.close
end

main()
