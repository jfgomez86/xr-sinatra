require 'sinatra'
require 'RMagick'
require 'json'
require 'open-uri'

APP_ID = ENV['APP_ID']

get '/' do
  return 200
end

get '/favicon.*' do
  return 200
end

get '/:currency' do
  content_type 'image/png'

  currency = params['currency']
  value = convert(currency)

  return text_to_img("#{value} #{currency}")
end

get '/:base/to/:currency' do
  content_type 'image/png'

  currency = params['currency']
  base = params['base']
  p [currency, base]
  value = convert(currency, base)

  return text_to_img("#{value} #{currency}")

end

def text_to_img(text)
  canvas = Magick::Image.new(420, 100){self.background_color = 'white'}
  canvas.format = "png"
  gc = Magick::Draw.new
  gc.pointsize(50)
  gc.text(30,70, text.center(14))

  gc.draw(canvas)

  canvas.to_blob
end

def convert(currency, base="USD")
  r = open("https://openexchangerates.org/api/latest.json?app_id=#{APP_ID}").read
  values = JSON.parse(r)["rates"]
  value = (values[currency]/values[base]).round(3)

  return value
end
