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

    report = test[]

    expect(report.ok?).to eq false
    expect(report.error).to be_a Timeout::Error
  end

  it do
    test = Test.new do
      it == 42
    end

    source = "    test = Test.new do\n      it == 42\n    end\n"

    expect(test.source).to eq source
  end
end
