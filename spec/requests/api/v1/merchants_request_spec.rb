require 'rails_helper'

RSpec.describe "Merchants API" do
  describe "GET /api/v1/merchants" do
    it "sends a list of all merchants" do
      create_list(:merchant, 20)

      get "/api/v1/merchants"

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(20)

      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_an(String)

        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to be_a(String)
        
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end
  end

  describe "GET /api/v1/merchants/{{merchant_id}}" do
    it "can get one merchant by its id" do
      merch_id = create(:merchant).id.to_s
      
      get "/api/v1/merchants/#{merch_id}"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)
      
      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to eq(merch_id)
      
      expect(merchant[:data]).to have_key(:type)
      expect(merchant[:data][:type]).to be_a(String)
      
      expect(merchant[:data]).to have_key(:attributes)
      expect(merchant[:data][:attributes]).to be_a(Hash)
      
      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
    end
  end
  
  describe "GET /api/v1/merchants/{{merchant_id}}/items" do
    it "can get all items for a given merchant ID" do
      merchant_1 = create(:merchant)
      create_list(:item, 4, merchant_id: merchant_1.id)
      
      get "/api/v1/merchants/#{merchant_1.id}/items"

      expect(response).to be_successful
      
      merchant_items = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_items[:data].count).to eq(4)


      merchant_items[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(String)
        
        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to be_a(String)
        
        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to be_a(Hash)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)

        expect(merchant[:attributes]).to have_key(:description)
        expect(merchant[:attributes][:description]).to be_a(String)
        
        expect(merchant[:attributes]).to have_key(:unit_price)
        expect(merchant[:attributes][:unit_price]).to be_a(Float)

        expect(merchant[:attributes]).to have_key(:merchant_id)
        expect(merchant[:attributes][:merchant_id]).to eq(merchant_1.id)
      end
    end
  end
end
 