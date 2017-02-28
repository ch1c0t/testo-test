require 'forwardable'

class << self
  def messages
    @messages ||= {}
  end

  def []= uuid, message
    messages[uuid] = message
  end
end

attr_reader :test, :uuid, :pid
def initialize test:, uuid:, pid:
  @test, @uuid, @pid = test, uuid, pid
end

def status
  if message = self.class.messages[uuid]
    message[:ok] ? :passed : :failed
  else
    :pending
  end
end

def message
  self.class.messages[uuid]
end

def ok?
  status == :passed
end

extend Forwardable
def_delegator :test, :debug
