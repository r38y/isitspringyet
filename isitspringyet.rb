require 'rubygems'
require 'sinatra'
DATES = YAML.load_file("dates.yml")

get '/' do
  @hemisphere = request.cookies["h"]
  @hemisphere = params["h"] unless params['h'].nil?
  if @hemisphere.nil? || @hemisphere.empty?
    remote_ip = env['REMOTE_ADDR']
    remote_ip = '208.75.85.206'
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
  set_cookie("h", {:value => @hemisphere, :expires => (Time.now + 10*365*24*60*60)})
  starts, ends = *DATES["#{Date.today.year}#{@hemisphere}"]
  @spring = Date.today >= starts && date.today < ends ? 'yes' : 'no'
  erb :index
end