require 'test_helper'

describe HorizonEvent::Delimited do
  before do
    @subject = HorizonEvent::Delimited
    @params = {
      key_value_pairing_class: @kv_class = MiniTest::Mock.new,
      request_class: @req_class = MiniTest::Mock.new,
      city: "Birmingham",
      state: "AL",
    }
    expected_hash = instance_eval(`cat test/sample_key_value_pairing.txt`)
    @kv_class.expect(:new, @kv_instance = MiniTest::Mock.new, [{ request_class: @req_class, state: @params[:state], city: @params[:city] }])
    @kv_instance.expect(:call, @result = MiniTest::Mock.new)
    @result.expect(:data, expected_hash)
  end

  describe "as a class" do
    it "initializes properly" do
      @subject.new(@params).must_respond_to :call
    end

    it "errors when initialized without required dependencies" do
      -> { @subject.new(@params.reject { |k| k.to_s == 'city' }) }.must_raise RuntimeError
      -> { @subject.new(@params.reject { |k| k.to_s == 'state' }) }.must_raise RuntimeError
    end
  end

  describe "as an instance" do
    it "executes successfully" do
      result = @subject.new(@params).call
      result.successful?.must_equal true
      result.must_be_kind_of PayDirt::Result
    end
  end
end
