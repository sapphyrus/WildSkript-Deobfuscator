if ARGV.empty?
    puts "USAGE: #{File.basename(__FILE__)} [FILE] [POWER]"
    exit 130
else
    filename = ARGV[0]
    power = ARGV[1].to_f
end

begin
    require 'zip/zip'
rescue LoadError
    puts "Required dependency not found!"
    system 'gem uninstall zip'
    sleep(1)
    exec 'gem install zip'
    exit 130
end

def unzip_file (file, destination)
  Zip::ZipFile.open(file) { |zip_file|
   zip_file.each { |f|
     f_path=File.join(destination, f.name)
     FileUtils.mkdir_p(File.dirname(f_path))
     zip_file.extract(f, f_path) unless File.exist?(f_path)
   }
  }
end

puts "Deobfuscating #{filename} with power #{power.to_i}..."

unzip_file(filename, "temp")
skript = ""
last5chars = "     "
charN = 0
power -= 1

file = File.new("temp/tmp.ws", "r")
while (line = file.gets)
    line.split("-").each do | char |
        number = char.to_f/power
        charN += 1
        number = number.to_i
        begin
            skript = "#{skript}#{number.to_i.chr}"
            last5chars = last5chars[1..5] + number.to_i.chr
        rescue
            puts "[#{charN}] Failed to decrypt: '#{char}' '#{number}' '#{last5chars}'"
        end
    end
end
file.close
FileUtils.remove_dir("temp")

open("#{filename}_deobf.sk", 'w') { |f|
    f.puts "#{skript}"
}

puts ""
puts "Output written to #{filename}_deobf.sk"