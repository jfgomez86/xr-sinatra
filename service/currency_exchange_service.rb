class CurrencyExchangeService
  class << self
    def convert(currency, base="USD")
      value = nil
      if (r = Cache.get('latest-xr')).nil?
        r = open("https://openexchangerates.org/api/latest.json?app_id=#{APP_ID}").read
        Cache.set('latest-xr', r)
        Cache.expire('latest-xr', 3600)
      end
      values = JSON.parse(r)["rates"]
      if !values[currency].nil? && !values[base].nil?
        value = (values[currency]/values[base])
      end
      return value
    end
  end
end
