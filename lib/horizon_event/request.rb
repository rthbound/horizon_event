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
        city: "Birmingham",
        state: "AL",
        type:  "0",
        ffx:   "1",
        zzz:   "END",
        host: "aa.usno.navy.mil",
        url: "http://aa.usno.navy.mil/cgi-bin/aa_rstablew.pl"
      }.merge(options)

      load_options(:http_headers, :ffx, :year, :type, :state, :city, :zzz, :host, :url, options)
    end

    def call
      return result(true, request_response.body)
    end

    private
    def request_response
      response = Net::HTTP.start(@host) do |http|
        request = Net::HTTP::Post.new(URI.parse(@url).path)
        @http_headers.map { |k, v| request[k] = v }
        request.body = "FFX=1&xxy=#{@year}&type=0&st=#{@state}&place=#{@city}&ZZZ=END"
        http.request request
      end
    end
  end
end
