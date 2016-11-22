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
    value = (amount.to_f * value)
  end

  return text_to_img("#{format_number(value.round(2))} #{currency}")

end

def format_number(number)
  parts = number.to_s.split('.')
  parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
  parts.join('.')
end

def text_to_img(text)
  gc = Magick::Draw.new
  default_pointsize = 12.0
  pointsize = 30.0
  initial_position = [4,30]

  gc.pointsize(pointsize)
  gc.text(*initial_position, text)

  canvas = Magick::Image.new((gc.get_type_metrics(text).width * pointsize/default_pointsize + 4), 34){self.background_color = 'white'}
  canvas.format = "png"
  gc.draw(canvas)
  canvas.write("test.png")

  canvas.to_blob
end

def convert(currency, base="USD")
  r = open("https://openexchangerates.org/api/latest.json?app_id=#{APP_ID}").read
  values = JSON.parse(r)["rates"]
  value = (values[currency]/values[base])

  return value
end
