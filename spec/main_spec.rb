require 'helper'

describe Test do
  it do
    test = Test.new { it == 42 }
    passing = test[42]
    failing = test[43]

    sleep 0.01 while (passing.status == :pending) || (failing.status == :pending)

    expect(passing.ok?).to eq true
    expect(passing.status).to eq :passed
    expect(failing.status).to eq :failed
    expect(failing.message[:exception]).to be_a Testo::Test::FailedAssertion
  end
end
