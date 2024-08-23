# frozen_string_literal: true

FactoryBot.define do
  factory :form_template_text_area do
    input_type { 'text_area' }
    name { 'test_text_area' }
    position { 1 }
    input_attributes { {} }
  end
end