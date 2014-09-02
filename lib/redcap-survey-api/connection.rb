module REDCapSurvey
  class Connection
    def initialize(params = {})
      @url = URI.parse(params[:uri])
      @http = Net::HTTP.new(@url.host, @url.port)
      @http.use_ssl = (@url.scheme == 'https')
      @token = params[:token]
    end

    def post(data = {}, headers = {})
      if (false == data.include?(:token))
        data[:token] = @token
      end

      puts "POSTING: https://#{@http.address}:#{@http.port}#{@url.path}\n#{data}"
      request  = Net::HTTP::Post.new(@url.path, headers)
      request.set_form_data(data)
      response = @http.request(request)

      if (true == response.is_a?(Net::HTTPOK))
        return response.body
      else
        raise "!ERROR: Failed to connect because '#{response.message}'"
      end
    end
  end
end
