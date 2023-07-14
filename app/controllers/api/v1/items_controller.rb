class Api::V1::ItemsController < ApplicationController
  def index
    render(json: ItemSerializer.new(Item.all))
  end

  def show
    render(json: ItemSerializer.new(Item.find(params[:id])))
  end

  def create
    item = Item.create(item_params)
    if item.save
      render(json: ItemSerializer.new(item), status: :created)
    else
      render json: JSON.generate({error: 'error'}), status: 400
    end
  end

  def update
    item = Item.update(params[:id], item_params)
    if item.save
      render(json: ItemSerializer.new(Item.update(params[:id], item_params)))
    else
      render json: JSON.generate({error: 'error'}), status: 400
    end 
  end

  def destroy
    item = Item.find(params[:id])
    item.delete
    if item.destroy
      render(status: :created)
    end
  end

  def find
  items = Item.where("name ILIKE ?", "%#{params[:name]}%")
    if items.present?
      render(json: ItemSerializer.new(items.first))
    else
      render(json: { data: {} })
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end