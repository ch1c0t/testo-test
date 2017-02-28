require_relative 'helper'

test = Test.new do
  a = 1
  b = 2
  co = a + b
  it < co
end

it = 42
report = test[it]
sleep 0.01 until report.status == :failed
report.debug it
