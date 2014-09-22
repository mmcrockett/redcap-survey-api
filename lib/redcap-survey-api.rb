require "json"
require "mechanize"

class RedcapSurveyApi
  DEFAULT_PARAMS = {
    :content => 'record',
    :format  => 'json',
    :type    => 'flat'
  }

  def initialize(params = {})
    @url             = params[:url]
    @payload         = DEFAULT_PARAMS
    @payload[:token] = params[:token]
    @parser          = params[:parser] || JSON

    if (false == @parser.is_a?(JSON))
      if ('json' == @payload[:format])
        puts "!WARNING: Your parser '#{@parser}' and your default format '#{@payload[:format]}' don't seem to match."
      end
    end
  end

  def export_metadata_fields
    response = export_metadata()
    if response
      response.collect {|r| r['field_name'] if r }
    end
  end

  def export(params = {})
    return @parser.parse(api(params))
  end

  def export_metadata(params = {})
    payload = {:content => 'metadata'}.merge(params)
    return self.export(payload)
  end

  def import(params = {})
    return api(params)
  end

  def api(params = {})
    payload = @payload.merge(params)
    return Mechanize.new.post(@url, payload).body
  end
end
