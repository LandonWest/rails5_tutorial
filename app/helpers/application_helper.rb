module ApplicationHelper
  # Reutrns full title on a per-page basis
  def full_title(page_titile = '')
    base_title = 'Ruby on Rails Tutorial Sample App'
    if page_titile.empty?
      base_title
    else
      page_titile + ' | ' + base_title
    end
  end
end
