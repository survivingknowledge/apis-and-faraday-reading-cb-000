class SearchesController < ApplicationController
  def search
  end

  def foursquare
    begin
      #if this fails you get Faraday::ConnectionFailure error
      @resp = Faraday.get 'https://api.foursquare.com/v2/venues/search' do |req|
        req.params['client_id'] = '0OZTEJSMF5ERPBBUVEJSKS0JU1IGIBGQBL31TDJ0SOE4TBY2'
        req.params['client_secret'] = 'ZLWA3DW1JWMTQLQDXKRQTMZCA1OE3UNREKS3EDLR2U5TD4HP'
        req.params['v'] = '20160201'
        req.params['near'] = params[:zipcode]
        req.params['query'] = 'coffee shop'
      end

      body_hash = JSON.parse(@resp.body)
      if @resp.success?
        @venues = body_hash['response']['venues']
      else
        @error = body_hash['meta']['errorDetail']
      end
      render 'search'
    end
  rescue Faraday::TimeoutError
    @error = "There was a timeout. Please try again."
  end
end
