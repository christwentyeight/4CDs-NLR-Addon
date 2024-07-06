# 4CD's NLR Addon

A super simple NLR addon for Garry's Mod DarkRP.

## Description

This is my first addon for Garry's Mod, it's a very simple NLR addon that draws a red circle around where the player dies.
It then puts text at the top of the players screen that the "NLR Zone's" remaining time and amount of time in the circle.
When you enter the circle the after dying a counter will begin to countdown from 10, once it reaches 0 the player will die.
This should hopefully deter players from entering the NLR zone.

This github page is the only official place to download this addon.

## Getting Started

### Dependencies

* A Garry's Mod 13 Server
* Any text editor capable of editing lua (if customising addon)

### Installing

* Extract the .zip file
* Place the folder "death_circle" into the 'garrysmod/addons' folder

### How To Use

* Type "!nlrver" in chat to see the version the server is running
* Any edits to the addon (circleRadius, cooldownDuration, maxDeathCount, textScale, textHeight, removalDuration) can be changed at the top of the "cl_death_circle" lua file

## Extra Information

### Plans

* Add a menu to edit the addon in game using !nlrmenu
* Add more customization such as (circleColour, textFont, textColour)

### Authors

Contributors names and contact info

[4CD/christwentyeight](https://steamcommunity.com/id/christwentyeight/)

### Version History

* 0.1
    * Initial Release

### Images

![!nlrver command](https://i.imgur.com/jFXYzih.png)
![NLR Zone](https://i.imgur.com/XrwXd1p.jpg)
