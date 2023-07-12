require 'rails_helper'

RSpec.describe "Items API" do
  describe "GET /api/v1/items" do
    it "sends a list of all items" do
      merchant = create(:merchant)
      create_list(:item, 20, merchant_id: merchant.id)

      
      get api_v1_items_path
      
      expect(response).to be_successful
      
      items = JSON.parse(response.body, symbolize_names: true)
      expect(items[:data].count).to eq(20)

      items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(String)
        
        expect(item).to have_key(:type)
        expect(item[:type]).to be_an(String)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)
        
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to eq(merchant.id)
      end
    end

    describe "GET /api/v1/items/{{item_id}}" do
      it "can get one item by its id" do

      end
    end
  end
end
