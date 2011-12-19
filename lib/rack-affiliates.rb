module Rack
  #
  # Rack Middleware for extracting information from the request params and cookies.
  # It populates +env['affiliate.tag']+ and 
  # +env['affiliate.from']+ if it detects a request came from an affiliated link 
  #
  class Affiliates
    COOKIE_TAG = "aff_tag"
    COOKIE_FROM = "aff_from"

    def initialize(app, opts = {})
      @app = app
      @param = opts[:param] || "ref"
      @cookie_ttl = opts[:ttl] || 60*60*24*30  # 30 days
    end

    def call(env)
      req = Rack::Request.new(env)
      tag, from = affiliate_info(req)

      if tag
        env["affiliate.tag"] = tag
        env['affiliate.from'] = from
      end
      
      status, headers, body = @app.call(env)

      response = Rack::Response.new body, status, headers
      bake_cookies(response, tag, from) if tag
      response.finish
    end

    def affiliate_info(req)
      params_info(req) || cookie_info(req) 
    end

    def params_info(req)
      [req.params[@param], req.env["HTTP_REFERER"]] if req.params[@param]
    end

    def cookie_info(req)
      [req.cookies[COOKIE_TAG], req.cookies[COOKIE_FROM]] if req.cookies[COOKIE_TAG]
    end

    protected
    def bake_cookies(res, tag, from)
      expires = Time.now + @cookie_ttl

      res.set_cookie(COOKIE_TAG, :value => tag, :path => "/", :expires => expires)
      res.set_cookie(COOKIE_FROM, :value => from, :path => "/", :expires => expires)
    end
  end
end
