module ApplicationHelper
  def url_without_locale_params(url)
    uri = URI url
    params = Rack::Utils.parse_query uri.query
    params.delete 'locale'
    uri.query = params.to_param.blank? ? nil : params.to_param
    uri.to_s
  end

  def strip_query(url)
    url[/[^?]+/]
  end
end
