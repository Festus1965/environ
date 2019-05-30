-- Environ init.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)

environ = {}
local mod, mod_name = environ, 'environ'
mod.version = '20190524'
mod.path = minetest.get_modpath(minetest.get_current_modname())
mod.world = minetest.get_worldpath()


function mod.clone_node(name)
	if not (name and type(name) == 'string') then
		return
	end
	if not minetest.registered_nodes[name] then
		return
	end

	local nod = minetest.registered_nodes[name]
	local node2 = table.copy(nod)
	return node2
end
local clone_node = mod.clone_node


if false then
	local name = 'test_deco'
	local seed = 20
	local def = {
		deco_type = 'simple',
		place_on = {'default:stone'},
		sidelen = 16,
		noise_params = {
			offset = 0.015,
			scale = 0.025,
			spread = {x = 200, y = 200, z = 200},
			seed = seed,
			octaves = 3,
			persist = 0.6
		},
		--biomes = {'rainforest', 'rainforest_swamp'},
		--y_min = 1,
		--y_max = 31000,
		--decoration = mod_name..':'..name,
		decoration = 'default:meselamp',
		name = name,
		flags = 'all_floors,all_ceilings',
	}
	minetest.register_decoration(def)
end


do
	local cap = {
	  description = 'Giant Mushroom Cap',
	  tiles = {'vmg_mushroom_giant_cap.png', 'vmg_mushroom_giant_under.png', 'vmg_mushroom_giant_cap.png'},
	  is_ground_content = false,
	  paramtype = 'light',
	  drawtype = 'nodebox',
	  node_box = { type = 'fixed', 
	  fixed = {
		{-0.3, -0.25, -0.3, 0.3, 0.5, 0.3},
		{-0.3, -0.25, -0.4, 0.3, 0.4, -0.3},
		{-0.3, -0.25, 0.3, 0.3, 0.4, 0.4},
		{-0.4, -0.25, -0.3, -0.3, 0.4, 0.3},
		{0.3, -0.25, -0.3, 0.4, 0.4, 0.3},
		{-0.4, -0.5, -0.4, 0.4, -0.25, 0.4},
		{-0.5, -0.5, -0.4, -0.4, -0.25, 0.4},
		{0.4, -0.5, -0.4, 0.5, -0.25, 0.4},
		{-0.4, -0.5, -0.5, 0.4, -0.25, -0.4},
		{-0.4, -0.5, 0.4, 0.4, -0.25, 0.5},
	  } },
	  light_source = 3,
	  groups = {fleshy=1, dig_immediate=3, flammable=2, plant=1},
	}
	minetest.register_node(mod_name..':giant_mushroom_cap', cap)

	-- mushroom cap, huge
	minetest.register_node(mod_name..':huge_mushroom_cap', {
	  description = 'Huge Mushroom Cap',
	  tiles = {'vmg_mushroom_giant_cap.png', 'vmg_mushroom_giant_under.png', 'vmg_mushroom_giant_cap.png'},
	  is_ground_content = false,
	  paramtype = 'light',
	  drawtype = 'nodebox',
	  node_box = { type = 'fixed', 
	  fixed = {
		{-0.5, -0.5, -0.33, 0.5, -0.33, 0.33}, 
		{-0.33, -0.5, 0.33, 0.33, -0.33, 0.5}, 
		{-0.33, -0.5, -0.33, 0.33, -0.33, -0.5}, 
		{-0.33, -0.33, -0.33, 0.33, -0.17, 0.33}, 
	  } },
	  light_source = 2,
	  groups = {fleshy=1, dig_immediate=3, flammable=2, plant=1},
	})

	-- mushroom stem, giant or huge
	minetest.register_node(mod_name..':giant_mushroom_stem', {
	  description = 'Giant Mushroom Stem',
	  tiles = {'vmg_mushroom_giant_stem.png', 'vmg_mushroom_giant_stem.png', 'vmg_mushroom_giant_stem.png'},
	  is_ground_content = false,
	  groups = {choppy=2, flammable=2,  plant=1}, 
	  sounds = default.node_sound_wood_defaults(),
	  sunlight_propagates = true,
	  paramtype = 'light',
	  drawtype = 'nodebox',
	  node_box = { type = 'fixed', fixed = { {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25}, }},
	})

	local huge_mushroom_sch = {
		size = { x=1, y=3, z=1 },
		data = {
			{ name = 'default:dirt', force_place = true, },
			{ name = mod_name..':giant_mushroom_stem', },
			{ name = mod_name..':huge_mushroom_cap', },
		},
	}

	local giant_mushroom_sch = {
		size = { x=1, y=4, z=1 },
		data = {
			{ name = 'default:dirt', force_place = true, },
			{ name = mod_name..':giant_mushroom_stem', },
			{ name = mod_name..':giant_mushroom_stem', },
			{ name = mod_name..':giant_mushroom_cap', },
		},
	}

	local name = 'huge_mushroom'
	local seed = 30
	local def = {
		deco_type = 'schematic',
		place_on = {'default:stone'},
		height_max = 6,
		sidelen = 16,
		noise_params = {
			offset = 0.015,
			scale = 0.025,
			spread = {x = 200, y = 200, z = 200},
			seed = seed,
			octaves = 3,
			persist = 0.6
		},
		--biomes = {'rainforest', 'rainforest_swamp'},
		y_max = -20,
		schematic = huge_mushroom_sch,
		name = name,
		flags = 'all_floors',
	}
	minetest.register_decoration(def)

	local name = 'giant_mushroom'
	local seed = 20
	local def = {
		deco_type = 'schematic',
		place_on = {'default:stone'},
		height_max = 6,
		sidelen = 16,
		noise_params = {
			offset = 0.010,
			scale = 0.025,
			spread = {x = 200, y = 200, z = 200},
			seed = seed,
			octaves = 3,
			persist = 0.6
		},
		--biomes = {'rainforest', 'rainforest_swamp'},
		y_max = -20,
		schematic = giant_mushroom_sch,
		name = name,
		flags = 'all_floors',
	}
	minetest.register_decoration(def)

	minetest.register_node(mod_name..':glow_worm', {
		description = 'Glow worm',
		tiles = {'glow_worm.png'},
		selection_box = {
			type = 'fixed',
			fixed = {
				{ 0.1, -0.5, 0.1, -0.1, 0.5, -0.1, },
			},
		},
		color = '#DDEEFF',
		use_texture_alpha = true,
		light_source = 3,
		paramtype2 = 'facedir',
		walkable = false,
		groups = {oddly_breakable_by_hand=1, dig_immediate=2},
		drawtype = 'plantlike',
	})


	local name = 'glow_worm'
	local seed = 20
	local def = {
		deco_type = 'simple',
		place_on = {'default:stone'},
		height_max = 6,
		sidelen = 16,
		noise_params = {
			offset = 0.015,
			scale = 0.025,
			spread = {x = 200, y = 200, z = 200},
			seed = seed,
			octaves = 3,
			persist = 0.6
		},
		--biomes = {'rainforest', 'rainforest_swamp'},
		--y_max = 1,
		decoration = mod_name..':'..name,
		name = name,
		flags = 'all_ceilings',
	}
	minetest.register_decoration(def)
