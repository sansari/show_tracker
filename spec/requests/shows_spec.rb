require 'spec_helper'

describe "Shows" do
  describe "#index" do
    it "should list the shows" do
      visit shows_path

      click_link("New Show")

      page.should have_content("New show")
    end
  end
end
