Given(/^I have the following sets:$/) do |table|
  table.hashes.each do |row|
    MtgSet.create!({
      name: row['Name'],
      code: row['Code'],
      release_type: row['Release Type'],
      release_date: Date.parse(row['Release Date']),
      block: row['Block']
    })
  end
end

Given(/^I visit the sets page$/) do
  visit mtg_sets_path
end

Then(/^I should see the following sets in this order:$/) do |table|
  actual = page.all("tr.mtg_set").map do |row|
    {
      "Name" => row.find(".name").text,
      "Code" => row.find(".code").text,
      "Release Type" => row.find(".release_type").text,
      "Release Date" => row.find(".release_date").text,
      "Block" => row.find(".block").text,
    }
  end

  expect(actual).to eq(table.hashes)
end
