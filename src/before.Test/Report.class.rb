require 'forwardable'

attr_reader :test, :message, :error
def initialize test, message
  @test, @message = test, message
  @error = message[:error]
end

def ok?
  not message[:error]
end

extend Forwardable
def_delegator :test, :debug
