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
end
 