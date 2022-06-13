
- How to build gem 

gem build quake-log.gemspec

- How to install gem

gem install quake-log-0.0.1.gem

After output messsage 

Successfully installed quake-log-0.0.1
Parsing documentation for quake-log-0.0.1
Done installing documentation for quake-log after 0 seconds
1 gem installed

You can acesse lib with command line IRB ruby

- To run with console app 

access directory lib 

- To return specific game with reasons of killeds

$ ruby lib/main.rb -g game_11 -k 

- To return specific game infos

$ ruby lib/main.rb -g game_11

- To return all informations of games 

$ ruby lib/main.rb 


- How to execute units tests

Install rspec with command line

$ gem install rspec

To execute units teste run

$ rspec 
