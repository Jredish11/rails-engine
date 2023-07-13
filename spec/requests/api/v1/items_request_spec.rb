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
        expect(item[:id].to_i).to be_an(Integer)
        
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
        merchant = create(:merchant)
        item_id = create(:item, merchant_id: merchant.id)
        
        get "/api/v1/items/#{item_id.id}"

        expect(response).to be_successful
        
        item = JSON.parse(response.body, symbolize_names: true)

        expect(item).to have_key(:data)
        expect(item[:data]).to be_a(Hash)

        expect(item[:data]).to have_key(:id)
        expect(item[:data][:id].to_i).to be_a(Integer)

        expect(item[:data]).to have_key(:type)
        expect(item[:data][:type]).to be_a(String)
        
        expect(item[:data]).to have_key(:attributes)
        expect(item[:data][:attributes]).to be_a(Hash)

        expect(item[:data][:attributes]).to have_key(:name)
        expect(item[:data][:attributes][:name]).to be_a(String)
        
        expect(item[:data][:attributes]).to have_key(:description)
        expect(item[:data][:attributes][:description]).to be_a(String)


        expect(item[:data][:attributes]).to have_key(:unit_price)
        expect(item[:data][:attributes][:unit_price]).to be_a(Float)


        expect(item[:data][:attributes]).to have_key(:merchant_id)
        expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)
        expect(item[:data][:attributes][:merchant_id]).to eq(merchant.id)
      end
    end

    describe "POST /api/v1/items" do
      it "can create a new item" do
        merchant = create(:merchant)
        item_params = { name: "burger", 
                        description: "juicy", 
                        unit_price: 12.34, 
                        merchant_id: merchant.id 
                      }
                      headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
        
        created_item = Item.last
        
        expect(response).to be_successful
        expect(created_item.name).to eq(item_params[:name])
        expect(created_item.description).to eq(item_params[:description])
        expect(created_item.unit_price).to eq(item_params[:unit_price])
        expect(created_item.merchant_id).to eq(item_params[:merchant_id])
      end
    end

    describe "PATCH /api/v1/items/{{item_id}}" do
      it "can update an existing item" do
        merchant = create(:merchant)
        item_id = create(:item, merchant_id: merchant.id).id

        last_name = Item.last.name

        item_params = { name: "burger", 
                        description: "juicy", 
                        unit_price: 12.34, 
                        merchant_id: merchant.id 
                      }
        headers = {"CONTENT_TYPE" => "application/json"}

        patch "/api/v1/items/#{item_id}", headers: headers, params: JSON.generate({item: item_params})
        item = Item.find_by(id: item_id)

        expect(response).to be_successful
        expect(item.name).to_not eq(last_name)
        expect(item.name).to eq("burger")
      end

      xit "returns 404 error if item is not found" do
        merchant = create(:merchant)
        item = create(:item, merchant_id: merchant.id)
        require 'pry'; binding.pry
        item_id = 12345

        patch "/api/v1/items/#{item_id}"

        expect { Item.find(item_id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe "DELETE /api/v1/items" do
      it "can delete an item that exists" do
        merchant = create(:merchant)
        item_params = ({
          name: 'Jimmy',
          description: 'sandwich',
          unit_price: 314.12,
          merchant_id: merchant.id
          })
          headers = {"CONTENT_TYPE" => "application/json"}
          
          post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

        
        expect(Item.all.count).to eq(1)
        
        item_id = Item.last.id
        
        delete "/api/v1/items/#{item_id}"

        expect(response).to be_successful
        expect(Item.all.count).to eq(0)
        expect{Item.find(item_id)}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end