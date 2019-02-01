require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    it 'populates array of all questions' do
      questions = create_list :question, 4
      get :index
      expect(assigns(:questions)).to match_array(questions)
    end
  end

  describe 'GET #new' do

  end

  describe 'POST #create' do

  end
end