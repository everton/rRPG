class MockedCharacter < MiniTest::Mock
  alias send __send__

  # It allows calls for unexpected methods, but did not interferr with
  # standard treatment for expected ones. This allow mock object to
  # act more or less 'as_null_object'
  # See more about this pattern at wikipedia:
  #   http://en.wikipedia.org/wiki/Null_object
  def ignore_unexpected_calls!
    return if @ignoring_unexpected_calls # do it once!

    @ignoring_unexpected_calls = true

    def self.method_missing(sym, *args)
      super if @expected_calls.has_key?(sym)
    end

    def self.respond_to?(sym)
      true
    end
  end
end
