module ApplicationHelper
  def nice_datetime(date)
    date.strftime('%c')
  end
end
