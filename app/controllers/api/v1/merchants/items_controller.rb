class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    render(json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items))
  end

  def show
    item = Item.find(params[:id])
    merchant = item.merchant

    render json: MerchantSerializer.new(merchant)
  end
end
