require 'sinatra'
require 'RMagick'
require 'json'
require 'open-uri'


get '/:currency' do
  content_type 'image/png'

  currency = params['currency']
  r = open("https://openexchangerates.org/api/latest.json?app_id=2307d50aedb840ae8c0204bfbd0aeb63").read
  value = JSON.parse(r)["rates"][currency].round(3)

  canvas = Magick::Image.new(420, 100){self.background_color = 'yellow'}
  canvas.format = "png"
  gc = Magick::Draw.new
  gc.pointsize(50)
  gc.text(30,70, "#{value} #{currency}".center(14))

  gc.draw(canvas)

  canvas.to_blob
end
