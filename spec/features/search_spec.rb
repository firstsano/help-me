require_relative 'features_helper'

feature 'User can find question/answer/comment/user by using search field', %q{
  In order to find required entity by text
  As an authenticated user
  I want to be able to use the search field
} do

  context 'When user is signed in', js: true, with_sphinx: true do
    login_user

    background do
      create_list :question, 10
      create_list :answer, 10
      create_list :question_comment, 10
      create_list :user, 10
    end

    given!(:required_questions) do
      questions = create_list :question, 5, body: "Body with an apple"
      questions << create(:question, title: "Title with an apple")
      questions
    end

    given!(:required_answers) { create_list :answer, 5, body: "Answer with an apple" }
    given!(:required_comments) { create_list :question_comment, 5, body: "Comment with an apple" }
    given!(:required_users) { create_list :user, 5, name: "Name with an apple" }

    context 'When using common search field' do
      scenario 'User submits query and gets results of search' do
        sphinx_index

        visit root_path
        within('.global-search') do
          fill_in "search", with: "appl"
          click_on 'Search'
        end

        expect(current_path).to eq search_path

        required_questions.each do |question|
          expect(page).to have_link href: question_path(question)
          expect(page).to have_content question.title
          expect(page).to have_content question.body
        end

        required_answers.each do |answer|
          expect(page).to have_link href: question_path(answer.question)
          expect(page).to have_content answer.body
        end

        required_users.each do |user|
          expect(page).to have_content user.name
          expect(page).to have_content user.email
        end

        required_comments.each { |comment| expect(page).to have_content comment.body }

        matches = all('.match')
        total_objects = required_questions + required_answers +
          required_comments + required_users
        expect(matches.count).to eq total_objects.count
      end
    end

    context 'When using targeting search' do
      scenario 'User selects type of enitity, submits query and gets results' do
        sphinx_index

        visit root_path
        within('.global-search') do
          fill_in "search", with: "appl"
          within('.global-search__category') { find("option[value='question']").click }
          click_on 'Search'
        end

        expect(current_path).to eq search_path
      end
    end
  end

  context 'When user is not signed in' do
    scenario 'User cannot see search field' do
      visit root_path
      expect(page).not_to have_selector '.global-search'
    end
  end
end
