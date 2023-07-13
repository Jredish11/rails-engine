class Api::V1::MerchantsController < ApplicationController
  def index
    render(json: MerchantSerializer.new(Merchant.all)) 
  end

  def show
    render(json: MerchantSerializer.new(Merchant.find(params[:id])))  
  end

  def find_all
    merchants = Merchant.where("name ILIKE ?", "%#{params[:name]}%")
    render(json: MerchantSerializer.new(merchants))
  end
end