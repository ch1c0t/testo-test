require 'forwardable'

attr_reader :test, :message, :error
def initialize test, message
  @test, @message = test, message
  @error = message[:error]
end

def ok?
  message[:ok]
end

extend Forwardable
def_delegator :test, :debug
