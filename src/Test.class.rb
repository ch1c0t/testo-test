require 'timeout'

class << self
  attr_accessor :timeout
end

def initialize &block
  @block = block
end

attr_reader :it
def [] it
  reader, writer = IO.pipe

  pid = fork do
    reader.close

    message = {}

    begin
      run it
    rescue Exception
      message[:error] = $!
    ensure
      writer.write Marshal.dump message
      writer.close
    end
  end
  writer.close

  message = {
    it: it,
    pid: pid,
  }
  
  if timeout = self.class.timeout
    begin
      child_message = Timeout.timeout timeout do
        Marshal.load reader.read
      end
    rescue Timeout::Error
      Process.kill :KILL, pid
      message[:error] = $!
    end
  else
    child_message = Marshal.load reader.read
  end
  reader.close

  message.merge! child_message if child_message
  Report.new self, message
end

def run it
  @it = it
  raise FailedAssertion unless instance_exec &@block
end

# Currently, this method is expected to be run from a Pry session only.
def debug it
  PryByebug::BreakCommand.new.send :add_breakpoint, "Testo::Test#run", nil
  # How to "next next step" automatically when the breakpoint is hit?

  begin
    run it
    raise "Cannot reproduce. It might be a heisebug."
  rescue
    $!
  end
end

class FailedAssertion < StandardError
end
