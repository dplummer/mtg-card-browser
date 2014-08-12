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
    it "e:lea (Uses the abbreviations that are listed on the sitemap) and ignores language" do
      q = query("e:lea")
      expect(q.where_values).to eq([])
      expect(q.joins_values).to include('INNER JOIN "editions" AS e0 ON e0."card_id" = "cards"."id"')
      expect(q.joins_values).to include(%{INNER JOIN "mtg_sets" AS s0 ON s0."id" = e0."mtg_set_id" AND s0.code = 'LEA'})
      expect(q.group_values).to eq(["cards.id"])
    end

    it "e:lea,leb (Cards that appear in Alpha or Beta)" do
      q = query("e:lea,leb")
      expect(q.where_values).to eq([])
      expect(q.joins_values).to include(%{INNER JOIN "editions" AS e0 ON e0."card_id" = "cards"."id"})
      expect(q.joins_values).to include(%{INNER JOIN "mtg_sets" AS s0 ON s0."id" = e0."mtg_set_id" AND s0.code IN ('LEA','LEB')})
      expect(q.group_values).to eq(["cards.id"])
    end

    it "e:lea+leb (Cards that appear in Alpha and Beta)" do
      q = query("e:lea+leb")
      expect(q.where_values).to eq([])
      expect(q.joins_values).to include(%{INNER JOIN "editions" AS e0 ON e0."card_id" = "cards"."id"})
      expect(q.joins_values).to include(%{INNER JOIN "mtg_sets" AS s0 ON s0."id" = e0."mtg_set_id" AND s0.code = 'LEA'})
      expect(q.joins_values).to include(%{INNER JOIN "editions" AS e1 ON e1."card_id" = "cards"."id"})
      expect(q.joins_values).to include(%{INNER JOIN "mtg_sets" AS s1 ON s1."id" = e1."mtg_set_id" AND s1.code = 'LEB'})
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

  context "rules text" do
    it 'o:Flying finds rules text with Flying' do
      expect(query("o:Flying").where_values).
        to eq(["text ILIKE '%Flying%'"])
    end

    it 'o:"First strike"' do
      expect(query('o:"First strike"').where_values).
        to eq(["text ILIKE '%First strike%'"])
    end

    it 'o:{T} o:"add one mana of any color"' do
      expect(query('o:{T} o:"add one mana of any color"').where_values).
        to eq(["text ILIKE '%{T}%'", "text ILIKE '%add one mana of any color%'"])
    end

    xit 'o:"whenever ~ deals combat damage"' do
      expect(query('o:"First strike"').where_values).
        to eq([])
    end
  end

  context "mana cost" do
    it "mana=3G (Spells that cost exactly 3G, or split cards that can be cast with 3G)" do
      expect(query("mana=3G").where_values).
        to eq(["mana_cost = '{3}{G}'"])
    end

    xit "mana>=2WW (Spells that cost at least two white and two colorless mana)" do
      expect(query("mana>=2WW").where_values).
        to eq(["mana_cost LIKE '%{W}{W}%'",
               "colorless_mana_cost(mana_cost) >= 2"])
    end

    xit "mana<GGGGGG (Spells that can be cast with strictly less than six green mana)" do

    end

    xit "mana>=2RR mana<=6RR (Spells that cost two red mana and between two and six colorless mana)" do

    end

    xit "mana>={2/R}" do

    end

    xit "mana>={W/U}" do

    end

    xit "mana>={UP}" do

    end
  end

  context "OR grouping" do
    it "cat OR dog (Any card that is white or blue)" do
      expect(query("cat OR dog").where_values).
        to eq(["unaccent(cards.name) ILIKE '%cat%' OR "\
               "unaccent(cards.name) ILIKE '%dog%'"])
    end
  end
end
