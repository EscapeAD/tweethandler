# Tweet Analyzer
  Reads CSV uploads to checks sentiment / sortable by filters and etc.

  - using Dandelion api ( I modify gem as original gem had issues )
    "https://github.com/EscapeAD/dandelionapi-ruby"
  - using action-cable // actions will effect all uses except sort and filter
  - Based on provided twitter dump file
  - postgresql

Due to api limit of free - changed it to web application sync with all browsers

Features:
```
- sorta by clicking language/type/sentiment
- additional filter type options
- websocket: sync all browsers
- csv format check
- notification upon hitting api limit
```

Background jobs:
```
- after commit a csv log runs api Call
- action-cable after update job to update page
```

Usage:
```
  import csv
  filter/sort tweets
  clear tweets -> import new csv
```

local install:
```
- clone
- $ bundle install
- $ bundle exec figaro install
- $ rails db:migrate
- # config/application.yml  
    api_key: <key>
- $ rails s
```

## Developer

```
Adam Tse
@EscapeAD
```


## issues

```
free api limit
```
