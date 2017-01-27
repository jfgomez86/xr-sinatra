class CurrencyUtils
  class << self
    # Methods
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
  end
end
