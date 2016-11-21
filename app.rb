require 'sinatra'
require 'RMagick'
require 'json'
require 'open-uri'

APP_ID = ENV['APP_ID']

get '/:currency' do
  content_type 'image/png'

  currency = params['currency']
  r = open("https://openexchangerates.org/api/latest.json?app_id=#{APP_ID}").read
  value = JSON.parse(r)["rates"][currency].round(3)

  canvas = Magick::Image.new(420, 100){self.background_color = 'yellow'}
  canvas.format = "png"
  gc = Magick::Draw.new
  gc.pointsize(50)
  gc.text(30,70, "#{value} #{currency}".center(14))

  gc.draw(canvas)

  canvas.to_blob
end
