require 'pay_dirt'

module HorizonEvent
  class Delimited < PayDirt::Base
    def initialize(options = {})
      options = {
        delimiter: ",",
        request_class: HorizonEvent::Request,
        key_value_pairing_class: HorizonEvent::KeyValuePairing
      }.merge(options)
      # sets instance variables from key value pairs,
      # will fail if any keys given before options aren't in options
      load_options(:state, :city, :delimiter, options)
    end

    def call
      return result(true, csv)
    end

    def csv
      csv_string = CSV.generate(col_sep: @delimiter) do |csv|
        csv << [ "day" , "sunrise" , "sunset", "cap"]
        i=0

        hash = @key_value_pairing_class.new(city: @city, state: @state, request_class: @request_class).call.data
        hash.each do |k,v|
          v.each do |monthday, events|
            i+=1
            if !!events[:sunrise] || !!events[:sunset]
              csv << [i, events[:sunrise].to_i, events[:sunset].to_i, "2400"]
            end
          end
        end
      end
    end
  end
end
