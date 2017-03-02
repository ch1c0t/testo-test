require 'forwardable'

attr_reader :test, :message
def initialize test, message
  @test, @message = test, message
end

def ok?
  message[:ok]
end

extend Forwardable
def_delegator :test, :debug
