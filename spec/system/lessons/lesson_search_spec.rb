# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Lesson search', :js do
  let(:user) { create(:user, :writer) }
  let!(:result) do
    create(:daily_activity,
           title: 'Test Dicovery',
           level: :kindy,
           goal: 'Test Goal',
           subtype: :discovery,
           interesting_fact: 'Interesting!',
           creator_id: user.id,
           assigned_editor_id: user.id)
  end
  let!(:extra) { create(:exercise) }

  before do
    sign_in user
  end

  it 'can search lessons with partial matching' do
    visit lessons_path
    within '#lesson_search' do
      select 'Daily Activity', from: 'search_type'
      fill_in 'search_title', with: 'Disco'
      fill_in 'search_goal', with: 'st Go'
      select 'Discovery', from: 'search_subtype'
      select 'Kindy', from: 'search_level'
      check 'search_released'
      select user.name, from: 'search_creator_id'
      select user.name, from: 'search_assigned_editor_id'
      click_button I18n.t('lesson_searches.form.search')
    end
    expect(page).to have_content(result.title)
    expect(page).not_to have_content(extra.title)
  end
end