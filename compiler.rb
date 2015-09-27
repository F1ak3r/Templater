module Compiler
	require 'set'

	class Compiler
		def self.compile(tree, options)
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
			options = { :variables => [], :options => [] } 

			for e in tree
				case e
					when Symbol
						options[:variables] << e
					when Hash
						options[:options].concat e.keys
					else
						next
				end 
			end

			options
		end

	end
end