end


do
	newnode = clone_node('default:apple')
	newnode.tiles = {'squaresville_orange.png'}
	newnode.inventory_image = 'squaresville_orange.png'
	newnode.description = 'Orange'
	newnode.name = mod_name..':orange'
	minetest.register_node(newnode.name, newnode)


	newnode = clone_node('default:apple')
	newnode.tiles = {'squaresville_pear.png'}
	newnode.inventory_image = 'squaresville_pear.png'
	newnode.description = 'Pear'
	newnode.name = mod_name..':pear'
	minetest.register_node(newnode.name, newnode)


	for _, leaf in pairs({'default:leaves', 'default:pine_needles', 'default:jungleleaves'}) do
		local num = 1
		for _, color in pairs({'FFCCCC', 'FFFFCC', 'CCFFCC'}) do
			newnode = clone_node(leaf)
			newnode.color = '#'..color
			local new_leaf_name = leaf:gsub('default', mod_name) .. '_alt_' .. num
			minetest.register_node(new_leaf_name, newnode)
			num = num + 1
		end
	end


	newnode = clone_node('default:leaves')
	newnode.description = 'Cherry Blossoms'
	newnode.tiles = {'squaresville_leaves_cherry.png'}
	newnode.special_tiles = {'squaresville_leaves_cherry.png'}
	newnode.groups = {snappy = 3, flammable = 2}
	minetest.register_node(mod_name..':leaves_cherry', newnode)

	newnode = clone_node('default:leaves')
	newnode.description = 'Palm Fronds'
	newnode.tiles = {'moretrees_palm_leaves.png'}
	newnode.special_tiles = {'moretrees_palm_leaves.png'}
	minetest.register_node(mod_name..':palm_leaves', newnode)

	newnode = clone_node('default:tree')
	newnode.description = 'Palm Tree'
	newnode.tiles = {'moretrees_palm_trunk_top.png', 'moretrees_palm_trunk_top.png', 'moretrees_palm_trunk.png', 'moretrees_palm_trunk.png', 'moretrees_palm_trunk.png'}
	newnode.special_tiles = {'moretrees_palm_trunk.png'}
	minetest.register_node(mod_name..':palm_tree', newnode)

	minetest.register_craft({
		output = 'default:wood 4',
		recipe = {
			{mod_name..':palm_tree'},
		}
	})

	--newnode = clone_node('default:apple')
	--newnode.description = 'Coconut'
	--newnode.tiles = {'moretrees_coconut.png'}
	--newnode.inventory_image = 'moretrees_coconut.png'
	--newnode.after_place_node = nil
	--minetest.register_node(mod_name..':coconut', newnode)
