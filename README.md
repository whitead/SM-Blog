Science & Math Blogging Framework
=========================

A Jekyll blog optimized for equations, graphs, and academic writing.

[See example](http://andrew-white.com/blog)


Dependencies
=========================

Requires `ruby`, `jekyll`, `jekyll-scholar`, `rake` and `uglifier`

    [sudo] gem install jekyll jekyll-scholar rake uglifier

Also requires you to have a local clean version of `bootstrap`, which
you can get by running

    git clone https://github.com/twitter/bootstrap.git bootstrap

I've written this with version 3.3.1, which you can make sure you have by running
 
    cd bootstrap && git checkout tags/v3.3.1

Also requires `node-js` for the package less, which you can get by installing `npm`, the node-js package manager and running

    npm install less

Installation
=========================

After installing dependencies, run:

    git clone https://github.com/whitead/SM-Blog SM-Blog

Then edit the `Rakefile` to point to your bootstrap version in the top
line. Follow instructions from the [jekyll docs](http://jekyllrb.com)
for configuring the website and adding posts.

Building
=========================

To generate and view the website, run the following from the git root directory

    rake
    jekyll serve

Editing CSS
=========================

Edit the CSS in `bootstrap/less/custom.less` to modify the style of
the website. Re-run rake eachtime you modify this file.

Custom Site-URL
=========================

Custom baseurls can be added only to `_config.yml` and the Rakefile
will read and process it as needed.