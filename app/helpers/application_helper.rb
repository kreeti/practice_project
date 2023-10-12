module ApplicationHelper
  include Pagy::Frontend

  def flash_class(level)
    case level.to_sym
    when :notice then "alert alert-info"
    when :success then "alert alert-success"
    when :error then "alert alert-danger"
    when :alert then "alert alert-warning"
    end
  end

  def timespan_in_words(time_interval, from_date, to_date)
    if time_interval == Transaction::YEARLY
      Date.parse(from_date.to_s).strftime("%Y") + "-" + Date.parse(to_date.to_s).strftime("%Y")
    elsif time_interval == Transaction::QUARTERLY
      (from_date..to_date).map { |d| d.strftime("%B") }.uniq.join(", ")
    else
      Date.parse(from_date.to_s).strftime("%B")
    end
  end

  def link_to_add_row(name, form, association, **args)
    new_object = form.object.send(association).klass.new
    id = new_object.object_id
    fields = form.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize, form: builder)
    end

    html_class = args[:class].nil? ? "" : args[:class]
    link_to(name, "#", class: "add_fields #{html_class}", data: { id: id, fields: fields.gsub("\n", "") })
  end

  def month_select_tag(tag_name = :month)
    selected = params[:month] || nil
    unless selected
      return select_tag tag_name,
                        options_for_select(month_options.unshift("select"),
                                           selected: "select", disabled: "select")
    end

    select_tag tag_name,
               options_for_select(month_options.unshift("select"),
                                  selected: month_options[selected.to_i], disabled: "select")
  end

  def year_select_tag(tag_name = :year)
    selected = params[:year] || Time.zone.today.year
    select_tag tag_name, options_for_select(year_options, selected: selected.to_i)
  end

  def month_options
    @month_options ||= Date::MONTHNAMES.compact.collect { |name| [name, Date::MONTHNAMES.index(name)] }
  end

  def year_options
    @year_options ||= (2005..Time.zone.today.year).to_a
  end
end
