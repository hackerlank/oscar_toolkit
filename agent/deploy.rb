#encoding: utf-8
require './ztgame'
include Ztgame

$SCRIPT_ROOT = "~/tools/"
$SCRIPT_UPDATE = $SCRIPT_ROOT + "Update.sh"
$SCRIPT_RUN_SERVER = $SCRIPT_ROOT + "RunServer.sh"

class Deploy

   def doVersion()
   end

   #做补丁
   def doPatch(orderId, version, apps, appDirs, dataDir, sqlDir)
      result = []
      #下载补丁
      appDirs.each{ |appDir|
         result << download(appDir)
      }
      result << download(dataDir) unless dataDir.empty?
      result << download(sqlDir) unless sqlDir.empty?
      
      #更新应用
      appDirs.each{ |appDir|
         result << patch(appDir)
      }
      
      #更新策划数据
      result << patch(dataDir) unless dataDir.empty?

      #关闭服务
      result << stopServer(apps)

      #更新sql
      result << patch(sqlDir) unless sqlDir.empty?

      #启动服务
      result << startServer(apps, version)
      result << "ok"
      return result.join("\n")
   end


   def download(dir)
      info("download ", dir)
      return runCmd("#$SCRIPT_UPDATE -a down -s #{dir}")
   end

   def patch(dir)
      info("patch ", dir)
      return runCmd("#$SCRIPT_UPDATE -a patch -s #{dir}")
   end

   def stopServer(apps)
      info("stopServer ", apps)
      result = []
      apps.each{ |app|
         result << runCmd("#$SCRIPT_RUN_SERVER -s #{app} -a stop")
      }
      return result.join("\n")
   end

   def startServer(apps, version)
      info("startServer ", apps, version)
      result = []
      apps.each{ |app|
         result << runCmd("#$SCRIPT_RUN_SERVER -s #{app} -a start -v #{version}")
      }
      return result.join("\n")
   end
end
