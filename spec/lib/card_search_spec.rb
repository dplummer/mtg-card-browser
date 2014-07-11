require 'spec_helper'

describe CardSearch do
  def query(str)
    CardSearch.new(str).scope
  end

  context "color" do
    it "c:w (Any card that is white)" do
      expect(query("c:w").where_values).to include("'White' = ANY(colors)")
    end

    it "c:wu (Any card that is white or blue)" do
      expect(query("c:wu").where_values).
        to include("'White' = ANY(colors) OR 'Blue' = ANY(colors)")
    end

    it "c:wum (Any card that is white or blue, and multicolored)" do
      expect(query("c:wum").where_values).
        to include("'White' = ANY(colors) OR 'Blue' = ANY(colors)")
      expect(query("c:wum").where_values).
        to include("array_length(colors, 1) > 1")
    end

    it "c!w (Cards that are only white)" do
      expect(query("c!w").where_values).
        to include("array_sort(colors)::text[] = array_sort(ARRAY['White'])")
    end

    it "c!wu (Cards that are only white or blue, or both)" do
      expect(query("c!wu").where_values).
        to include("array_sort(colors)::text[] = array_sort(ARRAY['White','Blue']) OR 'White' = ALL(colors) OR 'Blue' = ALL(colors)")
    end

    it "c!wum (Cards that are only white and blue, and multicolored)" do
      expect(query("c!wum").where_values).
        to include("array_sort(colors)::text[] = array_sort(ARRAY['White','Blue'])")
    end

    it "c!wubrgm (Cards that are all five colors)" do
      expect(query("c!wubrgm").where_values).
        to include("array_sort(colors)::text[] = array_sort(ARRAY['White','Blue','Black','Red','Green'])")
    end

    it "c:m (Any multicolored card)" do
      expect(query("c:m").where_values).
        to include("array_length(colors, 1) > 1")
    end

    it "c:l (Lands cards)" do
      expect(query("c:l").where_values).
        to include("'Land' = ANY(card_types)")
    end

    it "c:c (colorless cards)" do
      expect(query("c:c").where_values).
        to include("colors IS NULL")
    end
  end
end
