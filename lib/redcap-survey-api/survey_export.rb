module REDCapSurvey
  class SurveyExport
    attr_reader :data

    DEFAULT_PARAMS = {
      'content' => 'record',
      'format'  => 'json',
      'type'    => 'flat'
    }

    def initialize(params = {})
      @connection = REDCapSurvey::Connection.new(params)
      @data = nil
    end

    def export_data(params = {})
      @data = @connection.post(DEFAULT_PARAMS.merge(params))

      return @data
    end
  end
end
