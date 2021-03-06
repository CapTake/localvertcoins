module MoneyService extend self

  CURRENCY_DATA = ExchangeRateService::CURRENCY_DATA

  def format(number, currency)
    "#{currency_prefix(currency)}#{format_number(number)}#{currency_suffix(currency)}"
  end

  private

  def format_number(number)
    if number < 1000
      '%.4f' % number
    else
      number.floor
    end
  end

  def currency_prefix(currency)
    CURRENCY_DATA[currency][:prefix]
  end

  def currency_suffix(currency)
    if suffix = CURRENCY_DATA[currency][:suffix]
      " #{suffix}"
    end
  end
end
