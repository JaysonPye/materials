# frozen_string_literal: true

module LessonCalendarHelper
  def calendar_date(date, course_lesson)
    # date is always a Monday to be start of week
    # so need to get the date offset by 2 from cl day
    date + (CourseLesson.days[course_lesson.day] - 2).days
  end

  def calendar_lesson_title(lesson)
    case lesson.type
    when 'DailyActivity', 'Exercise'
      lesson.subtype.titleize
    when 'KindyPhonic', 'EnglishClass'
      lesson.topic.gsub(/Term \d+/, '')
    else
      lesson.title
    end
  end

  def day_column(day)
    col = { 'sunday' => 'col-start-2', 'monday' => 'col-start-3',
            'tuesday' => 'col-start-4', 'wednesday' => 'col-start-5',
            'thursday' => 'col-start-6', 'friday' => 'col-start-7',
            'saturday' => 'col-start-8' }[day]

    %w[monday wednesday friday].include?(day) ? "#{col} bg-neutral-dark" : col
  end

  def lesson_row(lesson)
    type = case lesson.type
           when 'KindyPhonic'
             'PhonicsClass'
           else
             lesson.type
           end

    level = if lesson.short_level == 'Specialist'
              lesson.level
            else
              lesson.short_level
            end

    { 'DailyActivity' =>
        { 'Kindy' => 'row-start-3', 'Elementary' => 'row-start-5' },
      'Exercise' =>
        { 'Kindy' => 'row-start-3', 'Elementary' => 'row-start-4' },
      'PhonicsClass' =>
        { 'Kindy' => 'row-start-7', 'Land' => 'row-start-8',
          'Sky' => 'row-start-9', 'Galaxy' => 'row-start-10' },
      'EnglishClass' =>
        { 'Kindy' => 'row-start-12', 'Land' => 'row-start-13',
          'Sky' => 'row-start-[14]', 'Galaxy' => 'row-start-[15]' },
      'StandShowSpeak' =>
        { 'Land' => 'row-start-[17]', 'Sky' => 'row-start-[18]',
          'Galaxy' => 'row-start-[19]' },
      'EveningClass' =>
        { 'Keep Up' => 'row-start-[21]',
          'specialist' => 'row-start-[22]',
          'specialist_advanced' => 'row-start-[23]' } }[type][level]
  end

  def lesson_type_rows
    { 'DailyActivity' => 'row-start-3 row-span-3',
      'PhonicsClass' => 'row-start-7 row-span-4',
      'EnglishClass' => 'row-start-12 row-span-4',
      'StandShowSpeak' => 'row-start-[17] row-span-3',
      'EveningClass' => 'row-start-[21] row-span-3' }
  end

  def calendar_level_dots(level)
    base_dot_classes = 'absolute rounded-full w-3 h-3 top-2'
    return all_levels_dot(base_dot_classes) if ['All Levels', 'Elementary'].include?(level)

    content_tag(:div, '',
                class: "#{base_dot_classes} right-2 #{calendar_dot_bg(level)}")
  end

  def calendar_dot_bg(level)
    { 'Kindy' => 'bg-kindy', 'Land' => 'bg-land', 'Sky' => 'bg-sky',
      'Galaxy' => 'bg-galaxy', 'Keep Up' => 'bg-keep-up',
      'Specialist' => 'bg-specialist' }[level]
  end

  def all_levels_dot(base_classes)
    content_tag(:div, '', class: "#{base_classes} right-2 bg-land") +
      content_tag(:div, '', class: "#{base_classes} right-4 bg-sky") +
      content_tag(:div, '', class: "#{base_classes} right-6 bg-galaxy")
  end
end
