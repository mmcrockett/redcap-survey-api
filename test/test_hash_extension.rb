require 'test/unit'

class RedcapSurveyHashExtensionTest < Test::Unit::TestCase
  def test_hash_extension
    t = {:a => [1,2,3], :b => ["h", "i", "j"]}
    e = {"a[0]" => 1, "a[1]" => 2, "a[2]" => 3, "b[0]" => "h", "b[1]" => "i", "b[2]" => "j"}
    assert_equal(e, t.to_http_post_array)
  end
end
