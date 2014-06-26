# Where our Bootstrap source is installed. Can be overridden by an environment variable.
BOOTSTRAP_SOURCE = ENV['BOOTSTRAP_SOURCE'] || File.expand_path("~/bootstrap")

# Where to find our custom LESS file.
BOOTSTRAP_CUSTOM_LESS = 'bootstrap/less/custom.less'

IMG_DIR = 'assets/img'
PREVIEW_STRING = ' -resize 600 '
THUMBNAIL_STRING = ' -resize 150 '


task :default => :jekyll

task :jekyll => [:bootstrap, :process_images] do
  sh 'jekyll build'
end

task :build_dir do
  sh 'mkdir -p bootstrap/js bootstrap/fonts bootstrap/less bootstrap/css'
end

task :process_images do
  Dir.entries(IMG_DIR).each do |img_dir|
    if img_dir == '.' or img_dir == '..'
      next
    end
    puts "Converting pngs in " + img_dir
    Dir.glob(File.join(IMG_DIR, img_dir, '*.png')).each do |png_img|
      jpg_filename = png_img.chomp(File.extname(png_img)) + '.jpg'
      if not File.exists?(jpg_filename)
        sh 'convert ' + png_img + ' ' + jpg_filename
      end
    end
    puts "making previews in " + img_dir 
    Dir.glob(File.join(IMG_DIR, img_dir, '*.jpg')).each do |jpg_img|
      preview_filename = jpg_img.chomp(File.extname(jpg_img)) + '_preview.jpg'    
      if not File.exists?(preview_filename) and not jpg_img.include? '_preview' and not jpg_img.include? '_thumb'
        sh 'convert ' + jpg_img + PREVIEW_STRING + preview_filename
      end
    end
    puts "making thumbnails in " + img_dir 
    Dir.glob(File.join(IMG_DIR, img_dir, '*.jpg')).each do |jpg_img|
      thumb_filename = jpg_img.chomp(File.extname(jpg_img)) + '_thumb.jpg'    
      if not File.exists?(thumb_filename) and not jpg_img.include? '_preview' and not jpg_img.include? '_thumb'
        sh 'convert ' + jpg_img + THUMBNAIL_STRING + thumb_filename
      end
    end

  end
end
      

#bootstrap compile and minify
task :bootstrap => [:bootstrap_js, :bootstrap_css, :build_dir]

task :bootstrap_js do
  require 'uglifier'
  require 'erb'

  #get server baseurl
  require 'yaml'
  config = YAML.load_file('_config.yml')
  

  template = ERB.new %q{
  <!-- AUTOMATICALLY GENERATED. DO NOT EDIT. -->
  <% paths.each do |path| %>
  <script type="text/javascript" src="<%= config['baseurl']%>/bootstrap/js/<%= path %>"></script>
  <% end %>
  }

  paths = []
  minifier = Uglifier.new
  Dir.glob(File.join(BOOTSTRAP_SOURCE, 'js', '*.js')).each do |source|
    base = File.basename(source).sub(/^(.*)\.js$/, '\1.min.js')
    paths << base
    target = File.join('bootstrap/js', base)
    if different?(source, target)
      File.open(target, 'w') do |out|
        out.write minifier.compile(File.read(source))
      end
    end
  end

  File.open('_includes/bootstrap.js.html', 'w') do |f|
    f.write template.result(binding)
  end
end


task :bootstrap_css do |t|
  puts "Copying LESS files"
  Dir.glob(File.join(BOOTSTRAP_SOURCE, 'less', '*.less')).each do |source|
    target = File.join('bootstrap/less', File.basename(source))
    cp source, target if different?(source, target)
  end
  puts "Copying mixin files"
  Dir.glob(File.join(BOOTSTRAP_SOURCE, 'less/mixins', '*.less')).each do |source|
    target = File.join('bootstrap/less/mixins', File.basename(source))
    cp source, target if different?(source, target)
  end
  puts "Copying fonts"
  Dir.glob(File.join(BOOTSTRAP_SOURCE, 'fonts', '*')).each do |source|
    target = File.join('bootstrap/fonts', File.basename(source))
    cp source, target if different?(source, target)
  end

  puts "Compiling #{BOOTSTRAP_CUSTOM_LESS}"
  sh 'lessc', '--compress', BOOTSTRAP_CUSTOM_LESS, 'bootstrap/css/bootstrap.min.css'
end


def different?(path1, path2)
  require 'digest/md5'
  different = false
  if File.exist?(path1) && File.exist?(path2)
    path1_md5 = Digest::MD5.hexdigest(File.read path1)
    path2_md5 = Digest::MD5.hexdigest(File.read path2)
    (path2_md5 != path1_md5)
  else
    true
  end
end
