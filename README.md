#Template Engine

A simple syntax and web front-end for generating and modifying write-up templates. Usable, but not thoroughly tested and could probably stand to have a few more features.

##How to use

**Step 1**: Grab it with `git clone https://github.com/F1ak3r/Templater.git`, install dependencies with `bundle install` and start the server with `ruby router.rb`.

**Step 2**: Then navigate to `localhost:4567` in your browser. You should see this:

![Templater](https://github.com/F1ak3r/Templater/raw/master/img/templater.png)

**Step 3**: Write a template in your favourite text editor.

How to write a template:

>Here is some normal text. This is a <\<variable>> for an insertion point. Include the same <\<variable>> in multiple places to save labour.

>{{|stuff> You can choose |otherstuff> One of these |yetotherstuff> Or you can leave the whole section out. {{|nested1> You can also <\<nest>> elements. |nested2> Super rad! }} }}

>{{|stuff> Include the same sets of options |otherstuff> In different sets |yetotherstuff> In order to vary text in multiple places with a single choice. }}

**Step 4**: Save your template to disk and use the upload button to load it into Templater.

**Step 5**: Play around with it: change options, enter text for variables.

**Step 6**: Finally, copy-paste the resulting text to wherever you need it to be.

##Why this exists

Templater is an experiment in developing a graphical interface for quick and painless manipulation of mostly standard passages with minor variations and some dynamic content. Also I wanted to write a parser.

I don't really know whether it's going to prove particularly useful or not, but I had fun making it.

##Acknowledgements

Uses [Treetop](http://treetop.rubyforge.org/) for parsing and [Sinatra](http://www.sinatrarb.com/) for web stuffs.

This is an experimental tool meant for personal, loopback use only: it is *not* production-ready and certainly crawling with bugs and vulnerabilities.

