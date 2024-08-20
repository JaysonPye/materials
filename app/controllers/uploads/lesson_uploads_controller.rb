# frozen_string_literal: true

class LessonUploadsController < ApplicationController
  include SampleCsvable

  def new
    authorize nil, policy_class: LessonUploadPolicy
  end
end
