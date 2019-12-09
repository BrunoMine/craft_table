--[[
	Mod Craft Table for Minetest
	Copyright (C) 2019 BrunoMine (https://github.com/BrunoMine)
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <https://www.gnu.org/licenses/>.
	
  ]]

-- Global index
craft_table = {}

-- simple craft grid for players
craft_table.simple_craft_grid = minetest.settings:get("craft_table_2x2_craft_grid_to_players")
if craft_table.simple_craft_grid == "false" then
	craft_table.simple_craft_grid = false
else
	craft_table.simple_craft_grid = true
end


local modpath = core.get_modpath("craft_table")

-- API
dofile(modpath .."/api.lua")

-- Craft tables
dofile(modpath .."/simple_table.lua")

