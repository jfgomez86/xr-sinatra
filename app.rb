require_relative 'models/currency'
require_relative 'utils/currency_utils'
require_relative 'service/currency_exchange_service'
# @version 1.0
class App < Sinatra::Base
  register Sinatra::Namespace

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
    value = CurrencyExchangeService.convert(currency)

    if value.nil?
      status 404
      content_type 'image/png'
      return text_to_img("Not found this currency with code: #{currency}.")
    end

    formatted_text = CurrencyUtils.format_text(value, currency)

    return CurrencyUtils.text_to_img(formatted_text)
  end

  get %r{/([0-9.]+)?([^\/?#\.]+)/to/([^\/?#\.]+)(\.(txt|html|json)+)?} do
  if params[:captures].length == 2
    base, currency = *params[:captures]
    amount = nil
  else
    amount, base, currency = *params[:captures]
  end

  value = CurrencyExchangeService.convert(currency, base)

  if value.nil?
    code = 404
    @message = "Not found currency code: #{currency} and base code: #{base}."
    case params[:captures][3]
    when '.txt'
      status code
      content_type 'text/plain'
      return @message
    when '.html'
      status code
      content_type 'text/html'
      erb :error and return @message
    when '.json'
      halt code, { 'Content-Type' => 'application/json' }, { message: "I couldn't find that currency or that value is not allowed." }.to_json
    else
      status code
      content_type 'image/png'
      return CurrencyUtils.text_to_img(@message)
    end
  end

  if !amount.nil?
    value = (amount.to_f * value)
  end

  @formatted_text = CurrencyUtils.format_text(value, currency)

  case params[:captures][3]
  when '.txt'
    content_type 'text/plain'
    return @formatted_text
  when '.html'
    content_type 'text/html'
    erb :convert
  when '.json'
    message = ''
    if !amount.nil?
      formatted_base = CurrencyUtils.format_text(amount.to_f, base)
      formatted_to = CurrencyUtils.format_text(value, currency)
      message = "$#{formatted_base} would be $#{formatted_to}"
    else
      formatted_text = CurrencyUtils.format_text(value, currency)
      message = "It is $#{formatted_text} per #{base}"
    end
    halt 200, {'Content-Type' => 'application/json'}, { message:message }.to_json
  else
    content_type 'image/png'
    return CurrencyUtils.text_to_img(@formatted_text)
  end
end
# /api/v1/exchange
namespace '/api/v1' do

  before do
    content_type 'application/json'
  end

  helpers do
    def currency_params
      begin
        json_object = JSON.parse(request.body.read)
        require_root(json_object.keys.join(''), 'currency')
        json_object['currency']
      rescue
        halt 400, {'Content-Type' => 'application/json'}, { message: 'Invalid JSON' }.to_json
      end
    end

    def require_root(entry_key, root_name)
      halt 400, {'Content-Type' => 'application/json'}, { message: 'Invalid JSON' }.to_json if entry_key!=root_name
    end
  end

  post "/exchange" do
    currency = Currency.new(currency_params)
    value = CurrencyExchangeService.convert(currency.to, currency.base)
    if currency.valid? && value
      code = 200
      if !currency.amount.blank?
        value = (currency.amount.to_f * value)
        formatted_base = CurrencyUtils.format_text(currency.amount.to_f, currency.base)
        formatted_to = CurrencyUtils.format_text(value, currency.to)
        message = "$#{formatted_base} would be $#{formatted_to}"
      else
        formatted_text = CurrencyUtils.format_text(value, currency.to)
        message = "It is $#{formatted_text} per #{currency.base}"
      end
    elsif currency.errors.blank?
      code = 404
      message = "not found currency code: #{currency.to} and base code: #{currency.base}"
    else
      code = 422
      message = currency.errors.full_messages.flatten
    end
    halt code, {'Content-Type' => 'application/json'}, { message:message }.to_json
  end
end

end
