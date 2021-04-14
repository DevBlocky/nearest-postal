# Nearest Postals

This script displays the nearest postal next to map, and allows you to navigate to specific postal codes with `/postal`

## Installation

1. There are 2 ways to install it, and I recommend the first
    1. Run the following command in a terminal
        - `git clone https://github.com/blockba5her/nearest-postal.git`
    2. Download the code from the GitHub [releases](https://github.com/blockba5her/nearest-postal/releases)
2. As of now, this script supports 3 postal maps. From what I have seen, these are the most popular
    - `new-postals.json` -> [New and Improved Postals](https://forum.fivem.net/t/release-postal-code-map-new-improved-v1-1/147458)
    - `old-postals.json` -> [Original Postals](https://forum.fivem.net/t/release-modified-street-names-w-postal-numbers/8717)
    - `ocrp-postals.json` -> [OCRP Postals](https://forum.fivem.net/t/release-ocrp-community-releases/166277)
3. To setup the postal map, open the `fxmanifest.lua` file and change the variable `postalFile` to one of the files above
    - **NOTE**: This defaults as the `new-postals.json` file

## Command

To draw a route to a certain postal, type `/postal [postalName]` and to remove just type `/postal`

It will automatically remove the route when within 100m of the destination

## Updates

### 1.5

-   Major performance improvements
-   Added the `refreshRate` configuration option
-   Simplified distance calculation logic
-   Separated code into separate files
-   Prebuild the postal list with vectors at startup
-   Use FiveM Lua 5.4

### 1.4

-   Performance Improvements
-   New config options added
-   Fix some tiny bugs (and leftover code)

### 1.3

-   Improvements in selection of postal map
-   Fix dev mode being on

### 1.2.1

-   Fixes to missing postals on improved postal map

### 1.2

-   Updates to README.md
-   Version check
-   Fixes for Improved Postal map
-   Updates to dev API

### 1.1.1

-   Fixed issue with blip name being set to nil, clearing the screen of all other text

### 1.1

-   Added OCRP postals
-   Added `config.lua` file

## Development

This script provides a simple way of working on a new postal map

1. In the resource `fxmanifest.lua` file, uncomment the `cl_dev.lua` requirement line
2. Do `refresh` and `restart nearest-postal` in-game
3. Teleport to the first postal code in numerical order
4. Type `/setnext [postalCode]` where postalCode is the postal that you are at
5. Type `/next` to insert it
6. Teleport to the next postal code in numerical order
7. Type `/next` to insert it
8. Repeat from step 6 on

If you make a mistake, you can either remove a specific postal using `/remove [postalCode]` or remove the last postal inserted with `/rl` (this will decrease the next value also)

When done with that, you can print all of the postals you just inserted into console with the `/json` command and then copy it from your `CitizenFX.log` file

## Discord

Join my [discord](https://discord.gg/ZcTayce) for support and more scripts
