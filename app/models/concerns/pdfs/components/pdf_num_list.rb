# frozen_string_literal: true

module PdfNumList
  include PdfDefaults, PdfRoundedBorder

  def pdf_num_list(
    array:,
    dimensions:,
    pdf:,
    title:,
    coords: [0, pdf.cursor]
  )
    pdf.bounding_box(
      coords,
      height: dimensions[:height],
      width: dimensions[:width]
    ) do
      add_border(pdf, dimensions)
      add_title(pdf, title)
      create_list(array, dimensions, pdf)
    end
    pdf.move_down GAP
  end

  private

  def add_title(pdf, title)
    pdf.move_down PADDING
    pdf.text title, size: HEADING_SIZE, indent_paragraphs: PADDING
    pdf.move_down PADDING
  end

  def create_list(array, dimensions, pdf)
    pdf.text_box(
      array_to_list(array),
      at: [PADDING * 2,
           dimensions[:height] - HEADING_SIZE - (PADDING * 2)],
      height: dimensions[:height],
      width: dimensions[:width],
      overflow: :shrink_to_fit
    )
  end

  def array_to_list(array)
    array.map.with_index { |step, i| "#{i + 1}. #{step}" }
         .join("\n")
  end
end