class Wake
	class Run
		include Wake::Path

		attr_accessor :dependency
		
		def initialize(name)
			@name = name
		end

		alias :params :parameters
		def params(list)
			sh "#{name} #{list}"	
		end

	end
end
