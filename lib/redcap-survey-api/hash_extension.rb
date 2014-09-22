class Hash
  def to_http_post_array
    r = {}

    self.each_key do |k|
      if (false == self[k].is_a?(Array))
        raise "!ERROR: Expecting hash value to be an Array."
      end

      self[k].each_with_index do |v,i|
        r["#{k}[#{i}]"] = v
      end
    end

    return r
  end
end
