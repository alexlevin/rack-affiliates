Rack::Referrals
=============

Rack::Affiliates is a rack middleware that extracts information about the referrals came from an an affiliated site. Specifically, it looks up for parameter (eg. <code>ref</code> by default) in the request. If found it persists referal tag, referring url and time in a cookie for later use.

Purpose
-------

Affiliate links tracking is very common task if you want to promote your online business. This middleware helps you to do that.

Installation
------------

Piece a cake:

    gem install rack-affiliates


Rails 3 Example Usage
---------------------

Add the middleware to your application stack:

    # Rails 3 App - in config/application.rb
    class Application < Rails::Application
      ...
      config.middleware.use Rack::Affiliates
      ...
    end
    
    # Rails 2 App - in config/environment.rb
    Rails::Initializer.run do |config|
      ...
      config.middleware.use "Rack::Affiliates"
      ...
    end

Now you can check any request to see who came to your site via an affiliated link and use this information in your application. Moreover, referrer_id is saved in the cookie and will come into play if user returns to your site later.

    class ExampleController < ApplicationController
      def index
        str = if request.env['affiliate.tag] && affiliate = User.find_by_affiliate_tag(request.env['affiliate.tag'])
          "Howdy, referral! You've been referred here by #{affiliate.name} and from #{request.env['affiliate.from']} @ #{Time.at(env['affiliate.time'])}"
        else
          "We're so glad you found us on your own!"
        end
        
        render :text => str
      end
    end


Customization
-------------

You can customize default parameter name <code>ref</code> by providing <code>:param</code> option.
If you want to save your affiliate id for later use, you can specify time to live with <code>:ttl</code> option (default is 30 days). 

    #Rails 3 in config/application.rb
    class Application < Rails::Application
      ...
      config.middleware.use Rack::Affiliates.new :param => 'aff_id', :ttl => 3.months 
      ...
    end

The <code>:domain</code> option allows to customize cookie domain. 

    class Application < Rails::Application
      ...
      config.middleware.use Rack::Affiliates.new :domain => '.example.org'
      ...
    end

Middleware will set cookie on '.example.org' domain so it's accessible on 'www.example.org', 'app.example.org' etc.


