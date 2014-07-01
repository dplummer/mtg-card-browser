require 'progress'
require 'csv'

namespace :cc do
  task :id_import, [:filename] do |task, args|
    filename = args[:filename]
    raise "must define filename" unless filename
    lines = `wc -l #{filename}`.chomp.to_i - 1

    Progress.start("importing #{lines} cc catalog ids", lines) do
      CSV.foreach(filename, headers: true) do |row|
        name = row['name'].gsub(/AE/, 'A').gsub(/ \(\d+\)/, '')

        skip_sets = [
          'Arena Promos',
          'Player Rewards Promos',
          'Book Promos',
          'Apac Land Promos',
          'Euro Land Promos',
          'Guru Land Promos',
          'Token Promos',
          'Unique & Misc. Promos',
          'Collectors Edition',
          'Collectors Edition - International',
          'Anthologies',
          'Coldsnap Theme Deck Reprints',
          'Deckmasters',
          'Japanese Duel Decks: Jace vs Chandra',
          'Commander Oversized Cards',
          'Pre-Release & Release Promos',
          'Alternate 4th Edition',
          '',
          nil,
          'Unique & Misc Promos',
          'Face the Hydra',
          'Magic 2015',
          'Battle the Horde',
          'FNM Promos',
          'IDW',
        ]

        next if skip_sets.include?(row['set'])

        skip_cards = [
          'Poison Counter',
          'Double-Sided Card Checklist',
          'Emblem - Sorin, Lord of Innistrad',
          'Emblem - Koth of the Hammer',
          'Emblem - Venser, the Sojourner',
          'Emblem - Tamiyou, the Moon Sage',
          'Emblem - Liliana of the Dark Realms',
          'Emblem - Domri Rade',
          'Emblem - Elspeth, Knight-Errant',
          "Emblem - Elspeth, Sun's Champion",
          "Emblem - Kiora, the Crashing Wave",
          'Swallow the Hero Whole',
          '',
          nil,
        ]

        next if skip_cards.include?(row['name'])

        next if row['name'] =~ / - Oversized$/

        skip_ids = [
          852962, 852963, 854192, 858352, 858353, 858354, 858355, 858356,
          858357, 858358, 863324, 863325, 863326, 863327, 863328, 863329,
          863330, 863331, 863332, 863333, 868976, 868977, 868978, 868979,
          870603, 872537, 872538, 872539, 872540, 872541, 872542, 872543,
          872544, 872545, 872546, 872547, 873280, 878845, 878846, 910509,
          940048, 940049, 1290763, 1290773, 1290783, 1325113
        ]

        next if skip_ids.include?(row['id'].to_i)

        set = {
          'Alpha'         => 'Limited Edition Alpha',
          'Beta'          => 'Limited Edition Beta',
          'Unlimited'     => 'Unlimited Edition',
          'Sixth Edition' => 'Classic Sixth Edition',
          'Ravnica'       => 'Ravnica: City of Guilds',
          'Timeshifted'   => 'Time Spiral "Timeshifted"',
          'Battle Royale' => 'Battle Royale Box Set',
          'Planechase - Planes' => 'Planechase',
          'Archenemy Schemes' => 'Archenemy',
          'Archenemy Singles' => 'Archenemy',
          'Planechase 2012' => 'Planechase 2012 Edition',
          'Planechase 2012 Oversized Cards' => 'Planechase 2012 Edition',
          'Magic 2014' => 'Magic 2014 Core Set',
          'Duel Decks: Heroes VS Monsters' => 'Duel Decks: Heroes vs. Monsters',
          'Commander 2013' => 'Commander 2013 Edition',
          'Jace vs Vraska' => 'Duel Decks: Jace vs. Vraska',
          'Journey Into Nyx' => 'Journey into Nyx',
          'Modern Event Deck Singles' => 'Modern Event Deck 2014',
        }.fetch(row['set'], row['set'])

        set.gsub!(/ vs /, ' vs. ')

        case name
        when 'B.F.M. 1 (Big Furry Monster)'
          printing = Printing.find(5539)
        when 'B.F.M. 2 (Big Furry Monster)'
          printing = Printing.find(5540)
        when 'Kongming, Sleeping Dragon'
          printing = Printing.find(6534)
        when 'Pang Tong, Young Phoenix'
          printing = Printing.find(6555)
        when "Urza's Mine (Clawed Sphere)"
          case set
          when "Chronicles"
            printing = Printing.find(2907)
          when "Antiquities"
            printing = Printing.find(1075)
          end
        when "Urza's Mine (Pulley)"
          case set
          when "Chronicles"
            printing = Printing.find(2906)
          when "Antiquities"
            printing = Printing.find(1074)
          end
        when "Urza's Mine (Mouth)"
          case set
          when "Chronicles"
            printing = Printing.find(2904)
          when "Antiquities"
            printing = Printing.find(1077)
          end
        when "Urza's Mine (Tower)"
          case set
          when "Chronicles"
            printing = Printing.find(2905)
          when "Antiquities"
            printing = Printing.find(1076)
          end
        when "Urza's Power Plant (Bug)"
          case set
          when "Chronicles"
            printing = Printing.find(2910)
          when "Antiquities"
            printing = Printing.find(1082)
          end
        when "Urza's Power Plant (Columns)"
          case set
          when "Chronicles"
            printing = Printing.find(2911)
          when "Antiquities"
            printing = Printing.find(1080)
          end
        when "Urza's Power Plant (Rock in Pot)"
          case set
          when "Chronicles"
            printing = Printing.find(2908)
          when "Antiquities"
            printing = Printing.find(1081)
          end
        when "Urza's Power Plant (Sphere)"
          case set
          when "Chronicles"
            printing = Printing.find(2909)
          when "Antiquities"
            printing = Printing.find(1079)
          end
        when "Urza's Tower (Shore)"
          case set
          when "Chronicles"
            printing = Printing.find(2913)
          when "Antiquities"
            printing = Printing.find(1084)
          end
        when "Urza's Tower (Mountains)"
          case set
          when "Chronicles"
            printing = Printing.find(2915)
          when "Antiquities"
            printing = Printing.find(1086)
          end
        when "Urza's Tower (Forest)"
          case set
          when "Chronicles"
            printing = Printing.find(2912)
          when "Antiquities"
            printing = Printing.find(1083)
          end
        when "Urza's Tower (Plains)"
          case set
          when "Chronicles"
            printing = Printing.find(2914)
          when "Antiquities"
            printing = Printing.find(1085)
          end
        when "Army of Allah (dark)"
          printing = Printing.find(604)
        when "Army of Allah (Light)"
          printing = Printing.find(605)
        when "Bird Maiden (Dark)"
          printing = Printing.find(607)
        when "Bird Maiden (Light)"
          printing = Printing.find(608)
        when "Erg Raiders (Dark)"
          printing = Printing.find(626)
        when "Erg Raiders (Light)"
          printing = Printing.find(627)
        when "Fishliver Oil (Dark)"
          printing = Printing.find(630)
        when "Fishliver Oil (Light)"
          printing = Printing.find(631)
        when "Giant Tortoise (Dark)"
          printing = Printing.find(635)
        when "Giant Tortoise (Light)"
          printing = Printing.find(636)
        when "Hasran Ogress (Dark)"
          printing = Printing.find(638)
        when "Hasran Ogress (Light)"
          printing = Printing.find(639)
        when "Moorish Cavalry (Dark)"
          printing = Printing.find(658)
        when "Moorish Cavalry (Light)"
          printing = Printing.find(659)
        when "Nafs Asp (Dark)"
          printing = Printing.find(661)
        when "Nafs Asp (Light)"
          printing = Printing.find(662)
        when "Oubliette (Dark)"
          printing = Printing.find(665)
        when "Oubliette (Light)"
          printing = Printing.find(666)
        when "Piety (Dark)"
          printing = Printing.find(667)
        when "Piety (Light)"
          printing = Printing.find(668)
        when "Rukh Egg (Dark)"
          printing = Printing.find(672)
        when "Rukh Egg (Light)"
          printing = Printing.find(673)
        when "Stone-Throwing Devils (Dark)"
          printing = Printing.find(683)
        when "Stone-Throwing Devils (Light)"
          printing = Printing.find(682)
        when "War Elephant (Dark)"
          printing = Printing.find(685)
        when "War Elephant (Light)"
          printing = Printing.find(686)
        when "Wyluli Wolf (Dark)"
          printing = Printing.find(687)
        when "Wyluli Wolf (Light)"
          printing = Printing.find(688)
        when "Mishra's Factory (Autumn)"
          printing = Printing.find(1036)
        when "Mishra's Factory (Spring)"
          printing = Printing.find(1035)
        when "Mishra's Factory (Summer)"
          printing = Printing.find(1037)
        when "Mishra's Factory (Winter)"
          printing = Printing.find(1038)
        when "Strip Mine (Tower)"
          printing = Printing.find(1060)
        when "Strip Mine (No Horizon)"
          printing = Printing.find(1058)
        when "Strip Mine (Uneven Horizon)"
          printing = Printing.find(1059)
        when "Strip Mine (Even Horizon)"
          printing = Printing.find(1061)
        when "Evil Eye of Orms-By-Gore"
          printing = Printing.find(1477)
        when 'Ach! Hans, Run!'
          printing = Printing.find(11473)
        when '_________'
          printing = Printing.find(11474)
        when 'Our Market Research'
          printing = Printing.find(11563)
        when 'Who/What/When/Where/Why'
          printings = Printing.where(id: [11610, 11606, 11607, 11609, 11611])
        when 'Brothers Yamazaki (A)'
          printing = Printing.find(11175)
        when 'Brothers Yamazaki (B)'
          printing = Printing.find(11176)
        when / \/\/ /
          names = name.split(' // ')
          printings = Printing.joins(:edition => [:mtg_set, :card]).
            where(mtg_sets: {name: set}).
            where(cards: {name: names}).
            all
        when 'Beast A'
          printing = Printing.find(17393)
        when 'Beast B'
          printing = Printing.find(17394)
        when /Full Art/
          printings = Printing.joins(:edition => :mtg_set).
            where(mtg_sets: {name: set}).
            where(number: row['number']).
            all
        when / - v2$/
          name.gsub!(/ - v2$/,'')
          printings =[Printing.joins(:edition => [:mtg_set, :card]).
                        where(mtg_sets: {name: set}).
                        where("unaccent(cards.name) = unaccent(?)", name).
                        order("printings.id ASC").
                        last].compact
        when 'Hymn to Tourach [Version 1]'
          printing = Printing.find 1938
        when 'Hymn to Tourach [Version 2]'
          printing = Printing.find 1941
        when 'Hymn to Tourach [Version 3]'
          printing = Printing.find 1940
        when 'Hymn to Tourach [Version 4]'
          printing = Printing.find 1941
        when 'Goblin Grenade [Version 1]'
          printing = Printing.find 1914
        when 'Goblin Grenade [Version 2]'
          printing = Printing.find 1913
        when 'Goblin Grenade [Version 3]'
          printing = Printing.find 1915
        when 'High Tide [Version 1]'
          printing = Printing.find 1926
        when 'High Tide [Version 2]'
          printing = Printing.find 1927
        when 'High Tide [Version 3]'
          printing = Printing.find 1925
        else
          printings = Printing.joins(:edition => [:mtg_set, :card]).
            where(mtg_sets: {name: set}).
            where("unaccent(cards.name) = unaccent(?)", name).
            all
        end

        printings ||= [printing]
        if printings.length > 0
          printings.each do |printing|
            printing.cc_id = row['id']
            printing.save if printing.changed?
          end
        elsif name !~ /Token|Forest|Island|Plains|Mountain|Swamp/
          puts "Couldn't find printing for #{row}"
          binding.pry
        end

        Progress.step
      end
    end
  end
end

