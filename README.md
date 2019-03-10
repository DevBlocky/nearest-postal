# Nearest Postals
This script displays a nearest postal next to where PLD would go and also has a command to draw a route to a specific postal

## Installation
There are 2 ways to install it, and I recommend the first
1. Run the following command in a terminal
    - `git clone https://github.com/blockba5her/nearest-postal.git`
2. Click the `Download` button up top to download the source code, then put it in your resources folder
3. As of now, this script supports 2 postal maps. From what I have seen, these are the most popular
    - `new-postals.json` -> [New and Improved Postals](https://forum.fivem.net/t/release-postal-code-map-new-improved-v1-1/147458)
    - `old-postals.json` -> [Original Postals](https://forum.fivem.net/t/release-modified-street-names-w-postal-numbers/8717)
    - `ocrp-postals.json` -> [OCRP Postals](https://forum.fivem.net/t/release-ocrp-community-releases/166277)
4. To setup the postal map rename your file from what it was to `postals.json`

## Command
To draw a route to a certain postal, type `/postal [postalName]` and to remove just type `/postal`

It will automatically remove the route when within 150m of the destination

## Updates
### 1.1.1
* Fixed issue with blip name being set to nil, clearing the screen of all other text
### 1.1
* Added OCRP postals
* Added `config.lua` file

## Development
This script provides a simple way of working on a new postal map
1. In the script, enabled the local variable `dev` near the bottom
2. Restart the script into game
3. Teleport to the first postal code in numerical order
4. Type `setnext [postalCode]` where postalCode is the postal that you are at
5. Type `next` to insert it
6. Teleport to the next postal code in numerical order
7. Type `next` to insert it
8. Repeat from step 6 on

When done with that, you can print all of the postals you just inserted into console with the `json` command

## Discord
Join my [discord](https://discord.gg/ZcTayce) for support and more scripts
