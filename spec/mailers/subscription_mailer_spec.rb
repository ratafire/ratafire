require "spec_helper"

describe SubscriptionMailer do
  describe "transaction_confirmation" do
    let(:mail) { SubscriptionMailer.transaction_confirmation }

    it "renders the headers" do
      mail.subject.should eq("Transaction confirmation")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
