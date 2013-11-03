require 'pay_dirt'
require 'pry'
require 'net/http'
require 'csv'

module HorizonEvent
  class Request < PayDirt::Base
    def initialize(options = {})
      options = {
        http_headers: {
          "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
          "Accept-Language" => "en-US,en;q=0.5",
          "Accept-Encoding" => "gzip, deflate",
          "Referer" => "http://aa.usno.navy.mil/data/docs/RS_OneYear.php"
        },
        year:  Time.now.year.to_s,
        place: "Birmingham",
        state: "AL",
        type:  "0",
        ffx:   "1",
        zzz:   "END",
        host: "aa.usno.navy.mil",
        url: "http://aa.usno.navy.mil/cgi-bin/aa_rstablew.pl"
      }.merge(options)

      load_options(:http_headers, :ffx, :year, :type, :state, :place, :zzz, :host, :url, options)
    end

    def call
      response = request_response.body
      parsed_response = parse(response)
      csv_response = csv(parsed_response)
      return result(true, {
        raw: response,
        parsed: parsed_response,
        csv: csv_response,
      })

    end

    private
    def request_response
      response = Net::HTTP.start(@host) do |http|
        request = Net::HTTP::Post.new(URI.parse(@url).path)
        @http_headers.map { |k, v| request[k] = v }
        request.body = "FFX=1&xxy=#{@year}&type=0&st=#{@state}&place=#{@place}&ZZZ=END"
        http.request request
      end
    end

    def parse(text)
      rows = text.split("\n").select { |row| "0".upto("3").to_a.include?(row[0]) }
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

    def csv(options)
      csv_string = CSV.generate do |csv|
        csv << [ "day" , "sunrise" , "sunset", "cap"]
        i=0
        options.each do |k,v|
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
