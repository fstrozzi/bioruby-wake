class Wake
	class Resource
		require 'fileutils'
		include FileUtils

		def initialize(name)
			@name = name
			@path = Dir.pwd
			ENV["PATH"] << ":#{@path}/software/#{@name}:#{@path}/software/#{@name}/bin"
		end

		def install(opts = {})
          puts "Downloading #{url}"
          filename = opts[:url].split('/')[-1]
          FileUtils.mkdir_p @path+"/software"
          pbar = nil
          open(opts[:url],"rb",
            :content_length_proc => lambda {|t|
              if t && 0 < t
                pbar = ProgressBar.new('', t)
                pbar.file_transfer_mode
              end
            },
            :progress_proc => lambda {|s|
              pbar.set s if pbar
            }) do |remote|
              open("software/"+filename,"wb") {|file| file.write remote.read(16384) until remote.eof?}
            end
            puts "\nDone"
          end
          puts "Uncompressing..."
          uncompress_any(@path+"/software/"+filename)
          compile(filename,opts[:type]) if opts[:type] == :make or opts[:type] == :make_install
		end

private

		def uncompress_command(suffix)
            case suffix
            	when "bz2" then "tar xvfj"
            	when "gz" then "tar xvfz"
            	when "zip" then "unzip"
            	when "tgz" then "tar xvfz"
            else
              	raise "Unkonw suffix."
            end
        end

        def uncompress_any(filename)
   			command = uncompress_command(filename.split(".")[-1])
   			cd @path+"/software" {system command+" filename"}
        end

        def compile(filename,type)
          	cd @path+"/software/"+@name do 
            	system "PKG_CONFIG_PATH='#{@path}/sofware/pkgconfig' ./configure --prefix=#{@path}/software/#{@name}"
            	system "make"
            	system "make install" if type == :make_install
            end
        end
	end
end