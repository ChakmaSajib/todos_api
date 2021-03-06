require 'rails_helper'
require 'rspec/rails'

RSpec.describe "Todos API", type: :request  do
  # initialize test data 
  let!(:todos) { create_list(:todo, 10) }
  let!(:todo_id) { todos.first.id }

  # Test suite for GET /todos
  describe 'GET /todos' do 
    # make HTTP get request beofre each example
    before { get '/todos' }

    it "returns status code 200"  do
      expect(response).to have_http_status(200)
    end 

    it "returns todos" do 
      # Note `json` is a custom helper to parse JSON responses 
      expect(json).not_to be_empty 
      expect(json.size).to eql(10)
    end
  end 

  # Test suite for GET /todos/:id
  describe 'GET /todos/:id' do 
    before { get "/todos/#{todo_id}" }

    context "when the record exists" do 
      it 'returns the todo' do 
        expect(json).not_to be_empty
        expect(json['id']).to eq(todo_id)
      end 
    end 


    it "return status code 200" do 
      expect(response).to have_http_status(200)
    end 

    context 'when the record does not exist' do
      let(:todo_id) { 100 }
    
      it "returns status code 404" do 
        expect(response).to have_http_status(404)
      end 

      it "returns a not found message" do 
        expect(response.body).to match(/Couldn't find Todo/)
      end 
    end 
  end 

  # Test suite for POST /todos 
  describe 'POST /todos' do 
    # valid payload
    let(:valid_attributes) { { title: 'Learn Ruby', created_by: '1' } }

    context 'when the request is valid' do 
      before { post '/todos', params: valid_attributes }

      it 'created a todo' do 
        expect(json['title']).to eq('learn Ruby')
      end 
      it 'returns status code 201' do 
        expect(response).to have_http_status(201)
      end 
    end

    context 'when the request is invalid' do 
      before { post '/todos', params: { title: 'Foobar' } }

      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end 

      it "returns a validation failure message" do 
        expect(response.body).to mactch(/Validation failed: Created by can't be blank/)
      end 
    end 
  end 

  # Test suite for PUT /todos/:id
  describe 'PUT /todos/:id' do 
    let(:valid_attributes) { { title: 'Shopping'} }
    
    context 'when the record exist' do 
      before { put "todos/#{todo_id}", params: valid_attributes }

      it "updates the record" do 
        expect(response.body).to be_empty
      end
      
      it "return status codde 204" do 
        expect(response).to have_http_status(204)
      end 
    end 
  end 

  # Test suite for DELETE /todos/:id
  describe 'DELETE /todos/:id' do 
    before { delete "/todos/#{todo_id}" }

    it "returns status code 204" do 
      expect(response).to have_http_status(204)
    end 
  end 
end
