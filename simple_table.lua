--[[
	Mod Craft Table for Minetest
	Copyright (C) 2019 BrunoMine (https://github.com/BrunoMine)
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <https://www.gnu.org/licenses/>.
	
	Simple craft table
  ]]

-- Craft Table
minetest.register_node("craft_table:simple", {
	description = "Craft Table",
	tiles = {"craft_table_top.png", "default_wood.png", "craft_table_side.png",
		"craft_table_side.png", "craft_table_side.png", "craft_table_front.png"},
	paramtype2 = "facedir",
	groups = {choppy=2,oddly_breakable_by_hand=2},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),
	on_rightclick = craft_table.on_rightclick,
})

-- Change recipes from other mods
if minetest.registered_nodes["xdecor:workbench"] then
	-- Remove old recipe
	minetest.clear_craft({output = 'xdecor:workbench'})
	-- Register new recipe
	minetest.register_craft({ 
		output = 'xdecor:workbench',
		recipe = {
			{'', 'group:wood', ''},
			{'default:steel_ingot', 'craft_table:craft_table', 'default:steel_ingot'},
			{'', 'group:wood', ''},
		}
	})
end

-- Craft Table recipe (classic from MC)
minetest.register_craft({ 
	output = 'craft_table:simple',
	recipe = {
		{'group:wood', 'group:wood'},
		{'group:wood', 'group:wood'},
	}
})