end


function new_mts(mts, nmts, opath, npath, replace)
	local f = io.open(opath..'/'..mts, 'r')
	if f then
		f:close()

		local sch = minetest.serialize_schematic(opath..'/'..mts, 'lua', {})
		for _, rep in pairs(replace) do
			sch = sch:gsub(rep[1], rep[2])
		end
		sch = minetest.deserialize('return {'..sch..'}')
		local out = minetest.serialize_schematic(sch.schematic, 'mts', {})
		f = io.open(mod.world..'/'..nmts, 'w')
		if f then
			f:write(out)
			f:close()
			return true
		end
	else
		print(mod_name .. ': ** Error opening: '..mts)
	end
end


-- Create the mts files.
if false then
	local targ = {
		'apple_tree.mts',
		'pine_tree.mts',
		'jungle_tree.mts',
	}
	local fruit = {
		mod_name..':orange',
		mod_name..':pear',
		mod_name..':leaves_alt_3',
	}

	local opath = '/usr/share/minetest/games/minetest_game/mods/default/schematics'
	local npath = mod.path..'/schematics'
	for _, mts in pairs(targ) do
		for i = 1, 3 do
			local nmts = mts:gsub('(.+)(%.mts)', '%1_alt_'..i..'%2')
			local replace = {
				{'default:leaves', mod_name..':leaves_alt_'..i},
				{'default:pine_needles', mod_name..':pine_needles_alt_'..i},
				{'default:jungleleaves', mod_name..':jungleleaves_alt_'..i},
				{'default:apple', fruit[i]},
			}
			new_mts(mts, nmts, opath, npath, replace)
		end
	end

	do
		local mts = 'apple_tree.mts'
		local nmts = 'cherry_tree.mts'
		local replace = {
			{'default:leaves', mod_name..':leaves_cherry'},
			{'default:apple', mod_name..':leaves_cherry'},
		}
		new_mts(mts, nmts, opath, npath, replace)
	end
end


