--[[
	Mod Craft Table for Minetest
	Copyright (C) 2019 BrunoMine (https://github.com/BrunoMine)
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <https://www.gnu.org/licenses/>.
	
  ]]

-- simple craft grid for players
local simple_craft_grid = minetest.settings:get("craft_table_2x2_craft_grid_to_players")
if simple_craft_grid == "false" then
	simple_craft_grid = false
else
	simple_craft_grid = true
end

-- Drop residual items from craft list
local function drop_craft(player, pos) 
	local invref = player:get_inventory()
	if not pos then pos = player:getpos() end
	local size = invref:get_size("craft")
	for i = 1, size do
		local item = invref:get_stack("craft", i)
		if item ~= nil then 
			minetest.env:add_item({x = pos.x + (((math.random(1, 70)/100)-0.35)), y = pos.y+1, z = pos.z + (((math.random(1, 70)/100)-0.35))}, item)
		end
		invref:set_stack("craft", i, "")
	end
	
end

-- Formspec for craft table
local craft_table_form = 
	"size[8,8.3]"..
	default.gui_bg..
	default.gui_bg_img..
	default.gui_slots..
	"list[current_player;main;0,4.25;8,1;]"..
	"list[current_player;main;0,5.5;8,3;8]"..
	"list[current_player;craft;1.75,0.5;3,3;]"..
	"image[4.85,1.45;1,1;gui_furnace_arrow_bg.png^[transformR270]"..
	"list[current_player;craftpreview;5.75,1.5;1,1;]"..
	default.get_hotbar_bg(0,4.25)

-- Craft Table
minetest.register_node("craft_table:craft_table", {
	description = "Craft Table",
	tiles = {"craft_table_top.png", "default_wood.png", "craft_table_side.png",
		"craft_table_side.png", "craft_table_side.png", "craft_table_front.png"},
	paramtype2 = "facedir",
	groups = {choppy=2,oddly_breakable_by_hand=2},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),
	on_rightclick = function(pos, node, player)
		local meta = player:get_meta()
		meta:set_string("craft_table:craft_table_pos", minetest.serialize(pos))
		minetest.show_formspec(player:get_player_name(), "craft_table:craft_table", craft_table_form)
	end,
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
	output = 'craft_table:craft_table',
	recipe = {
		{'group:wood', 'group:wood'},
		{'group:wood', 'group:wood'},
	}
})

-- Clear metadata when exit from craft table formspec
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "craft_table:craft_table" and fields.quit then
		local meta = player:get_meta()
		drop_craft(player, minetest.deserialize(meta:get_string("craft_table:craft_table_pos")))
		meta:set_string("craft_table:craft_table_pos", "")
	end
end)

-- Modify default inventory
if sfinv then
	local override_table = {}
	
	-- Change default craft grid from sfinv inventory to 2x2
	if simple_craft_grid == true then
		override_table.get = function(self, player, context)
			drop_craft(player, player:getpos())
			return sfinv.make_formspec(player, context, [[
				list[current_player;craft;2,1;2,1;1]
				list[current_player;craft;2,2;2,1;4]
				list[current_player;craftpreview;5,1.5;1,1;]
				image[4,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]
				listring[current_player;main]
				listring[current_player;craft]
				image[0,4.7;1,1;gui_hb_bg.png]
				image[1,4.7;1,1;gui_hb_bg.png]
				image[2,4.7;1,1;gui_hb_bg.png]
				image[3,4.7;1,1;gui_hb_bg.png]
				image[4,4.7;1,1;gui_hb_bg.png]
				image[5,4.7;1,1;gui_hb_bg.png]
				image[6,4.7;1,1;gui_hb_bg.png]
				image[7,4.7;1,1;gui_hb_bg.png]
			]], true)
		end
	end
	
	-- Drop crafting items if not in crafting page
	override_table.on_leave = function(self, player, context)
		drop_craft(player, player:getpos())
	end
	override_table.on_player_receive_fields = function(self, player, context, fields)
		if fields.quit then
			drop_craft(player, player:getpos())
		end
	end
	
	sfinv.override_page("sfinv:crafting", override_table)
end
