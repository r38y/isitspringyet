require 'rubygems'
require 'sinatra'
require 'net/http'

get '/' do
  remote_ip = env['REMOTE_ADDR']
  # remote_ip = '208.75.85.206'
  begin
    Timeout::timeout(3) do
      @latlng = Net::HTTP.get "tinygeocoder.com", "/create-api.php?q=#{remote_ip}"
    end
    @lat, @lng = *@latlng.split(",")
    @hemisphere = @lat.to_f > 0 ? 'northern' : 'southern'
  rescue Timeout::Error
    @hemisphere = 'northern'
  end
  erb :index
end