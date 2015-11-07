# The compiler provides methods for producing plain text variants for given parsed trees and options 

module Compiler
  require 'set'

  module_function
  # Compile a parsed template tree with either default options or the provided options hash
  def compile(tree, options=nil)
    options ||= get_options(tree) #get default options hash if undefined
    flattened = traverse(tree, options)

    flattened.join
  end

  # Traverse the tree and compile it
  def traverse(tree, options)
    tree.collect do |e|
      case e
      when Array #e is a subtree
        traverse e, options
      when Symbol #e is a variable
        options[:variables][e] if options[:variables].has_key? e
      when Hash #e is an options hash
        key = (options[:options].flatten.to_set.intersection(e.keys)).to_a[0]
        value = traverse(e[key], options) unless key.nil?
        value
      else #e is plain text
        e
      end 
    end
  end

  # Get default options hash for provided template tree
  def get_options(tree)
    options = { variables: Hash.new, options: Array.new }
    for e in tree
      case e
      when Array #e is a subtree
        inner_opts = get_options(e)
        options[:variables].merge! inner_opts[:variables]
        options[:options] += inner_opts[:options]
      when Symbol #e is a variable
        options[:variables].merge! e => e.to_s.upcase
      when Hash #e is an options hash
        diff = e.keys.to_set.difference(options[:options].flatten).to_a
        options[:options] << diff unless diff.empty?
        e.each do |x|
          inner_opts = get_options x
          options[:variables].merge! inner_opts[:variables]
          options[:options] += inner_opts[:options]
        end
      end 
    end
    options
  end
end
