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

get %r{/([0-9.]+)?([^\/?#\.]+)/to/([^\/?#\.]+)} do
  content_type 'image/png'

  if params[:captures].length == 2
    base, currency = *params[:captures]
    amount = nil
  else
    amount, base, currency = *params[:captures]
  end

  value = convert(currency, base)

  if !amount.nil?
    value = (amount.to_f * value).round(3)
  end

  return text_to_img("#{value} #{currency}")

end

def text_to_img(text)
  gc = Magick::Draw.new
  gc.pointsize(30)
  gc.text(4,30, text)

  canvas = Magick::Image.new((gc.get_type_metrics(text).width * 30/12.0 + 4), 34){self.background_color = 'white'}
  canvas.format = "png"
  gc.draw(canvas)
  canvas.write("test.png")

  canvas.to_blob
end

def convert(currency, base="USD")
  r = open("https://openexchangerates.org/api/latest.json?app_id=#{APP_ID}").read
  values = JSON.parse(r)["rates"]
  value = (values[currency]/values[base]).round(3)

  return value
end
