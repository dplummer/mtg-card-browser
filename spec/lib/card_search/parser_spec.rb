require 'spec_helper'

describe CardSearch::Parser do
  def query(str)
    CardSearch::Parser.new(str).scope
  end

  context "name" do
    it "Birds of Paradise" do
      expect(query("Birds of Paradise").where_values).
        to eq(["unaccent(cards.name) ILIKE '%Birds%'",
               "unaccent(cards.name) ILIKE '%of%'",
               "unaccent(cards.name) ILIKE '%Paradise%'"])
    end

    it "allows quotes" do
      expect(query('"Birds of Paradise"').where_values).
        to eq(["unaccent(cards.name) ILIKE '%Birds of Paradise%'"])
    end

    it "uses a bang at the beginning to match the whole term" do
      expect(query("!Birds of Paradise").where_values).
        to eq(["unaccent(cards.name) = 'Birds of Paradise'"])
    end

    it "converts beginning with AE to A for unaccenting" do
      expect(query("AEther").where_values).
        to eq(["unaccent(cards.name) ILIKE '%Ather%'"])
    end

    it "doesn't convert AE in the middle of the string" do
      expect(query("FAE").where_values).
        to eq(["unaccent(cards.name) ILIKE '%FAE%'"])
    end
  end

  context "edition code" do
    it "e:lea/en (Uses the abbreviations that are listed on the sitemap) and ignores language" do
      q = query("e:lea/en")
      expect(q.where_values).to eq([])
      expect(q.joins_values).to include("INNER JOIN `editions` AS e0 ON e0.`id` = `cards`.`editions_id`")
      expect(q.joins_values).to include("INNER JOIN `mtg_sets` AS s0 ON s0.`id` = e0.`mtg_set_id` AND s0.code = 'LEA'")
      expect(q.group_values).to eq(["cards.id"])
    end

    it "e:lea,leb (Cards that appear in Alpha or Beta)" do
      q = query("e:lea,leb")
      expect(q.where_values).to eq([])
      expect(q.joins_values).to include("INNER JOIN `editions` AS e0 ON e0.`id` = `cards`.`editions_id`")
      expect(q.joins_values).to include("INNER JOIN `mtg_sets` AS s0 ON s0.`id` = e0.`mtg_set_id` AND s0.code IN ('LEA','LEB')")
      expect(q.group_values).to eq(["cards.id"])
    end

    it "e:lea+leb (Cards that appear in Alpha and Beta)" do
      q = query("e:lea+leb")
      expect(q.where_values).to eq([])
      expect(q.joins_values).to include("INNER JOIN `editions` AS e0 ON e0.`id` = `cards`.`editions_id`")
      expect(q.joins_values).to include("INNER JOIN `mtg_sets` AS s0 ON s0.`id` = e0.`mtg_set_id` AND s0.code = 'LEA'")
      expect(q.joins_values).to include("INNER JOIN `editions` AS e1 ON e1.`id` = `cards`.`editions_id`")
      expect(q.joins_values).to include("INNER JOIN `mtg_sets` AS s1 ON s1.`id` = e1.`mtg_set_id` AND s1.code = 'LEB'")
      expect(q.group_values).to eq(["cards.id"])
    end

    xit "e:al,be -e:al+be (Cards that appear in Alpha or Beta but not in both editions)" do

    end
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

  context "card type" do
    it "t:angel" do
      expect(query("t:angel").where_values).
        to eq(["array_sort(LOWER(card_types || supertypes || subtypes))::text[] @> array_sort(ARRAY['angel'])"])
    end

    it 'ANDs quotes t:"legendary angel"' do
      expect(query('t:"legendary angel"').where_values).
        to eq(["array_sort(LOWER(card_types || supertypes || subtypes))::text[] @> array_sort(ARRAY['legendary','angel'])"])
    end
  end
end
