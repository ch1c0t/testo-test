attr_reader :test, :message, :error, :it
def initialize test, message
  @test, @message = test, message
  @error, @it = message[:error], message[:it]
end

def ok?
  not message[:error]
end

def debug
  test.debug it
end
