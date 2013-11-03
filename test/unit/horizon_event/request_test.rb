require 'test_helper'

describe HorizonEvent::Request do
  before do
    @subject = HorizonEvent::Request
    @params = {
      http_headers: MiniTest::Mock.new,
      FFX: MiniTest::Mock.new,
      xxy: MiniTest::Mock.new,
      type: MiniTest::Mock.new,
      st: MiniTest::Mock.new,
      place: MiniTest::Mock.new,
      ZZZ: MiniTest::Mock.new,
      host: MiniTest::Mock.new,
      url: MiniTest::Mock.new,
    }
  end

  describe "as a class" do
    it "initializes properly" do
      @subject.new(@params).must_respond_to :call
    end

    it "errors when initialized without required dependencies" do
      -> { @subject.new(@params.reject { |k| k.to_s == 'http_headers' }) }.must_raise RuntimeError
      -> { @subject.new(@params.reject { |k| k.to_s == 'FFX' }) }.must_raise RuntimeError
      -> { @subject.new(@params.reject { |k| k.to_s == 'xxy' }) }.must_raise RuntimeError
      -> { @subject.new(@params.reject { |k| k.to_s == 'type' }) }.must_raise RuntimeError
      -> { @subject.new(@params.reject { |k| k.to_s == 'st' }) }.must_raise RuntimeError
      -> { @subject.new(@params.reject { |k| k.to_s == 'place' }) }.must_raise RuntimeError
      -> { @subject.new(@params.reject { |k| k.to_s == 'ZZZ' }) }.must_raise RuntimeError
      -> { @subject.new(@params.reject { |k| k.to_s == 'host' }) }.must_raise RuntimeError
      -> { @subject.new(@params.reject { |k| k.to_s == 'url' }) }.must_raise RuntimeError
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