require 'method_source'
require 'forwardable'
require 'timeout'

TIMEOUT = 5

def initialize &block
  @block = block
end

extend Forwardable
def_delegator :@block, :source

attr_reader :it
def [] it = nil
  message = { test: self, it: it }.merge in_isolation {
    message = { pid: Process.pid }

    begin
      run it
    rescue Exception
      message[:error] = $!
    end

    message
  }
  
  Report.new message
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

private
  class FailedAssertion < StandardError
  end

  def run it
    @it = it
    raise FailedAssertion unless instance_exec &@block
  end

  # The timeout has to be enforced from the parent, because some code
  # may cause MRI to become unresponsive indefinetely.
  # https://github.com/mbj/mutant#the-crash--stuck-problem-mri
  def in_isolation &block
    reader, writer = IO.pipe

    pid = fork do
      reader.close
      writer.write Marshal.dump block.call
      writer.close
    end
    writer.close

    begin
      Timeout.timeout TIMEOUT do
        Marshal.load reader.read
      end
    rescue Timeout::Error
      Process.kill :KILL, pid
      { pid: pid, error: $! }
    end.tap { reader.close; Process.wait pid }
  end
