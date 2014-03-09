require 'spec_helper'

describe "Routing for MTG Sets" do
  it "routes /sets" do
    expect(get: "/sets").to route_to({
      controller: "mtg_sets",
      action: "index"
    })
  end
end
