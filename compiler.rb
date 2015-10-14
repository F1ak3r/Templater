module Compiler
	require 'set'

	module_function
	def compile(tree, options=nil)
		options ||= get_options(tree) #get default options hash if undefined
		flattened = traverse(tree, options)

		flattened.join
	end

	def traverse(tree, options)
		flattened = Array.new
		for e in tree
			case e
				when Array
					flattened << traverse(e,options)
				when Symbol
					flattened << options[:variables][e] if options[:variables].has_key? e
				when Hash
					key = (options[:options].flatten.to_set.intersection(e.keys)).to_a[0]
					value = traverse(e[key], options) unless key.nil?
					flattened << value
				else
					flattened << e
			end 
		end
		flattened
	end

	def get_options(tree)
		options = { :variables => Hash.new, :options => Array.new }
		for e in tree
			case e
				when Array
					inner_opts = get_options(e)
					options[:variables].merge! inner_opts[:variables]
					options[:options] += inner_opts[:options]
				when Symbol
					options[:variables].merge!({ e => e.to_s.upcase })
				when Hash
					options[:options] << e.keys.to_a
					e.each do |x|
						inner_opts = get_options(x)
						options[:variables].merge! inner_opts[:variables]
						options[:options] += inner_opts[:options]
					end
			end 
		end
		options
	end
end
