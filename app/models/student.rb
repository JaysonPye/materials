# frozen_string_literal: true

class Student < ApplicationRecord
  include Levelable

  validates :level, :name, presence: true
  encrypts :name

  belongs_to :parent, optional: true
  belongs_to :school, counter_cache: true
  delegate :organisation_id, to: :school
  has_many :teachers, through: :school

  has_many :student_classes, dependent: :destroy
  accepts_nested_attributes_for :student_classes
  has_many :classes, through: :student_classes,
                     source: :school_class

  has_many :test_results, dependent: :destroy
  has_many :tests, through: :test_results
end
