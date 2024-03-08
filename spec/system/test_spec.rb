# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'creating a test' do
  let(:user) { create(:user, :admin) }

  before do
    create(:course, title: 'Test Course')
    sign_in user
  end

  it 'can create a test linking organisation & course as sales' do
    visit tests_path
    click_link I18n.t('tests.index.create_test')
    within '#test_form' do
      fill_in 'test_name', with: 'Test test'
      select 'Test Course', from: 'test_course_level'
      fill_in 'test_questions',
              with: "Writing: 1, 6, 3, 4\nReading: 1, 2, 3, 4 \nListening: 1, 6, 3, 4 \nSpeaking: 1, 2, 3, 4"
      fill_in 'test_thresholds',
              with: "Sky One:60\nSky Two:70\nSky Three:80"
    end
    click_button '登録する'
    expect(page).to have_content('Test test')
    expect(page).to have_content('Question 1: 1 point', count: 4)
    expect(page).to have_content('Question 2: 2 points', count: 2)
    expect(page).to have_content('Question 2: 6 points', count: 2)
    expect(page).to have_content('Sky One: 60%')
  end
end
