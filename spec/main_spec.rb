require 'helper'

describe Test do
  it do
    test = Test.new { it == 42 }
    passing, failing = test[42], test[43]

    expect(passing.ok?).to eq true
    expect(failing.ok?).to eq false
    expect(failing.message[:exception]).to be_a Testo::Test::FailedAssertion
  end
end
