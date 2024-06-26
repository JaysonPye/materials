# frozen_string_literal: true

class Lesson < ApplicationRecord
  include Approvable, Levelable, Pdfable, Proposable

  TYPES = %w[DailyActivity
             EnglishClass
             Exercise
             KindyPhonic
             PhonicsClass
             SpecialLesson
             StandShowSpeak].freeze

  before_destroy :check_not_used

  validates :goal, :level, :title, :type, presence: true
  validates :type, inclusion: { in: TYPES }

  belongs_to :assigned_editor,
             class_name: 'User',
             optional: true
  belongs_to :creator,
             class_name: 'User',
             optional: true

  has_many :course_lessons, dependent: :destroy
  accepts_nested_attributes_for :course_lessons,
                                reject_if: :all_blank,
                                allow_destroy: true
  has_many :courses, through: :course_lessons

  has_many_attached :resources

  scope :unlevelled, -> { where(type: %w[DailyActivity Exercise SpecialLesson]) }
  scope :levelled, -> { where(type: %w[EnglishClass KindyPhonic PhonicsClass StandShowSpeak]) }

  def self.reassign_editor(old_editor_id, new_editor_id)
    Lesson.where(assigned_editor_id: old_editor_id)
          .update(assigned_editor_id: new_editor_id)
  end

  def self.policy_class
    LessonPolicy
  end

  def day(course)
    course_lessons.find_by(course_id: course.id).day.capitalize
  end

  def replace(lesson)
    lesson.course_lessons.each do |cl|
      course_lessons << cl
    end
    lesson.proposals.each do |p|
      next if p.id == id

      proposals << p
    end
    update(status: :accepted, creator_id: lesson.creator_id,
           admin_approval: lesson.admin_approval,
           curriculum_approval: lesson.curriculum_approval)
  rescue StandardError
    false
  else
    lesson.destroy
    true
  end

  def week(course)
    number = course_lessons.find_by(course_id: course.id).week
    "Week #{number}"
  end

  private

  def check_not_used
    return true if course_lessons.reload.empty?

    errors.add(:course_lessons,
               :invalid,
               message: 'Cannot delete lesson if it is used in a course')
  end
end
