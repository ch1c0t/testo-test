require 'forwardable'

attr_reader :test, :message, :exception
def initialize test, message
  @test, @message = test, message
  @exception = message[:exception]
end

def ok?
  message[:ok]
end

extend Forwardable
def_delegator :test, :debug
