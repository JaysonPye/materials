# frozen_string_literal: true

class LessonUploadsController < ApplicationController
  include SampleCsvable

  after_action :verify_authorized, only: %i[create new update]

  def show
    authorize nil, policy_class: LessonUploadPolicy
    send_data sample_csv(Lesson::CSV_HEADERS),
              filename: 'sample_lessons_upload.csv'
  end

  def new
    authorize nil, policy_class: LessonUploadPolicy
  end

  def create
    @lesson = authorize Lesson.new(lesson_upload_params)
    @types = Lesson::TYPES
    @index = params[:index].to_i
    @status = 'Uploaded'
    return if @lesson.save

    set_errors
  end

  def update
    @lesson = authorize Lesson.find_by(id: lesson_upload_params[:id])
    @index = params[:index].to_i
    @status = 'Uploaded'
    return if @lesson.update(lesson_upload_params)

    set_errors
  end

  private

  def lesson_upload_params
    lesson_params = params.require(:lesson_upload).permit(Lesson::CSV_HEADERS.map(&:to_sym))

    # Manually handle non-strings
    %i[admin_approval curriculum_approval lang_goals].each do |field|
      lesson_params[field] = begin
        JSON.parse(params[:lesson_upload][field])
      rescue StandardError
        default_value_for(field)
      end
    end

    # Remove the id for create action
    lesson_params.delete(:id) if action_name == 'create'

    lesson_params
  end

  # Helper to provide default values for non-string fields
  def default_value_for(field)
    case field
    when :admin_approval, :curriculum_approval
      []
    when :lang_goals
      {}
    end
  end

  def set_errors
    @errors = @lesson.errors.full_messages.to_sentence
    Rails.logger.error "Lesson upload error: #{@errors}"
    @status = 'Error'
  end
end
