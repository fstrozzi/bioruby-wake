class Wake
	module Path

		def current_path
			Dir.pwd
		end

		def update_path(name)
			path = current_path
			ENV["PATH"] = ENV["PATH"]+":#{path}/software/#{name}:#{path}/software/#{name}/bin:#{path}/software/#{name}/scripts"
		end

	end
end
