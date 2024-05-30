module Minitest
  cattr_accessor :options

  # Zeitwerk fails if not defined
  module Minitest::XcodePlugin; end

  def self.plugin_xcode_options(opts, options)
    opts.on "--xcode", "Report results to Xcode" do
      options[:xcode] = true
    end
  end

  def self.plugin_xcode_init(options)
    reporter << XcodeReporter.new(options) if options[:xcode]
  end

  class XcodeReporter < Reporter
    attr_accessor :results

    def initialize(options)
      super
      self.results = []
    end

    def cwd
      @cwd ||= "#{Dir.pwd}/"
    end

    def record(test)
      return unless test.error? || test.failure

      results << test
    end

    # rubocop:disable Rails/Output
    def report
      results.each do |result|
        rfailure = result.failure.to_s.split("\n").join(", ").delete(":").squeeze(" ")
        print "\n#{result.failure.location.gsub(cwd, '')}: warning: #{rfailure}"
      end
    end
    # rubocop: enable Rails/Output
  end
end