do
	local pine_deco, apple_deco, jungle_deco

	local decos = {}
	for k, v in pairs(minetest.registered_decorations) do
		local name = v.name or v.decoration
		decos[#decos+1] = v

		-- Change the spawn rate of each tree, since
		--  it's going to have lots of company.
		if v and name:find(':pine_tree') then
			v.noise_params.offset = v.noise_params.offset - 0.013
			pine_deco = v
		end
		if v and name:find(':jungle_tree') then
			v.fill_ratio = v.fill_ratio / 4
			jungle_deco = v
		end
		if v and name:find(':apple_tree') then
			v.noise_params.offset = v.noise_params.offset - 0.013
			apple_deco = v
		end
	end

	-- This is the only way to change existing decorations.
	minetest.clear_registered_decorations()
	for k, v in pairs(decos) do
		minetest.register_decoration(v)
	end


	for i = 1, 3 do
		local def = table.copy(apple_deco)
		def.noise_params.seed = math.random(500)
		def.schematic = mod.path..'/schematics/'..def.schematic:gsub('(.-)/([%a%d_]+)(%.mts)', '%2_alt_'..i..'%3')
		def.name = mod_name..':apple_tree_'..i
		minetest.register_decoration(def)
	end

	for i = 1, 3 do
		local def = table.copy(pine_deco)
		def.noise_params.seed = math.random(500)
		def.schematic = mod.path..'/schematics/'..def.schematic:gsub('(.-)/([%a%d_]+)(%.mts)', '%2_alt_'..i..'%3')
		def.name = mod_name..':pine_tree_'..i
		minetest.register_decoration(def)
	end

	for i = 1, 3 do
		local def = table.copy(jungle_deco)
		def.schematic = mod.path..'/schematics/'..def.schematic:gsub('(.-)/([%a%d_]+)(%.mts)', '%2_alt_'..i..'%3')
		def.name = mod_name..':jungle_tree_'..i
		minetest.register_decoration(def)
	end

	do
		local def = table.copy(apple_deco)
		def.noise_params.seed = math.random(500)
		def.noise_params.offset = def.noise_params.offset - 0.005
		def.schematic = mod.path..'/schematics/cherry_tree.mts'
		def.name = mod_name..':cherry_tree_'
		minetest.register_decoration(def)
	end

	--[[
	-- Palm tree
	do
		local d, h, w = 5, 7, 5
		local sch = mod.schematic_array(d, h, w)

		for i = 1, 2 do
			for z = -1, 1 do
				for x = -1, 1 do
					if (x ~= 0) == not (z ~= 0) then
						local n = sch.data[(2 + (z * i)) * h * w + (7 - i) * w + (2 + (x * i)) + 1]
						n.name = mod_name .. ':palm_leaves'
						n.prob = 127
					end
				end
			end
		end

		for i = 0, 3 do
			local n = sch.data[1 * h * w + i * w + 2 + 1]
			n.name = mod_name .. ':palm_tree'
			n.prob = 255
		end

		for i = 4, 5 do
			local n = sch.data[2 * h * w + i * w + 2 + 1]
			n.name = mod_name .. ':palm_tree'
			n.prob = 255
		end

		sch.yslice_prob = {
			{ypos = 1, prob = 128},
			{ypos = 4, prob = 128},
		}

		minetest.register_decoration({
			deco_type = 'schematic',
			place_on = {'default:sand'},
			sidelen = 16,
			fill_ratio = 0.02,
			biomes = {'desert_ocean'},
			y_min = 1,
			y_max = 1,
			schematic = sch,
			flags = 'place_center_x, place_center_z',
			rotation = 'random',
		})
	end

	--rereg = nil
	--]]
end


local function register_flower(name, desc, biomes, seed)
	local groups = {}
	groups.snappy = 3
	groups.flammable = 2
	groups.flower = 1
	groups.flora = 1
	groups.attached_node = 1

	minetest.register_node(mod_name..":" .. name, {
		description = desc,
		drawtype = "plantlike",
		waving = 1,
		tiles = {name .. ".png"},
		inventory_image = name .. ".png",
		wield_image = name .. ".png",
		sunlight_propagates = true,
		paramtype = "light",
		walkable = false,
		buildable_to = true,
		stack_max = 99,
		groups = groups,
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
		}
	})

	local bi = {}
	if biomes then
		bi = {}
		for _, b in pairs(biomes) do
			bi[b] = true
		end
	end

	if bi['rainforest'] then
		local def = {
			deco_type = "simple",
			place_on = {'default:dirt_with_rainforest_litter'},
			sidelen = 16,
			noise_params = {
				offset = 0.015,
				scale = 0.025,
				spread = {x = 200, y = 200, z = 200},
				seed = seed,
				octaves = 3,
				persist = 0.6
			},
			biomes = {'rainforest', 'rainforest_swamp'},
			y_min = 1,
			y_max = 31000,
			decoration = mod_name..":"..name,
			name = name,
			flower = true,
		}
		minetest.register_decoration(def)
	else
		local def = {
			deco_type = "simple",
			place_on = {"default:dirt_with_grass", "default:dirt_with_dry_grass", 'default:dirt_with_rainforest_litter'},
			sidelen = 16,
			noise_params = {
				offset = -0.015,
				scale = 0.025,
				spread = {x = 200, y = 200, z = 200},
				seed = seed,
				octaves = 3,
				persist = 0.6
			},
			biomes = biomes,
			y_min = 1,
			y_max = 31000,
			decoration = mod_name..":"..name,
			name = name,
			flower = true,
		}
		minetest.register_decoration(def)
	end
end

register_flower("orchid", "Orchid", {"rainforest", "rainforest_swamp"}, 783)
register_flower("bird_of_paradise", "Bird of Paradise", {"rainforest"}, 798)
register_flower("gerbera", "Gerbera", {"savanna", "rainforest"}, 911)
