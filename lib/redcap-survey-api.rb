require 'json'
require 'mechanize'
require 'redcap-survey-api/hash_extension'
require 'redcap-survey-api/empty_parser'

module RedcapSurveyApi
  class RedcapApi
    DEFAULT_PARAMS = {
      :content => 'record',
      :format  => 'json',
      :type    => 'flat',
      :parser  => JSON
    }

    def initialize(params = {})
      @payload = DEFAULT_PARAMS.merge(params)
    end

    def export(params = {})
      return api(params)
    end

    def export_metadata(params = {})
      payload = {:content => 'metadata'}.merge(params)
      return export(payload)
    end

    def export_metadata_fields
      response = export_metadata()
      if response
        response.collect {|r| r['field_name'] if r }
      end
    end

    def import(params = {})
      return api(params)
    end

    private
    def api(params = {})
      payload = @payload.merge(params)
      validate(payload)

      return payload[:parser].parse(Mechanize.new.post(@url, payload).body)
    end

    def validate(params)
      [:token, :url].each do |required_param|
        if (false == params.include?(required_param))
          raise "!ERROR: '#{required_param}' is a required parameter."
        end
      end

      if ((false == "#{params[:parser]}".include?("EmptyParser")) && (false == "#{params[:parser]}".downcase.include?(params[:format])))
        $stderr.puts "!WARNING: Your parser '#{params[:parser]}' and your default format '#{params[:format]}' don't seem to match."
      end
    end
  end
end
