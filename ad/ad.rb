#encoding: utf-8 
#分析TX广告投放
require 'open-uri'

def handleAd1()

   url = "http://i.gdt.qq.com/view.fcg?adposcount=4&posid=648520563367466191|720578157405394127|792635751443322063|864693345481249999&count=3|1|1|1&ext=%7B%22req%22%3A%7B%22rst%22%3A%221360*768%22%7D%2C%22pos%22%3A%7B%220%22%3A%7B%7D%2C%221%22%3A%7B%7D%2C%222%22%3A%7B%7D%2C%223%22%3A%7B%7D%7D%7D&g_tk=1709207858"

   response = nil
   open(URI.escape(url)) do |http|
      response = http.read
   end

   realResponse = response.encode("UTF-8", "GB2312")

   realResponse.each_line{ |line|
      appnameRegex = /"appname":"(.*)",/
         m = appnameRegex.match(line)
      if m != nil
         puts m[1]
         puts("founded ad1") if m[1] == "海商王Online"
      end

   }
end

def handleAd2()
 url = "http://i.gdt.qq.com/view.fcg?adposcount=4&posid=432347781253682383|360290187215754447|504405375291610319|576462969329538255&count=4|3|3|1&ext=%7B%22req%22%3A%7B%22rst%22%3A%221360*768%22%7D%2C%22pos%22%3A%7B%220%22%3A%7B%7D%2C%221%22%3A%7B%7D%2C%222%22%3A%7B%7D%2C%223%22%3A%7B%7D%7D%7D&g_tk=1709207858"

 targets = ["BAxDd0oAFBQGJBEBYMC_4.png"]
   response = nil
   open(URI.escape(url)) do |http|
      response = http.read
   end

   realResponse = response.encode("UTF-8", "GB2312")

   realResponse.each_line{ |line|
      appnameRegex = /"img":"(.*)",/
         m = appnameRegex.match(line)
      if m != nil
         puts m[1]
         targets.each{ |targetImg|
            puts("founded ad2") if m[1].include? targetImg
         }
      end

   }

end

100.times {
  handleAd1()
  handleAd2()
  sleep 1
}
