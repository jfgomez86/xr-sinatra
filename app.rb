require 'sinatra'
require 'RMagick'
require 'json'
require 'open-uri'
require 'redis'

Cache = Redis.new

APP_ID = ENV['APP_ID']

get '/' do
  return 200
end

get '/favicon.*' do
  return 200
end

# TODO: add format parameter to enable other formats response. Will surely
# require a refactor.
get '/:currency' do
  content_type 'image/png'

  currency = params['currency']
  value = convert(currency)
  formatted_text = format_text(value, currency)

  return text_to_img(formatted_text)
end

get %r{/([0-9.]+)?([^\/?#\.]+)/to/([^\/?#\.]+)(\.txt+)?} do
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

  formatted_text = format_text(value, currency)

  case params[:captures][3]
  when '.txt'
    content_type 'text/plain'

    return formatted_text
  else
    content_type 'image/png'

    return text_to_img(formatted_text)
  end

end

def format_text(value, currency)
  "#{format_number(value.round(2))} #{currency}"
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

  canvas.to_blob
end

def convert(currency, base="USD")
  if (r = Cache.get('latest-xr')).nil?
    r = open("https://openexchangerates.org/api/latest.json?app_id=#{APP_ID}").read
    Cache.set('latest-xr', r)
    Cache.expire('latest-xr', 3600)
  end

  values = JSON.parse(r)["rates"]
  value = (values[currency]/values[base])

  return value
end
