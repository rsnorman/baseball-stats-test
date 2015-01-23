#Baseball Stats

## Requirements
- Read players file
- Read stats file that could be hitting or pitching
- Display results of different types of reports

## Tasks
- Read Files
  - Create simple CSV parser (maybe use FasterCSV but might be over kill since files are pretty simple) x
  - Read Players CSV File x
    - Parse Player ID, birth year, first name, last name x
    - Player ID stored in memory as index for easy access x
  - Read stats file
    - Parse file with player ID, year, team, and all stats
    - Allow it to grab stats in any order based on header (top) row
  - Show progress reading file every 5 seconds or so
  - File readers inherit from base CSV parser to have easy access to file read methods x
- Store Data
  - Store in memory or in database
  - Memory
    - Quick
    - No setup
    - Can't use SQL query to create reports and must write ruby for new ones
  - Database
    - Only need to read files once
    - Can create reports in SQL and easy to create new ones
    - More setup and dependencies, need to install sqlite and migrate tables
    - Can use view to store results of formulas
    - Not sure if I can use non-ruby libraries or want them to have to install a bunch of dependencies
  - May need to see what they mean by production environment, not many production environments would ever store this amount of data in flat files
  - But don't want to have a bunch of dependencies need to be installed just to run
  - Check speed without database, may be fine just reading from flat files and storing in memory
- Define Fantasy Stats
  - Points must be easily configurable for stats
  - Store in JSON file since they're easy to edit and hard to screw up formala
  - Should use stat ID (abbreviations)
- Create Formulas
  - Can be contained within player model
  - Should there be a way to easily add new formulas?
- Build Reports
  - Have folder of reports that can be easily read and displayed to user to run
  - Report file name is report name (humanized, obviously)
  - Would love to just have report contain SQL but may be much more flexible having a base report class and each new report must implement required methods

## Models
- Player
  - fields
    - player_id
    - birth_year
    - first_name
    - last_name
  - methods
    - batting_average (optional year)
    - slugging_percentage (optional year)
    + triple_crown_winner(year)
- PlayerStatYear
  - fields
    - year
    - team
  - methods
    - stats
- Stat
   - id (abbreviation)
   - value (int)
- StatType
   - abbreviation
   - name
- Report
  - fields
    - name
  - methods
    - run
    - display

## Extra
- Show full team names defined in JSON file
- Show team name with team colors
