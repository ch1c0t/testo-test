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
    message = {
      pid: $$,
      uuid: uuid
    }

    begin
      run it
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

def run it
  @it = it
  raise FailedAssertion unless instance_exec &@block
end

def debug it
  require 'pry'
  binding.pry
  run it
end

class FailedAssertion < StandardError
end
