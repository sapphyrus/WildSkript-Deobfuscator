require 'zip/zip'

if ARGV.empty?
    puts "USAGE: #{File.basename(__FILE__)} [FILE] [POWER]"
    exit 130
else
    filename = ARGV[0]
    power = ARGV[1].to_f
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

puts "Extracting #{filename}..."
unzip_file(filename, "temp")

def deobfuscate(power, warnings)

    skript = ""
    last5chars = "     "
    errors = 0
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
                puts "[#{charN}] Failed to decrypt: '#{char}' '#{number}' '#{last5chars}'" if warnings
                errors += 1
            end
        end
    end
    file.close
    
    return skript, errors
    
end

if power != 0
    puts "Deobfuscating #{filename} with power #{power.to_i}..."
    skript, errors = deobfuscate(power, true)
else
    puts "Bruteforcing #{filename}...\n\n"
    found = false
    power = 1
    while found == false
        power += 1
        skript, errors = deobfuscate(power, false)
        print "\r                                                                 "
        if (skript.include? "\n") && (skript.include? " ") && (skript.include? ":\n") && (errors == 0) && (skript.include? "\non")
            found = true
            print "\rTrying power #{power.to_i}... -> correct!"
            puts ""
            puts "Deobfuscating #{filename} with power #{power.to_i}..."
            skript, errors = deobfuscate(power, true)
        else
            print "\rTrying power #{power.to_i}... -> wrong (#{errors} Errors)"
        end
        
    end
end

FileUtils.remove_dir("temp")
open("#{filename}_deobf.sk", 'w') { |f|
    f.puts "#{skript}"
}

puts ""
puts "Output saved as #{filename}_deobf.sk"