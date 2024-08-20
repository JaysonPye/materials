# frozen_string_literal: true

require 'rails_helper'
require 'csv'

RSpec.describe 'creating a lesson from a CSV', :js do
  let(:user) { create(:user, :admin) }
  let(:path) { 'tmp/lessons.csv' }

  before do
    sign_in user
    create_lesson_csv
  end

  after do
    File.delete(path)
  end

  it 'can parse lessons from a CSV' do
    visit new_lesson_upload_path
    within '#lesson_create_form' do
      attach_file 'lesson_upload_file', Rails.root.join(path)
      click_button I18n.t('lesson_uploads.new.create_lessons')
    end
    expect(page).to have_css('.error', count: 1)
    expect(page).to have_css('.uploaded', count: Lesson::TYPES.size)
    expect(Lesson.count).to eq(Lesson::TYPES.size)
    within 'tr.error' do
      fill_in 'lesson_upload[title]', with: 'Test Title'
      click_button 'Create Lesson'
    end
    expect(page).to have_css('.uploaded', count: Lesson::TYPES.size + 1)
    expect(Lesson.count).to eq(Lesson::TYPES.size + 1)
  end
end

def create_lesson_csv
  lessons = create_lessons
  CSV.open(path, 'w') do |csv|
    csv << Lesson::CSV_HEADERS
    lessons.each do |lesson|
      csv << lesson
    end
  end
end

def create_lessons
  lessons = Lesson::TYPES.map do |type|
    type = type.underscore.to_sym
    build(type)
  end

  invalid_lesson = build(:daily_activity, title: nil)
  lessons << invalid_lesson
  lessons.map { |l| Lesson::CSV_HEADERS.map { |h| l.send(h.to_sym) } }
end
