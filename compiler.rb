module Compiler
	require 'set'

	class Compiler
		def self.compile(tree, options=nil)
			options ||= self.get_options(tree) #get default options hash if undefined
			flattened = self.traverse(tree, options)

			flattened.join
		end

		def self.traverse(tree, options)
			flattened = Array.new
			for e in tree
				case e
					when Array
						flattened << self.traverse(e,options)
					when Symbol
						flattened << options[:variables][e] if options[:variables].has_key? e
					when Hash
						key = (options[:options].to_set.intersection(e.keys)).to_a[0]
						value = traverse(e[key], options) unless key.nil?
						flattened << value
					else
						flattened << e
				end 
			end
			flattened
		end

		def self.get_options(tree)
			options = { :variables => Hash.new, :options => Array.new }
			for e in tree
				case e
					when Array
						inner_opts = self.get_options(e)
						options[:variables].merge! inner_opts[:variables]
						options[:options] += inner_opts[:options]
					when Symbol
						options[:variables].merge!({ e => e.to_s.upcase })
					when Hash
						options[:options] += e.keys
						e.each do |x|
							inner_opts = self.get_options(x)
							options[:variables].merge! inner_opts[:variables]
							options[:options] += inner_opts[:options]
						end
				end 
			end
			options
		end
	end
end
