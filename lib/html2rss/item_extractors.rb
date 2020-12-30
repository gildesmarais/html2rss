# frozen_string_literal: true

module Html2rss
  ##
  # Provides a namespace for item extractors.
  module ItemExtractors
    DEFAULT = 'text'
    private_constant :DEFAULT

    ##
    # @param name [String]
    # @return [Class, nil] the extractor class
    def self.get_extractor(name)
      @get_extractor ||= Hash.new do |extractors, key|
        extractors[key] = Utils.class_from_name(key || DEFAULT, 'ItemExtractors')
      end

      @get_extractor[name]
    end

    ##
    # @param xml [Nokogiri::XML]
    # @param options [Hash<Symbol, Object>]
    # @return [Nokogiri::XML::Element]
    def self.element(xml, options)
      selector = options[:selector]
      selector ? xml.css(selector) : xml
    end
  end
end
