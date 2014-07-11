@wip
Feature: Set Browsing
  As a player of magic
  I want to browse cards
  To see them all

  Background:
    Given I have the following sets:
      | Name                   | Code | Release Type | Release Date | Block  |
      | Limited Edition Alpha  | LEA  | core         | 1993-08-05   |        |
      | Antiquities            | ATQ  | expansion    | 1994-03-01   |        |
      | Commander 2013 Edition | C13  | commander    | 2013-11-01   |        |
      | Born of the Gods       | BNG  | expansion    | 2014-02-07   | Theros |
      | Classic Sixth Edition  | 6ED  | core         | 1999-04-21   |        |

    Scenario: Browsing Sets
      Given I visit the sets page
      Then I should see the following sets in this order:
      | Name                   | Code | Release Type | Release Date | Block  |
      | Born of the Gods       | BNG  | expansion    | 2014-02-07   | Theros |
      | Commander 2013 Edition | C13  | commander    | 2013-11-01   |        |
      | Classic Sixth Edition  | 6ED  | core         | 1999-04-21   |        |
      | Antiquities            | ATQ  | expansion    | 1994-03-01   |        |
      | Limited Edition Alpha  | LEA  | core         | 1993-08-05   |        |
