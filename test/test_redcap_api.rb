require 'test/unit'
require 'redcap-survey-api'
require 'csv'
require 'Nokogiri'
require 'StringIO'

class Hash
  def body
    return self[:body]
  end
end

class Mechanize
  def post(url, payload)
    v = {}

    if ('json' == payload[:format])
      if ('metadata' == payload[:content])
        v[:body] = '[{"field_name":"record_id", "form_name":"form0"},{"field_name":"first_name", "form_name":"form0"},{"field_name":"trc_id", "form_name":"form0"}]'
      else
        v[:body] = '[{"record_id":"1", "trc_id":"b", "first_name":"bob"},{"record_id":"2", "trc_id":"c", "first_name":"chris"}]'
      end
    elsif ('xml' == payload[:format])
      v[:body] = '<?xml version="1.0" encoding="UTF-8" ?><records><item><record_id><![CDATA[1]]></record_id><trc_id>b</trc_id><first_name>bob</first_name></item><item><record_id><![CDATA[2]]></record_id><trc_id>c</trc_id><first_name>chris</first_name></item></records>'
    elsif ('csv' == payload[:format])
      v[:body] = 'record_id,trc_id,first_name'
      v[:body] << "\n"
      v[:body] << '"1","b","bob"'
      v[:body] << "\n"
      v[:body] << '"2","c","chris"'
    else
      v[:body] = '[{"record_id":"1", "trc_id":"b", "first_name":"bob"},{"record_id":"2", "trc_id":"c", "first_name":"chris"}]'
    end

    return v
  end
end

class RedcapSurveyApiTest < Test::Unit::TestCase
  DEFAULT_CONNECTION = {:url => "http://localhost:8080/redcap/api", :token => "ABC123"}

  def test_default_parser
    default   = RedcapSurveyApi::RedcapApi.new(DEFAULT_CONNECTION).export()
    json_data = RedcapSurveyApi::RedcapApi.new(DEFAULT_CONNECTION.merge({:parser => JSON})).export({:format => 'json'})

    assert_equal(json_data, default)
  end

  def test_xml_parser
    xml_data  = RedcapSurveyApi::RedcapApi.new(DEFAULT_CONNECTION.merge({:parser => Nokogiri::XML::Document})).export({:format => 'xml'})
    json_data = RedcapSurveyApi::RedcapApi.new(DEFAULT_CONNECTION.merge({:parser => JSON})).export({:format => 'json'})
    xml_to_json_data = []

    xml_data.xpath(".//item").each do |item_node|
      json_record = {}
      item_node.children().each do |value_node|
        json_record[value_node.name()] = value_node.content()
      end
      xml_to_json_data << json_record
    end

    assert_equal(json_data, xml_to_json_data)
  end

  def test_csv_parser
    csv_data  = RedcapSurveyApi::RedcapApi.new(DEFAULT_CONNECTION.merge({:parser => CSV})).export({:format => 'csv'})
    json_data = RedcapSurveyApi::RedcapApi.new(DEFAULT_CONNECTION.merge({:parser => JSON})).export({:format => 'json'})
    csv_to_json_data = []

    csv_data.each_with_index do |record,i|
      if (0 != i)
        json_record = {}
        record.each_with_index do |value,j|
          json_record[csv_data[0][j]] = value
        end
        csv_to_json_data << json_record
      end
    end

    assert_equal(json_data, csv_to_json_data)
  end

  def test_none_parser
    $stderr   = StringIO.open('','w')
    none_data = RedcapSurveyApi::RedcapApi.new(DEFAULT_CONNECTION.merge({:parser => RedcapSurveyApi::EmptyParser})).export({:format => 'xml'})

    assert_equal('<?xml version="1.0" encoding="UTF-8" ?><records><item><record_id><![CDATA[1]]></record_id><trc_id>b</trc_id><first_name>bob</first_name></item><item><record_id><![CDATA[2]]></record_id><trc_id>c</trc_id><first_name>chris</first_name></item></records>', none_data)
    assert_equal("", $stderr.string.chomp)
  end

  def test_param_override
    metadata = RedcapSurveyApi::RedcapApi.new(DEFAULT_CONNECTION).export_metadata()
    data     = RedcapSurveyApi::RedcapApi.new(DEFAULT_CONNECTION).export_metadata({:content => 'record'})

    assert_not_equal(data, metadata)
  end

  def test_metadata
    metadata = RedcapSurveyApi::RedcapApi.new(DEFAULT_CONNECTION).export_metadata()
    data = [{"field_name"=>"record_id", "form_name"=>"form0"},{"field_name"=>"first_name", "form_name"=>"form0"},{"field_name"=>"trc_id", "form_name"=>"form0"}]

    assert_equal(data, metadata)
  end

  def test_metadata_fields
    fields = RedcapSurveyApi::RedcapApi.new(DEFAULT_CONNECTION).export_metadata_fields()

    assert_equal(["record_id", "first_name", "trc_id"], fields)
  end
end
