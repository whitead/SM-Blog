# Title: Image Path
# Author: Andrew White, Sam Rayner http://samrayner.com
# Description: Output an image referring to assets
#
# Syntax {% image_path [image_name] %}
#
# Examples:
# {% image_path kitten.png %} on post 2013-01-01-post-title
#
#

module Jekyll
  class PostImage < Liquid::Tag
    @filename = nil

    def initialize(tag_name, markup, tokens)
      #strip leading and trailing quotes
      @filename = markup.strip.gsub(/^("|')|("|')$/, '')
      super
    end

    def render(context)
      if @filename.empty?
        return "Error processing input, expected syntax: {% post_image image %}"
      end


      path = ''
      page = context.environments.first['page']
      base = context.registers[:site].config['baseurl']

      #if a post
      if page["id"]
        #loop through posts to find match and get slug
        context.registers[:site].posts.each do |post|
          if post.id == page["id"]
            path = "#{post.slug}"
          end
        end
      else
        path = page["url"]
      end

      #strip filename
      path = File.dirname(path) if path =~ /\.\w+$/

      #get root
      basename = @filename.chomp(File.extname(@filename))
      #fix double slashes
      link_path = "#{base}/assets/img/#{path}/#{@filename}".gsub(/\/{2,}/, '/')
      preview_path = "#{base}/assets/img/#{path}/#{basename}_preview.jpg".gsub(/\/{2,}/, '/')
      
      #now create output
      html = '<a href="' + link_path + '" class="thumbnail post-image-link">'
      html += '<img class="img-responsive post-image"  src="' + preview_path + '" alt="">'
      html += '</a>'

      html
    end
  end
end

Liquid::Template.register_tag('post_image', Jekyll::PostImage)

