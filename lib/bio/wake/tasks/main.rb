

def resource(*args,&block)
	task_builder(Wake::Resource,*args,&block)
end

def step(*args,&block)
	task_builder(Wake::Step,*args,&block)
end

def run(*args,&block)
	task_builder(Wake::Run,*args,&block)
end


private

def task_builder(klass,*args,&block)
	obj = nil
	name = nil
	scope = klass.to_s.split("::")[-1].downcase
	if args[0].class == Hash
		name = args[0].keys.first.to_s
		args[0][scope+":"+name] = args[0][name]
		obj = klass.new(name)
		obj.dependency = args[0][name]
	else
		name = args[0].to_s
		args[0] = scope+":"+name
		obj = klass.new(name)
		body = proc do
			obj.instance_eval(&block)
		end	
	end
	body = proc do
		obj.instance_eval(&block)
	end
	task = Rake::Task.define_task(name,&body)
	task.add_description("Run #{name}")
	task.enhance obj.dependency unless obj.dependency.nil?
end


