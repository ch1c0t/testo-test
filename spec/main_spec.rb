require 'helper'

describe Test do
  it do
    test = Test.new { it == 42 }
    passing, failing = test[42], test[43]

    expect(passing.ok?).to eq true
    expect(failing.ok?).to eq false
    expect(failing.error).to be_a Testo::Test::FailedAssertion
  end

  it do
    test = Test.new do
      sleep 6
      true
    end

    report = test[:anything]

    expect(report.ok?).to eq false
    expect(report.error).to be_a Timeout::Error
  end
end
