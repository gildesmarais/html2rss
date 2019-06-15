module Html2rss
  module ItemExtractor
    TEXT = proc { |xml, options| xml.css(options['selector'])&.text&.strip }
    ATTRIBUTE = proc { |xml, options| xml.css(options['selector']).attr(options['attribute']).to_s }

    HREF = proc { |xml, options|
      href = xml.css(options['selector']).attr('href').to_s
      path, query = href.split('?')

      if href.start_with?('http')
        uri = URI(href)
      else
        uri = URI(options['channel']['url'])
        uri.path = path.to_s.start_with?('/') ? path : "/#{path}"
        uri.query = query
      end

      uri
    }

    HTML = proc { |xml, options| xml.css(options['selector']).to_s }
    STATIC = proc { |_xml, options| options['static'] }
    CURRENT_TIME = proc { |_xml, _options| Time.new }
  end
end
