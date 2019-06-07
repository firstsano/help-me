require_relative '../features_helper'

feature 'User can subscribe to a question', %q{
  In order to get notifications about new answers to the question
  As an authenticated user
  I want to be able to subscribe to a question
} do

  login_user
  let!(:question) { create :question }

  scenario 'User subscribes to a question', js: true do
    visit question_path(question)
    find('.question__subscription').click

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Subscribed'
    expect(page).to have_content 'Unsubscribe'
  end
end


feature 'User can unsubscribe from a question', %q{
  In order to stop getting notifications about new answers to the question
  As an authenticated user
  I want to be able to unsubscribe from a question
} do

  login_user
  let!(:question) { create :question }

  background { user.subscribe question }

  scenario 'User unsubscribes from a question', js: true do
    visit question_path(question)
    click_on 'Unsubscribe'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Unsubscribed'
    expect(page).to have_content 'Subscribe'
  end
end
