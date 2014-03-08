module Import
  class Legality
    FORMATS = {
      "Standard"         => "https://www.wizards.com/Magic/TCG/Resources.aspx?x=judge/resources/sfrstandard",
      "Modern"           => "https://www.wizards.com/Magic/TCG/Resources.aspx?x=judge/resources/sfrmodern",
      "Extended"         => "https://www.wizards.com/Magic/TCG/Resources.aspx?x=judge/resources/sfrextended",
      "Block"            => "https://www.wizards.com/Magic/TCG/Resources.aspx?x=judge/resources/sfrblock",
      "Two-Headed Giant" => "https://www.wizards.com/Magic/TCG/Resources.aspx?x=judge/resources/sfr2hg",
      "Vintage"          => "https://www.wizards.com/Magic/TCG/Resources.aspx?x=judge/resources/sfrvintage",
      "Legacy"           => "https://www.wizards.com/Magic/TCG/Resources.aspx?x=judge/resources/sfrlegacy",
      "Commander"        => "https://www.wizards.com/Magic/TCG/Resources.aspx?x=magic/rules/100cardsingleton-commander"
    }

    STANDARD_SETS = [
      "Return to Ravnica",
      "Gatecrash",
      "Dragon's Maze",
      "Magic 2014",
      "Theros",
      "Born of the Gods"
    ]

    def self.run!
      ::Card.joins(:editions => :mtg_set).where(mtg_sets: {name: STANDARD_SETS}).
        update_all(%(legality = legality || '"Standard"=>"Legal"'::hstore))
    end
  end
end
