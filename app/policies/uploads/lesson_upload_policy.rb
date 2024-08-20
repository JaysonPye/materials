# frozen_string_literal: true

class LessonUploadPolicy < ApplicationPolicy
  def index?
    false
  end

  def show?
    user.is?('Admin')
  end

  def new?
    user.is?('Admin')
  end

  def edit?
    false
  end

  def update?
    false
  end

  def create?
    false
  end

  def destroy?
    false
  end
end
