class Wake
	class Resource
		require 'fileutils'
		include FileUtils

		def initialize(name)
			@name = name
			@path = Dir.pwd
			ENV["PATH"] = ENV["PATH"]+":#{@path}/software/#{@name}:#{@path}/software/#{@name}/bin"
		end

		def install(opts = {})
        	puts "Downloading #{opts[:url]}"
        	mkdir_p @path+"/software"
        	cd(@path+"/software") {system "wget #{opts[:url]}"}
        	puts "\nDone"
         	puts "Uncompressing..."
         	command,basename = file_type(opts[:file])
         	puts command+" "+basename
        	uncompress_any(@path+"/software/"+opts[:file],command)
        	compile(basename,opts[:type]) if opts[:type] == :make or opts[:type] == :make_install
		end

private

		def file_type(filename)
            case filename.split(".")[-1]
            	when "bz2" then return "tar xvfj",filename.split(".tar.bz2").first
            	when "gz" then return "tar xvfz", filename.split(".tar.gz").first
            	when "zip" then return "unzip", filename.split(".zip").first
            	when "tgz" then return "tar xvfz", filename.split(".tgz").first
            else
              	raise "Unknown file suffix."
            end
        end

        def uncompress_any(filename,command)
   			puts command+" "+filename
   			cd(@path+"/software") {system command+" "+filename}
        end

        def compile(basename,type) 	
          	cd(@path+"/software/"+basename) do 
            	system "PKG_CONFIG_PATH='#{@path}/sofware/pkgconfig' ./configure --prefix=#{@path}/software/#{basename}"
            	system "make"
            	system "make install" if type == :make_install
            end
        end
	end
end