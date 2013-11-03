require 'pay_dirt'

module HorizonEvent
  class KeyValuePairing < PayDirt::Base
    def initialize(options = {})
      options = {
        request_class: HorizonEvent::Request,
        ret_hash: {
          "1"  => {},
          "2"  => {},
          "3"  => {},
          "4"  => {},
          "5"  => {},
          "6"  => {},
          "7"  => {},
          "8"  => {},
          "9"  => {},
          "10" => {},
          "11" => {},
          "12" => {}
        }
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

      parse_rows_to_hash(rows) and return @ret_hash
    end

    def parse_rows_to_hash(rows)
      rows.each do |row|
        x1, x2, step, day = 4, 12, 11, row[0..1].to_i.to_s

        @ret_hash.each_key do |k|
          rise_and_set = row[x1..x2].split(" ")
          @ret_hash[k][day] = { sunrise: rise_and_set[0], sunset: rise_and_set[1] }

          x1, x2 = (x1 + step), (x2 + step)
        end
      end
    end
  end
end
