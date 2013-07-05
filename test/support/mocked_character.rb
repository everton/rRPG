class MockedCharacter < MiniTest::Mock
  attr_accessor :x, :y

  alias send __send__

  # See about 'as_null_object' pattern at wikipedia:
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
