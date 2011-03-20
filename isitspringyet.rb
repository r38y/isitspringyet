require 'rubygems'
require 'sinatra'
require 'timeout'
require 'net/http'

get '/*' do
  @hemisphere = request.cookies["h"]
  @hemisphere = params[:splat].first
  if @hemisphere.nil? || @hemisphere.empty?
    remote_ip = env['REMOTE_ADDR']
    #remote_ip = '208.75.85.206'
    begin
      Timeout::timeout(3) do
        @latlng = Net::HTTP.get "tinygeocoder.com", "/create-api.php?q=#{remote_ip}"
      end
      @lat, @lng = *@latlng.split(",")
      @hemisphere = @lat.to_f > 0 ? 'n' : 's'
    rescue Timeout::Error
      @hemisphere = 'n'
    end
  end
  response.set_cookie("h", {:value => @hemisphere, :expires => (Time.now + 10*365*24*60*60)})
  dates = YAML.load_file("dates.yml")
  starts, ends = *dates["#{Date.today.year}#{@hemisphere}"]
  @spring = Date.today >= starts && Date.today < ends ? 'yes' : 'no'
  erb :index
end
