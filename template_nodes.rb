module Template
	class Body < Treetop::Runtime::SyntaxNode
		def value
			self.elements.map {|x| x.value }
		end
		def test
			"testertest"
		end
	end

	class Options < Treetop::Runtime::SyntaxNode
		def value
			self.elements[1].elements.map { |x| x.elements[1].value }.reduce Hash.new, :merge
		end
	end

	class Option < Treetop::Runtime::SyntaxNode
		def value
			Hash[*self.elements.collect { |x| x.value if x.respond_to?(:value) }]
		end
	end

	class Label < Treetop::Runtime::SyntaxNode
		def value
			self.text_value.tr('|>','')
		end
	end

	class Variable < Treetop::Runtime::SyntaxNode
		def value
			self.text_value.tr('"<>','').to_sym
		end
	end

	class NormalText < Treetop::Runtime::SyntaxNode
		def value
			self.text_value
		end
	end

	class SpecialText < Treetop::Runtime::SyntaxNode
		def value
			self.text_value
		end
	end

end
