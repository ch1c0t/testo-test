require 'securerandom'

require 'tra/run'
pattern = -> message do
  message.is_a?(Hash) &&
    [:pid, :uuid].all? { |key| message.key? key }
end
Tra.on pattern do |message|
  Report[message[:uuid]] = message
end

def initialize &block
  @block = block
end

attr_reader :it
def [] it
  uuid = SecureRandom.uuid

  pid = fork do
    @it = it

    message = {
      pid: $$,
      uuid: uuid
    }

    begin
      raise FailedAssertion unless instance_exec &@block
      message[:ok] = true
    rescue Exception
      message[:exception] = $!
      message[:ok] = false
    ensure
      Process.ppid.put message
    end
  end

  hash = { test: self, uuid: uuid, pid: pid }
  Report.new hash
end

def debug
  require 'pry'
  @block.binding.pry
end

class FailedAssertion < StandardError
end
