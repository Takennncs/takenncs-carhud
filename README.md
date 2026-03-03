# takenncs Vehicle Hud

A customizable vehicle HUD (Heads-Up Display) for FiveM that shows speed, fuel level, seatbelt status, cruise control, and location information.

## 📸 Preview

[Add screenshots here]

## ✨ Features

- **Digital Speedometer** - Clean, easy-to-read speed display in KMH
- **Fuel Gauge** - Vertical fuel bar with color-changing low fuel warning (red below 20%)
- **Seatbelt System** - Toggle seatbelt with visual indicator (B key by default)
- **Cruise Control** - Set and maintain your speed (CAPS LOCK by default)
- **Location Display** - Shows current street name, direction, and zone
- **Vehicle Class Support** - Seatbelt availability based on vehicle type
- **Realistic Acceleration** - Configurable torque and power multipliers for more realistic driving feel

## 📋 Requirements

- FiveM server
- [cdn-fuel](https://github.com/CodineDev/cdn-fuel) (optional - falls back to native fuel if not present)

## 🚀 Installation

1. Download the resource
2. Place it in your server's `resources` folder
3. Add `ensure takenncs-carhud` to your `server.cfg`
4. Restart your server or start the resource

## ⚙️ Configuration

Edit `config.lua` to customize the HUD:

```lua
Config = {
    -- Direction display mappings
    Directions = { [0] = 'N', [1] = 'NW', [2] = 'W', [3] = 'SW', 
                   [4] = 'S', [5] = 'SE', [6] = 'E', [7] = 'NE', [8] = 'N' },
    
    -- Street/zone name mappings
    Streets = {
        ['AIRP'] = "Los Santos International Airport",
        ['ALAMO'] = "Alamo Sea",
        ['ALTA'] = "Alta",
        ['ARMYB'] = "Fort Zancudo",
        ['BANHAMC'] = "Banham Canyon Dr",
        ['BANNING'] = "Banning",
        ['BEACH'] = "Vespucci Beach",
        ['BHAMCA'] = "Banham Canyon",
        ['BRADP'] = "Braddock Pass",
        ['BRADT'] = "Braddock Tunnel",
        ['BURTON'] = "Burton",
        ['CALAFB'] = "Calafia Bridge",
        ['CANNY'] = "Raton Canyon",
        ['CCREAK'] = "Cassidy Creek",
        ['CHAMH'] = "Chamberlain Hills",
        ['CHIL'] = "Vinewood Hills",
        ['CHU'] = "Chumash",
        ['CMSW'] = "Chiliad Mountain State Wilderness",
        ['CYPRE'] = "Cypress Flats",
        ['DAVIS'] = "Davis",
        ['DELBE'] = "Del Perro Beach",
        ['DELPE'] = "Del Perro",
        ['DELSOL'] = "La Puerta",
        ['DESRT'] = "Grand Senora Desert",
        ['DOWNT'] = "Downtown",
        ['DTVINE'] = "Downtown Vinewood",
        ['EAST_V'] = "East Vinewood",
        ['EBURO'] = "El Burro Heights",
        ['ELGORL'] = "El Gordo Lighthouse",
        ['ELYSIAN'] = "Elysian Island",
        ['GALFISH'] = "Galilee",
        ['GOLF'] = "GWC and Golfing Society",
        ['GRAPES'] = "Grapeseed",
        ['GREATC'] = "Great Chaparral",
        ['HARMO'] = "Harmony",
        ['HAWICK'] = "Hawick",
        ['HORS'] = "Vinewood Racetrack",
        ['HUMLAB'] = "Humane Labs and Research",
        ['JAIL'] = "Bolingbroke Penitentiary",
        ['KOREAT'] = "Little Seoul",
        ['LACT'] = "Land Act Reservoir",
        ['LAGO'] = "Lago Zancudo",
        ['LDAM'] = "Land Act Dam",
        ['LEGSQU'] = "Legion Square",
        ['LMESA'] = "La Mesa",
        ['LOSPUER'] = "La Puerta",
        ['MIRR'] = "Mirror Park",
        ['MORN'] = "Morningwood",
        ['MOVIE'] = "Richards Majestic",
        ['MTCHIL'] = "Mount Chiliad",
        ['MTGORDO'] = "Mount Gordo",
        ['MTJOSE'] = "Mount Josiah",
        ['MURRI'] = "Murrieta Heights",
        ['NCHU'] = "North Chumash",
        ['NOOSE'] = "N.O.O.S.E",
        ['OCEANA'] = "Pacific Ocean",
        ['PALCOV'] = "Paleto Cove",
        ['PALETO'] = "Paleto Bay",
        ['PALFOR'] = "Paleto Forest",
        ['PALHIGH'] = "Palomino Highlands",
        ['PALMPOW'] = "Palmer-Taylor Power Station",
        ['PBLUFF'] = "Pacific Bluffs",
        ['PBOX'] = "Pillbox Hill",
        ['PROCOB'] = "Procopio Beach",
        ['RANCHO'] = "Rancho",
        ['RGLEN'] = "Richman Glen",
        ['RICHM'] = "Richman",
        ['ROCKF'] = "Rockford Hills",
        ['RTRAK'] = "Redwood Lights Track",
        ['SANAND'] = "San Andreas",
        ['SANCHIA'] = "San Chianski Mountain Range",
        ['SANDY'] = "Sandy Shores",
        ['SKID'] = "Mission Row",
        ['SLAB'] = "Stab City",
        ['STAD'] = "Maze Bank Arena",
        ['STRAW'] = "Strawberry",
        ['TATAMO'] = "Tataviam Mountains",
        ['TERMINA'] = "Terminal",
        ['TEXTI'] = "Textile City",
        ['TONGVAH'] = "Tongva Hills",
        ['TONGVAV'] = "Tongva Valley",
        ['VCANA'] = "Vespucci Canals",
        ['VESP'] = "Vespucci",
        ['VINE'] = "Vinewood",
        ['WINDF'] = "Ron Alternates Wind Farm",
        ['WVINE'] = "West Vinewood",
        ['ZANCUDO'] = "Zancudo River",
        ['ZP_ORT'] = "Port of South Los Santos",
        ['ZQ_UAR'] = "Davis Quartz"
    },
    
    -- Control keys
    beltKey = 29,              -- B key
    cruiseControlKey = 137,    -- CAPS LOCK
    
    -- Seatbelt physics
    beltEjectSpeed = 45.0,     -- Speed in mph for ejection
    beltEjectForce = 100.0,    -- Force multiplier for ejection
    
    -- Vehicle classes that have seatbelts
    beltClasses = {
        [0] = true,   -- Compacts
        [1] = true,   -- Sedans
        [2] = true,   -- SUVs
        [3] = true,   -- Coupes
        [4] = true,   -- Muscle
        [5] = true,   -- Sports Classics
        [6] = true,   -- Sports
        [7] = true,   -- Super
        [8] = false,  -- Motorcycles
        [9] = true,   -- Off-road
        [10] = true,  -- Industrial
        [11] = true,  -- Utility
        [12] = true,  -- Vans
        [13] = false, -- Cycles
        [14] = false, -- Boats
        [15] = false, -- Helicopters
        [16] = false, -- Planes
        [17] = true,  -- Service
        [18] = true,  -- Emergency
        [19] = true,  -- Military
    }
}
```

## 🎮 Controls

| Key | Function |
|-----|----------|
| **B** | Toggle seatbelt |
| **CAPS LOCK** | Toggle cruise control |

## 🎨 Customization

### Changing HUD Position

Edit the CSS values in `style.css`:

- `.hud-container` - Main HUD container position (left/bottom)
- `.location-display` - Location text position
- `.speed-display` - Speed display positioning

### Color Customization

- **Fuel gauge color** - Change `#FE6F27` in CSS
- **Low fuel warning** - Change `#c20000`/`#ff2d2d`
- **Active seatbelt** - Change `#ffce00` in JavaScript

## 🔧 Advanced Settings

### Acceleration Multipliers

In `client/main.lua`, you can adjust the realistic acceleration settings:

```lua
local torqueMult = 0.45   -- 0.3-0.6 range: lower = slower initial acceleration
local powerMult = 0.70    -- 0.5-1.0 range: lower = slower overall acceleration
local maxSpeedKmh = nil   -- Set to limit top speed (e.g., 180)
```

## 📁 File Structure

```
takenncs-carhud/
├── fxmanifest.lua
├── config.lua
├── client/
│   └── main.lua
├── server/
│   └── main.lua
├── html/
│   ├── index.html
│   ├── style.css
│   ├── script.js
│   ├── Gilroy-ExtraBold.otf
│   └── WorkSans-SemiBold.ttf
└── README.md
```

## 🌍 Language Support

The HUD displays:
- Speed in KMH
- Street names in English
- Cardinal directions (N, NE, E, SE, S, SW, W, NW)
- Zone names in English

## ⚠️ Notes

- Seatbelt physics effect is currently disabled (only visual indicator works)
- Cruise control automatically disables when exiting vehicle
- Fuel system works with cdn-fuel by default, falls back to native GTA fuel if not present

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👤 Author

**takenncs**

## 🙏 Acknowledgments

- [cdn-fuel](https://github.com/CodineDev/cdn-fuel) for fuel system integration
- Font Awesome for icons
- DS-Digital font for speed display
```
