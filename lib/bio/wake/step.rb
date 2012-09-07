class Wake

	class Step
		
		include Wake::Workflow
		include Wake::Path
		
		attr_accessor :dependency

		def initialize(name)
			@name = name
			init_dir self
		end

		def method_missing(method,*args,&block)
			sh "#{method} #{args.join(" ")}"
		end
	end	

end
