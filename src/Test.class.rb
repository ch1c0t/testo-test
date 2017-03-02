def initialize &block
  @block = block
end

attr_reader :it
def [] it
  reader, writer = IO.pipe

  pid = fork do
    reader.close

    message = {
      pid: $$,
    }

    begin
      run it
      message[:ok] = true
    rescue Exception
      message[:exception] = $!
      message[:ok] = false
    ensure
      writer.write Marshal.dump message
      writer.close
    end
  end
  writer.close

  message = Marshal.load reader.read
  reader.close

  Report.new self, message
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
