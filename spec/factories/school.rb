# frozen_string_literal: true

FactoryBot.define do
  factory :school do
    organisation
    name { 'Test School' }
  end
end
