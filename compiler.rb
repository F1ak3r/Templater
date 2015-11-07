module Compiler
  require 'set'

  module_function
  def compile(tree, options=nil)
    options ||= get_options(tree) #get default options hash if undefined
    flattened = traverse(tree, options)

    flattened.join
  end

  def traverse(tree, options)
    tree.collect do |e|
      case e
      when Array
        traverse(e,options)
      when Symbol
        options[:variables][e] if options[:variables].has_key? e
      when Hash
        key = (options[:options].flatten.to_set.intersection(e.keys)).to_a[0]
        value = traverse(e[key], options) unless key.nil?
        value
      else
        e
      end 
    end
  end

  def get_options(tree)
    options = { variables: Hash.new, options: Array.new }
    for e in tree
      case e
      when Array
        inner_opts = get_options(e)
        options[:variables].merge! inner_opts[:variables]
        options[:options] += inner_opts[:options]
      when Symbol
        options[:variables].merge!({ e => e.to_s.upcase })
      when Hash
        diff = e.keys.to_set.difference(options[:options].flatten).to_a
        options[:options] << diff unless diff.empty?
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
