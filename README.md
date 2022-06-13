# Game Quake Log Parse

The project consist in implementation for parse log the Game Quake. 
Example line log register in file:
```
21:42 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT
```
# Requirement
The project implemented a gem file for easy install and run parse log. 

- Ruby 2.7
- Rspec - Lasted version

## Instructions to install an run project

#### Installation 
You need run the commands lines above in your terminal
```
$ gem build quake-log.gemspec
```
After you execute build command the output should similar to:

```
Successfully installed quake-log-0.0.1
Parsing documentation for quake-log-0.0.1
Done installing documentation for quake-log after 0 seconds
1 gem installed
```
For installation you need run the command 

```
gem install quake-log-0.0.1.gem
```
Now you can use in your terminal via irb. 

#### Run parser direct in your terminal command 

For return all information about games run command line
```
$ ruby lib/main.rb
```
The result should similar to:
```json
"game_1": {
"total_kills": 45,
"players": ["Dono da bola", "Isgalamido", "Zeh"],
"kills": {
  "Dono da bola": 5,
  "Isgalamido": 18,
  "Zeh": 20
  }
}...
```

For return specific game run command
```
$ ruby lib/main.rb -g game_11
```
The result should similar to:

```json
"game_11": {
"total_kills": 45,
"players": ["Dono da bola", "Isgalamido", "Zeh"],
"kills": {
  "Dono da bola": 5,
  "Isgalamido": 18,
  "Zeh": 20
  }
}...
```
For return specific game with reasons of killeds
```
$ ruby lib/main.rb -g game_11 -k
```
```json
{
  "game_11": {
    "kill_by_means": {
      "MOD_ROCKET": 37,
      "MOD_TRIGGER_HURT": 14,
      "MOD_RAILGUN": 9,
      "MOD_ROCKET_SPLASH": 60,
      "MOD_MACHINEGUN": 4,
      "MOD_SHOTGUN": 4,
      "MOD_FALLING": 3
    }
  }
}
```

### How to run units test
Install rspec with command line
```
$ gem install rspec
```
For execute units tests run command line:
```
$ cd spec/; rspec
```
The result should simitar to example above:
```
Finished in 0.00056 seconds (files took 0.03862 seconds to load)
0 examples, 0 failures
```


