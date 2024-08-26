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
    params.require(:lesson_upload).permit(Lesson::CSV_HEADERS.map(&:to_sym))
  end

  def set_errors
    @errors = @lesson.errors.full_messages.to_sentence
    @status = 'Error'
  end
end
