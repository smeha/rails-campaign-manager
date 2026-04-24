require "rails_helper"

RSpec.describe ClientTimeLookup do
  describe "#call" do
    let(:reader) do
      lambda do |_url|
        <<~JSON
          {"data":{"geo":{"timezone":"Europe/London","datetime":"2026-04-24 07:35:28"}}}
        JSON
      end
    end

    let(:lookup) { described_class.new(ip_address: "195.110.64.205", reader: reader) }

    it "parses the returned datetime in the reported timezone" do
      expect(lookup.call.iso8601).to eq("2026-04-24T07:35:28+01:00")
    end
  end
end
