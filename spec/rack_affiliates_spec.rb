require 'helper'

describe "RackAffiliates" do
  before :each do
    clear_cookies
  end

  it "should handle empty affiliate info" do
    get '/'

    last_request.env['affiliate.tag'].must_equal nil
    last_request.env['affiliate.from'].must_equal nil
  end

  it "should set affiliate info from params" do
    get '/', {'ref'=>'123'}, 'HTTP_REFERER' => "http://www.foo.com"
    
    last_request.env['affiliate.tag'].must_equal "123"
    last_request.env['affiliate.from'].must_equal "http://www.foo.com"
  end

  it "should store affiliate info in a cookie" do 
    get '/', {'ref'=>'123'}, 'HTTP_REFERER' => "http://www.foo.com"

    rack_mock_session.cookie_jar["aff_tag"].must_equal "123"
    rack_mock_session.cookie_jar["aff_from"].must_equal "http://www.foo.com"
  end

  it "should restore affiliate info from cookie" do
    set_cookie("aff_tag=123")
    set_cookie("aff_from=http://www.foo.com")
    get '/', {}, 'HTTP_REFERER' => "http://www.bar.com"
    
    last_request.env['affiliate.tag'].must_equal "123"
    last_request.env['affiliate.from'].must_equal "http://www.foo.com"
  end

  describe "newer affiliate code in params" do
    it "should replace older cookie" do
      set_cookie("aff_tag=123")
      set_cookie("aff_from=http://www.foo.com")
      get '/', {'ref' => 456}, 'HTTP_REFERER' => "http://www.bar.com"

      last_request.env['affiliate.tag'].must_equal "456"
      last_request.env['affiliate.from'].must_equal "http://www.bar.com"
    end
  end
end
