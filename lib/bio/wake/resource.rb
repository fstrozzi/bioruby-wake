class Wake
	class Resource
		
		include FileUtils
    include Wake::Path

    LIST = {}

    attr_accessor :input, :output, :dependency

		def initialize(name)
			@name = name.to_s
      @path = current_path
      update_path @name
      LIST[@name] = self
		end

		def install(opts = {})
      install_from_url(opts) if opts.has_key? :url
      install_from_git(opts) if opts.has_key? :git
      install_from_hg(opts) if opts.has_key? :hg
      install_from_gem(opts) if opts.has_key? :gem
		end

private

    def install_from_url(opts)
      puts "Downloading #{opts[:url]}"
      mkdir_p @path+"/software"
      cd(@path+"/software") {system "wget #{opts[:url]}"}
      puts "\nDone"
      puts "Uncompressing..."
      command,basename = file_type(opts[:file])
      puts command+" "+opts[:file]
      uncompress_any(@path+"/software/"+opts[:file],command,basename)
      compile(opts[:type]) if opts[:type] == :make or opts[:type] == :make_install
      cd(@path+"/software") { rm_f opts[:file] }
    end

    def install_from_git(opts)
      cd(@path+"/software") {sh "git clone #{opts[:git]} #{@name}"}
    end

    def install_from_hg(opts)
      cd(@path+"/software") {sh "hg clone #{opts[:hg]} #{@name}"}
    end

    def install_from_gem(opts)
      sh "gem install #{opts[:gem]}"
    end

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

    def uncompress_any(filename,command,basename)
   		puts command+" "+filename
   		cd(@path+"/software") do 
        system command+" "+filename
        mv basename, @name
      end
    end

    def compile(type) 	
      cd(@path+"/software/"+@name) do 
        system "PKG_CONFIG_PATH='#{@path}/sofware/pkgconfig' ./configure --prefix=#{@path}/software/#{@name}"
        system "make"
        system "make install" if type == :make_install
      end
    end
	end
end