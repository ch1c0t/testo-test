attr_reader :test, :error, :it
def initialize message
  @test, @error, @it = message.values_at :test, :error, :it
end

def ok?
  not error
end

def debug
  test.debug it
end
