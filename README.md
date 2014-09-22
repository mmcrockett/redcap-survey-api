# Usage

This is an api to utilize RedCAP api with ruby.

To start:

```ruby
r = RedcapSurveyApi.new({:token => "abc123", :url => "http://localhost/redcap/api"}) # Authentication token provided by RedCAP, server API url.
r = RedcapSurveyApi.new({:token => "abc123", :url => "http://localhost/redcap/api", :parser => JSON}) # Set the parser, default is JSON, other parsers are Nokogiri::XML and CSV. See tests for examples.

r.export(optional params) # returns all records in 'parser' format, provide additional hash of parameters in you want to override or add any additional RedCAP options.

r.export_metadata(optional params) # returns all metadata records in JSON format, provide additional hash of parameters in you want to override or add any additional RedCAP options.

r.export_metadata_fields() # returns all fields (this is a sub-set of metadata). 

r.import(optional params) # imports new records.

r.api(optional params) # returns the raw data, this allows you to get data without using the 'parser'.

There is also a helper class added to ruby Hash allowing you to convert a ruby array to a http-post style array. I created this after having some issues filtering on 'forms' and 'fields'
Example:
params = {:fields => ['record_id', 'lab_id'], :forms => ['slide_tracking', 'id_shipping']} # This is the data I want to send to RedCAP, limiting the fields and forms
r.export_metadata(params.to_http_post_array()) # This gets the metadata for only those fields/forms by using the newly added method on Hash 'to_http_post_array'.
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/redcap-survey-api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
