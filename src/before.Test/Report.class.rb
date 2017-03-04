attr_reader :test, :error, :it
def initialize test, message
  @test = test
  @error, @it = message[:error], message[:it]
end

def ok?
  not error
end

def debug
  test.debug it
end
