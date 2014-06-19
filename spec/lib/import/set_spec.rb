require 'spec_helper'

describe Import::Set do
  describe ".coerce_name" do
    it "removes Magic: The Gathering from set names" do
      expect(Import::Set.coerce_name("Magic: The Gathering—Conspiracy")).
        to eq("Conspiracy")
      expect(Import::Set.coerce_name("Magic: The Gathering-Commander")).
        to eq("Commander")
    end
  end
end

