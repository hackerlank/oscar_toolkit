#coding:UTF-8
require 'set'

$UIDS = Set.new

def analyze(lines)
   lines.each { |line|
         m = /openid=(\w+)/.match(line)
         if m != nil
            $UIDS << m[1]
         end

   }
end


def output()
   $UIDS.each { |uid|
      puts uid
   }
end

analyze(ARGF.readlines)
output()
