#encoding: utf-8
#FIXME: using the metaprogramming techniqe

require 'java'
require 'lib/poi-3.7-20101029.jar'
require 'lib/dom4j-1.6.1.jar'
require 'lib/geronimo-stax-api_1.0_spec-1.0.jar'
require 'lib/xmlbeans-2.3.0.jar'
require 'lib/poi-ooxml-schemas-3.7-20101029.jar'
require 'lib/poi-ooxml-3.7-20101029.jar'
require 'rexml/document'

include REXML

import org.apache.poi.xssf.usermodel.XSSFWorkbook
import java.io.FileOutputStream

class Entry
	attr_reader :addTime, :type
	def initialize(addTime, type, argument)
		@addTime = addTime
		@type = type
		initArgument(argument)
	end
	def initArgument(argument)
	end
	
	def createHead(sheet)
	end
	def createRow(sheet)
	end
end

class GuideEntry < Entry
	attr_reader :roleId, :module, :clientScript, :comment
	@@rowIndex = 0
	def initialize(addTime, type, argument)
		super(addTime, type, argument)
	end
	def initArgument(argument)
		argument.split("&").each{|kv|
			tmp = kv.split("=")
			case tmp[0]
			when "roleId" then @roleId = tmp[1]
			when "moduleinfo" then @module = tmp[1]
			when "cs_name" then @clientScript = tmp[1]
			when "comment" then @comment = tmp[1]
			else puts("invalid key: "..tmp[0])
			end
		}
	end
	def createHead(sheet)
		row = sheet.createRow(0)
		row.createCell(0).setCellValue("roleId")
		row.createCell(1).setCellValue("module")
		row.createCell(2).setCellValue("clientScript")
		row.createCell(3).setCellValue("comment")
		row.createCell(4).setCellValue("addTime")
	end
	def createRow(sheet)
		@@rowIndex = @@rowIndex + 1
		row = sheet.createRow(@@rowIndex)
		row.createCell(0).setCellValue(@roleId)
		row.createCell(1).setCellValue(@module)
		row.createCell(2).setCellValue(@clientScript)
		row.createCell(3).setCellValue(@comment)
		row.createCell(4).setCellValue(addTime)
	end
end

class QuestEntry < Entry
	attr_reader :roleId, :action, :templateId
	@@rowIndex = 0
	def initialize(addTime, type, argument)
		super(addTime, type, argument)
	end
	def initArgument(argument)
		argument.split("&").each{|kv|
			tmp = kv.split("=")
			case tmp[0]
			when "roleId" then @roleId = tmp[1]
			when "action" then @action = tmp[1]
			when "templateId" then @templateId = tmp[1]
			else puts("invalid key:" ..tmp[0])
			end
		}
	end
	def createHead(sheet)
		row = sheet.createRow(0)
		row.createCell(0).setCellValue("roleId")
		row.createCell(1).setCellValue("action")
		row.createCell(2).setCellValue("templateId")
		row.createCell(3).setCellValue("addTime")
	end
	def createRow(sheet)
		@@rowIndex = @@rowIndex + 1
		row = sheet.createRow(@@rowIndex)
		row.createCell(0).setCellValue(@roleId)
		row.createCell(1).setCellValue(@action)
		row.createCell(2).setCellValue(@templateId)
		row.createCell(3).setCellValue(addTime)
	end
end

class LoginEntry < Entry
	attr_reader :roleId, :os, :brower, :flashPlayer
	@@rowIndex = 0
	def initialize(addTime, type, argument)
		super(addTime, type, argument)
	end
	def initArgument(argument)
		argument.split("&").each{|kv|
			tmp = kv.split("=")
			case tmp[0]
			when "roleId" then @roleId = tmp[1]
			when "os" then @os = tmp[1]
			when "brower" then @brower = tmp[1]
			when "flashPlayer" then @flashPlayer = tmp[1]
			else puts("invalid key:"..tmp[0])
			end
		}
	end
	def createHead(sheet)
		row = sheet.createRow(0)
		row.createCell(0).setCellValue("roleId")
		row.createCell(1).setCellValue("os")
		row.createCell(2).setCellValue("browser")
		row.createCell(3).setCellValue("flashPlayer")
		row.createCell(4).setCellValue("addTime")
	end
	def createRow(sheet)
		@@rowIndex = @@rowIndex + 1
		row = sheet.createRow(@@rowIndex)
		row.createCell(0).setCellValue(@roleId)
		row.createCell(1).setCellValue(@os)
		row.createCell(2).setCellValue(@brower)
		row.createCell(3).setCellValue(@flashPlayer)
		row.createCell(4).setCellValue(addTime)
	
	end

end


def newEntry(addTime, type, argument)
	case type
	when "GUIDE" then return GuideEntry.new(addTime, type, argument)
	when "QUEST" then return QuestEntry.new(addTime, type, argument)
	when "LOGIN" then return LoginEntry.new(addTime, type, argument)
	else	puts("invalid type: "..type)
	end
end




def main()
	input = File.new("session.log")
	clientLogRegex = /(.+)\,(.+)\:(.+)\?(.+)\./
	clientLog = {}
	input.each{ |line|
		m = clientLogRegex.match(line)
		clientLog.store(m[3], []) unless clientLog.key?(m[3])
		clientLog.fetch(m[3]) << newEntry(m[1], m[3], m[4])
	}
	input.close

	#write into excel
	wb = XSSFWorkbook.new()
	clientLog.each { |key, value|
		puts("creating sheet:", key)
		sheet = wb.createSheet(key)
		value[0].createHead(sheet)
		value.each{ |entry|
			entry.createRow(sheet)
		}
	}
	fs = FileOutputStream.new("clientLog.xlsx")
	wb.write(fs)
	fs.close
end
main()
