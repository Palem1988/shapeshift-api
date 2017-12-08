require "shapeshift/api/version"
require 'net/http'

module Shapeshift
  class Api

    def coins
      get 'getcoins'
    end

    #
    # minimum, limit - measured in from_symbol
    # rate = from_symbol / to_symbol
    # minerFee - measured in to_symbol
    #
    def rate from_symbol, to_symbol = 'btc'
      get "marketinfo/#{pair(from_symbol, to_symbol)}"
    end

    def quote amount_to, from_symbol, to_symbol = 'btc'
      post 'sendamount', {amount: amount_to, pair: pair(from_symbol, to_symbol)}
    end

    # {"success"=>{"orderId"=>"23902010-5280-499c-8065-50ff3fc9f24a",
    # "pair"=>"eth_gnt", "withdrawal"=>"0xd7170547046adc91b5cdf39bc04ad70e95d0a825",
    # "withdrawalAmount"=>"30", "deposit"=>"0x553beec262e0ab11dfe43f7d60dc1f51f03e4398",
    # "depositAmount"=>"0.02696698", "expiration"=>1512726449980, "quotedRate"=>"1557.46037437",
    # "maxLimit"=>11.57075248, "apiPubKey"=>"shapeshift", "minerFee"=>"12"}}
    #
    def sendamount amount_to, address_to, from_symbol, to_symbol = 'btc'
      post 'sendamount', {amount: amount_to, withdrawal: address_to, pair: pair(from_symbol, to_symbol)}
    end

    # {"status"=>"no_deposits", "address"=>"0x553beec262e0ab11dfe43f7d60dc1f51f03e4398"}
    def status address
      get "txStat/#{address}"
    end


    private

    def pair from_symbol, to_symbol
      "#{from_symbol.to_s.downcase}_#{to_symbol.to_s.downcase}"
    end

    def get method_args
      r = Net::HTTP.get(URI.parse("https://shapeshift.io/#{method_args}"))
      JSON.parse(r)
    end


    def post method, args
      r = Net::HTTP.post_form(URI.parse("https://shapeshift.io/#{method}"), args)
      JSON.parse(r.body)
    end

  end
end