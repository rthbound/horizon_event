require 'pay_dirt'

module HorizonEvent
  class KeyValuePairing < PayDirt::Base
    def initialize(options = {})
      options = {
        request_class: HorizonEvent::Request
      }.merge(options)

      # sets instance variables from key value pairs,
      # will fail if any keys given before options aren't in options
      load_options(:request_class, :city, :state, options)
    end

    def call
      return result(true, key_value_pairing)
    end

    private
    def key_value_pairing
      rows = @request_class.new(city: @city, state: @state).call.data.split("\n")
      rows = rows.select { |row| "0".upto("3").to_a.include?(row[0]) }

      options = {} and 1.upto(12) { |i| options.merge!({ i.to_s => {} }) }

      rows.each do |row|
        x1, x2, step, day = 4, 12, 11, row[0..1].to_i.to_s
        options.each do |k,v|
          rise_and_set = row[x1..x2].split(" ")
          options[k][day] = { sunrise: rise_and_set[0], sunset: rise_and_set[1] }

          x1, x2 = (x1 + step), (x2 + step)
        end
      end

      return options
    end
  end
end
