module Html2rss
  module AttributePostProcessors
    class ParseTime
      def initialize(value, _options, _item)
        @value = value
      end

      def get
        Time.parse(@value).rfc822.to_s
      end
    end
  end
end
