# frozen_string_literal: true

module Html2rss
  ##
  # Provides a namespace for item extractors.
  module ItemExtractors
    ##
    # The Error class to be thrown when an unknown (= absent in NAME_TO_CLASS
    # mapping) extractor is requested.
    class UnknownExtractorName < StandardError; end

    ##
    # Maps the extractor name to the class implementing the extractor.
    #
    # The key is the name to use in the feed config.
    NAME_TO_CLASS = {
      attribute: Attribute,
      href: Href,
      html: Html,
      static: Static,
      text: Text
    }.freeze

    DEFAULT_NAME = :text

    ##
    # @param xml [Nokogiri::XML]
    # @param selector [String, nil]
    # @return [Nokogiri::XML::Element]
    def self.element(xml, selector)
      selector ? xml.css(selector) : xml
    end

    ##
    # Creates an instance of the requested extractor.
    #
    #
    # @param attribute_options [Hash<Symbol, Object>]
    #   Should at least contain `:extractor` (the name), plus the required options by that extractor.
    # @param xml [Nokogiri::XML]
    # @return [ItemExtractors::*]
    def self.item_extractor_factory(attribute_options, xml)
      name = attribute_options[:extractor]&.to_sym || DEFAULT_NAME
      extractor = NAME_TO_CLASS[name]

      raise UnknownExtractorName, "Can't find an extractor named '#{name}' in NAME_TO_CLASS" unless extractor

      extractor.new(
        xml,
        options_class(name).new(attribute_options.slice(*extractor::REQUIRED_OPTIONS))
      )
    end

    ITEM_OPTION_CLASSES = Hash.new do |hash, klass|
      hash[klass] = Struct.new("#{klass.to_s.split('::').last}Options", *klass::REQUIRED_OPTIONS, keyword_init: true)
    end

    ##
    # The `extractor_class`
    #
    # @param extractor_name [Symbol] Name of the extractor
    #   The extractor class must have a constant called REQUIRED_OPTIONS as array.
    # @return [ItemExtractors::*Options] The option class for the extractor.
    def self.options_class(extractor_name)
      ITEM_OPTION_CLASSES[NAME_TO_CLASS[extractor_name]]
    end
  end
end
