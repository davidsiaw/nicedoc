require 'yaml'

def page(filename, path)
  nd = Nicedoc.new(File.read(filename))

  nd.renderer.generate(path, self)

end



  # empty_page path, "My first weaver page" do

  #   request_css 'css/main.css'
  
  #   row do
  #     col 9 do
  
  
  #       h2 "Chapter 1"
  
  #       h1 "Introduction"
  
        
  #       p class: :noindent do
  #         span 'P', class: :dropcap
  #         text "rogramming languages are notations for describing computations to people and to machines. The world as we know it depends on programming languages, because all the software running on all the computers was written in some programming language. But, before a program can be run, it must first be translated into a form in which it can be executed by a computer."
  #       end
  
  #       p "Qorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
  
  #       br
  #       h3 "1.1 Language Processors"
  
  #       p do
  #         text "Simply stated, a compiler is a program that can read a program in one language - the "
  #         i "source "
  #         text "language - and translate it into an equivalent program in another language - "
  #       end
  
  #       blockquote do
  
  #         h4 "Caveats"
  
  #         p "You should avoid creating new objects when you have no memory.", class: :noindent
  
  #       end
  
        
  #       hr
  
  
  #       h2 "Chapter 2"
  
  #       h1 "Strange Things"
  
  #       p class: :noindent do
  #         span 'L', class: :dropcap
  #         text "orem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
  #       end
  
  #       p "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
  
  #       p "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
  
  #       h2 "Another header"
  
  #       h3 "Content subheader"
  #       p "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
  
  #       pre <<~CODE
  #         preformatted content
  #         some code
  #         printf 'abc'
  
  #         +-----------+    +-------+
  #         | Component |--->| Thing |
  #         +-----------+    +-------+
  #               |
  #               |
  #               v
  #           +--------+
  #           | Gadget |
  #           +--------+
  #         figure 1.1
  
  
  #         +------------------+-----+
  #         | strange thing    | no  |
  #         +------------------+-----+
  #         | Ore              | 2   |
  #         | Plant            | 5   |
  #         | Bone             | 1   |
  #         +------------------+-----+
  #         table 1.2a
  
  #       CODE
  
  
  
  #       text "Some text"
  
  #       h2 "Another header"
  
  #       h3 "Content subheader"
  
  #       p "Some comment"
  
  #       h4 "Content subsubheader"
  
  #       p "Some comment"
  
  #       h5 "Content subsubsubheader"
  
  #       h6 "Content subsubsubsubheader"
  
  #       p "Some comment"
  
  
  #       pre <<~CODE
  #         preformatted content
  #         some code
  #         printf 'abc'
  
  #         the lazy fox jumps over the moon cow
  
  #         123456
  
  #         I am the world
  #       CODE
  
  #       div class: :blog do
  #         h1 "Blog title"
  
  #         h2 "Post title"
  
  #         p <<~BLOGPOST
  #           These are contents of a blogpost. Blogposts are written in preformatted form and do not have paragraph indents. They also use a lighter font than the preformatted one.
  #         BLOGPOST
  
  #         p <<~BLOGPOST
  #           The reason they are this way is to show their opinionated and highly casual form. This also facilitates their use as casual text documents where diagrams can be drawn using ASCII art.
  #         BLOGPOST
  
  #         p <<~CODE
  #           Content from a blog
  
  
  
  #           +------------------+-----+
  #           | strange thing    | no  |
  #           +------------------+-----+
  #           | Ore              | 2   |
  #           | Plant            | 5   |
  #           | Bone             | 1   |
  #           +------------------+-----+
  #           table 1.2a
  #         CODE
  
  #         p do
  #           text "This is one "
  #           i "particularly"
  #           text " interesting piece of art."
  #         end
  
  #         pre <<~CONTENT
  #           preformatted text still works, but has a border as usual.
  #         CONTENT
          
  #       end
  #     end
  #   end
  # end