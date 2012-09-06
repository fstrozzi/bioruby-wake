require 'rake'


def resource(*args,&block)
	body = proc do
				resource = Wake::Resource.new(args[0])
				resource.instance_eval(&block)
		   end
	Rake::Task.define_task(*args,&body)
end


