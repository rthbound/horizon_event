require 'test_helper'

describe HorizonEvent::Request do
  before do
    @subject = HorizonEvent::Request
  end

  describe "as a class" do
    it "initializes properly" do
      @subject.new.must_respond_to :call
    end
  end

  describe "as an instance" do
    it "executes successfully" do
      result = @subject.new.call
      result.successful?.must_equal true
      result.must_be_kind_of PayDirt::Result
    end
  end
end
