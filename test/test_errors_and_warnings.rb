require 'test/unit'

class RedcapSurveyApiTest < Test::Unit::TestCase
  def test_no_url
    begin
      RedcapSurveyApi::RedcapApi.new({:token => "blah"}).export()
    rescue => e
    end

    assert_equal("!ERROR: 'url' is a required parameter.", "#{e}")
  end

  def test_no_token
    begin
      RedcapSurveyApi::RedcapApi.new({:url => "lala"}).export()
    rescue => e
    end

    assert_equal("!ERROR: 'token' is a required parameter.", "#{e}")
  end

  def test_warning
    $stderr   = StringIO.open('','w')

    RedcapSurveyApi::RedcapApi.new({:token => "x", :url => "y", :format => 'invalid'}).export()

    assert_equal("!WARNING: Your parser 'JSON' and your default format 'invalid' don't seem to match.", $stderr.string.chomp)
  end
end
