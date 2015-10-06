#Template Engine

A simple syntax and web front-end for generating and modifying write-up templates. Work in progress.

How to write a template:

>Here is some normal text. This is a <\<variable>> for an insertion point. Include the same label in multiple places to save labour.

>{|stuff> You can choose |otherstuff> One of these |yetotherstuff> Or you can leave the whole section out. {|nested1> You can also <\<nest>> elements. |nested2> Super rad! } }

Uses [Treetop](http://treetop.rubyforge.org/) for parsing and [Sinatra](http://www.sinatrarb.com/) for web stuffs.

