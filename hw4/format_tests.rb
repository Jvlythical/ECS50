#!/usr/bin/env ruby

files = Dir["Tests/*"]

for i in 0...files.length 
	fp = File.open(files[i], "rb")
	content = fp.read
	content = content.gsub "\n", " " 
	content = content + "\n"
	fp = File.open(files[i], "w")
	fp.write(content)
	puts content
	fp.close
end
#fp = file.open()
