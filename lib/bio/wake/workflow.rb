class Wake
	module Workflow
		
		include Wake::Path
		include FileUtils

		def check_history
			path = current_path
			File.exists? path+"/.wake_history.yml"
		end

		def init_dir(step)
			mkdir_p current_path+"/analysis/"+step.name	
		end

	end
end
