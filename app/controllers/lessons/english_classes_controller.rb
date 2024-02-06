# frozen_string_literal: true

class EnglishClassesController < LessonsController
  def index
    @lessons = policy_scope(EnglishClass.all)
  end

  def create
    @lesson = authorize Lesson.new(english_class_params)

    if @lesson.save!
      redirect_to lesson_url(@lesson),
                  notice: "English class successfully created! #{GUIDE_DELAY}"
    else
      set_courses
      render 'lessons/new',
             status: :unprocessable_entity,
             alert: 'English class could not be created'
    end
  end

  def update
    if @lesson.update(english_class_params)
      redirect_to lesson_url(@lesson),
                  notice: "English class successfully updated. #{GUIDE_DELAY}"
    else
      set_courses
      render 'lessons/edit',
             status: :unprocessable_entity,
             alert: 'English class could not be updated'
    end
  end

  private

  def english_class_params
    ec_params = %i[example_sentences lesson_topic materials notes term title type unit vocab]
    params.require(:english_class).permit(lesson_params + ec_params)
  end
end