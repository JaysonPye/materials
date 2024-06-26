# frozen_string_literal: true

class StudentsController < ApplicationController
  before_action :set_student, only: %i[show edit update destroy]
  before_action :set_schools, only: %i[edit new show]
  before_action :set_classes, only: %i[edit new show]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    @students = policy_scope(Student).includes(:school).order(updated_at: :desc).limit(10)
    @schools = policy_scope(School).pluck(:name, :id)
  end

  def show
    @classes = @student.classes
    @teachers = @student.teachers
    @potential_classes =
      @student.school
              .classes
              .where.not(id: @classes.ids)
              .pluck(:name, :id)
    @orgs = policy_scope(Organisation)
    set_results
  end

  def new
    @student = authorize Student.new
    @student.school_id = params[:school_id] if params[:school_id]
    build_classes
  end

  def edit
    build_classes
  end

  def create
    @student = authorize Student.new(student_params)

    if @student.save
      redirect_to @student, notice: t('create_success')
    else
      build_classes
      set_schools
      set_classes
      render :new,
             status: :unprocessable_entity,
             alert: t('create_failure')
    end
  end

  def update
    if @student.update(student_params)
      redirect_to @student, notice: t('update_success')
    else
      build_classes
      set_schools
      set_classes
      render :edit,
             status: :unprocessable_entity,
             alert: t('update_failure')
    end
  end

  def destroy
    if @student.destroy
      redirect_to students_url,
                  notice: t('destroy_success')
    else
      redirect_to students_url,
                  alert: t('destroy_failure')
    end
  end

  private

  def student_params
    params.require(:student).permit(
      :comments, :level, :name, :school_id, :student_id, :parent_id,
      :en_name, :birthday, :start_date, :end_date,
      student_classes_attributes: %i[id class_id _destroy]
    )
  end

  def set_results
    @results = @student.test_results.order(created_at: :desc).includes(:test)
    @results = @results.where(test_id: params[:test_id]) if params[:test_id]
    @data = radar_data
  end

  def radar_data
    radar_colors = ['105, 192, 221', '100, 88, 128', '170, 218, 235', '178, 170, 191'].cycle

    {
      labels: %w[Reading Writing Listening Speaking],
      datasets: @results.map do |result|
        radar_data = result.radar_data
        color = radar_colors.next
        {
          data: radar_data[:data],
          label: radar_data[:label],
          backgroundColor: "rgba(#{color}, 0.2)",
          pointBackgroundColor: "rgb(#{color})",
          pointBorderColor: '#fff',
          pointHoverBackgroundColor: '#fff',
          pointHoverBorderColor: "rgb(#{color})"
        }
      end
    }
  end

  def set_student
    @student = authorize Student.find(params[:id])
  end

  def set_schools
    @schools = policy_scope(School).pluck(:name, :id)
  end

  def set_classes
    @classes = policy_scope(SchoolClass).pluck(:name, :id)
  end

  def build_classes
    @student.student_classes.build(class_id: params[:class_id]) if params[:class_id]
  end
end
