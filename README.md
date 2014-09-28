Rack::Affiliates
================

Rack::Affiliates is a rack middleware that extracts information about the referrals came from an affiliated site. Specifically, it looks up for specific parameter (<code>ref</code> by default) in the request. If found, it persists affiliate tag, referring url and time in a cookie for later use.

Common Scenario
---------------

Affiliate links tracking is very common task if you want to promote your online business. This middleware helps you to do that.

1. You associate an affiliate tag (for eg. <code>ABC123</code>) with your partner.
2. The affiliate promotes your business at http://partner.org by linking to your site with like <code>http://yoursite.org?ref=ABC123</code>.
3. A user clicks through the link and lands on your site.
4. Rack::Affiliates middleware finds <code>ref</code> parameter in the request, extracts affiliate tag and saves it in a cookie
5. User signs up (now or later) and you mark it as a referral from your partner
6. PROFIT!

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

Now you can check any request to see who came to your site via an affiliated link and use this information in your application. Affiliate tag is saved in the cookie and will come into play if user returns to your site later.

    class ExampleController < ApplicationController
      def index
        str = if request.env['affiliate.tag'] && affiliate = User.find_by_affiliate_tag(request.env['affiliate.tag'])
          "Halo, referral! You've been referred here by #{affiliate.name} from #{request.env['affiliate.from']} @ #{Time.at(env['affiliate.time'])}"
        else
          "We're glad you found us on your own!"
        end
        
        render :text => str
      end
    end


Customization
-------------

You can customize parameter name by providing <code>:param</code> option (default is <code>ref</code>).
By default cookie is set for 30 days, you can extend time to live with <code>:ttl</code> option (default is 30 days). 

    #Rails 3/4 in config/application.rb
    class Application < Rails::Application
      ...
      config.middleware.use Rack::Affiliates, {:param => 'aff_id', :ttl => 3.months}
      ...
    end

The <code>:domain</code> option allows to customize cookie domain. 

    #Rails 3/4 in config/application.rb
    class Application < Rails::Application
      ...
      config.middleware.use Rack::Affiliates, :domain => '.example.org'
      ...
    end

The <code>:path</code> option allows to hardcode the cookie path allowing you to record affiliate links at any URL on your site.

    #Rails 3/4 in config/application.rb
    class Application < Rails::Application
      ...
      config.middleware.use Rack::Affiliates, { :path => '/' }
      ...
    end

Middleware will set cookie on <code>.example.org</code> so it's accessible on <code>www.example.org</code>, <code>app.example.org</code> etc.

The <code>:overwrite</code> option allows to set whether to overwrite the existing affiliate tag previously stored in cookies. By default it is set to `true`.

If you want to capture more attributes from the query string whenever it comes from an affiliate you can define those with the <code>extra_params</code> value.

    #Rails 3/4 in config/application.rb
    class Application < Rails::Application
      ...
      config.middleware.use Rack::Affiliates, { :extra_params => [:great_query_parameter] }
      ...
    end

These will be availble through <code>env['affiliate.extras']</code> as a hash with the same keys.

Credits
=======

Thanks goes to Rack::Referrals (https://github.com/deviantech/rack-referrals) for the inspiration.

