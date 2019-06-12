-- Environ init.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)

environ = { }
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


dofile(mod.path..'/nodes.lua')


minetest.clear_craft({
	recipe = {
		{"default:copper_ingot", "default:copper_ingot", "default:copper_ingot"},
		{"default:copper_ingot", "default:tin_ingot", "default:copper_ingot"},
		{"default:copper_ingot", "default:copper_ingot", "default:copper_ingot"},
	}
})
minetest.register_craft({
	type = 'shapeless',
	output = 'default:bronze_ingot',
	recipe = {
		'default:tin_ingot',
		'default:copper_ingot',
	},
})


local singl = (minetest.get_mapgen_setting('mg_name') == 'singlenode')
local function register_biome(def)
	if not singl then
		def.node_stone = (def.node_lining or def.node_ceiling or def.node_stone or nil)
	end

	minetest.register_biome(def)
end


do
	local rep = {
		--[[
		['rainforest_ocean'] = {
			node_stone = mod_name..':stone_with_algae',
		},
		['deciduous_forest_ocean'] = {
			node_stone = mod_name..':stone_with_lichen',
		},
		['coniferous_forest_ocean'] = {
			node_stone = mod_name..':stone_with_moss',
		},
		['desert_ocean'] = {
			node_stone = mod_name..':basalt',
		},
		['cold_desert_ocean'] = {
			node_stone = mod_name..':granite',
		},
		--]]
	}

	local bio = {}
	for n, d in pairs(minetest.registered_biomes) do
		local b = table.copy(d)
		for k, v in pairs(rep[n] or {}) do
			b[k] = v
		end
		bio[n] = b
	end
	minetest.clear_registered_biomes()
	for n, v in pairs(bio) do
		if n ~= 'underground' then
			minetest.register_biome(v)
		end
	end

	--[[
    register_biome({
        name = 'stone',
		y_max = -20,
		y_min = -31000,
        heat_point = 30,
        humidity_point = 50,
    })

    register_biome({
        name = 'wet_stone',
		y_max = -20,
		y_min = -31000,
        node_cave_liquid = 'default:water_source',
        heat_point = 100,
        humidity_point = 100,
    })

    register_biome({
        name = 'sea_cave',
		y_max = -20,
		y_min = -31000,
        node_gas = 'default:water_source',
        heat_point = 50,
        humidity_point = 115,
    })

    register_biome({
        name = 'lichen',
        node_lining = 'environ:stone_with_lichen',
		y_max = -20,
		y_min = -31000,
        heat_point = 15,
        humidity_point = 20,
    })

    register_biome({
        name = 'algae',
        node_lining = 'environ:stone_with_algae',
        node_cave_liquid = 'default:water_source',
		y_max = -20,
		y_min = -31000,
        heat_point = 65,
        humidity_point = 75,
    })

    register_biome({
        name = 'mossy',
        node_lining = 'environ:stone_with_moss',
        node_cave_liquid = 'default:water_source',
		y_max = -20,
		y_min = -31000,
        heat_point = 25,
        humidity_point = 75,
    })

    register_biome({
        name = 'granite_lava',
        node_stone = mod_name..':granite',
        node_cave_liquid = 'default:lava_source',
		y_max = -20,
		y_min = -31000,
        heat_point = 105,
        humidity_point = 70,
    })

    register_biome({
        name = 'salt',
        node_lining = mod_name..':stone_with_salt',
		surface_depth = 2,
		y_max = -20,
		y_min = -31000,
        heat_point = 50,
        humidity_point = -5,
    })

    register_biome({
        name = 'basalt',
        node_lining = mod_name..':basalt',
		y_max = -20,
		y_min = -31000,
        heat_point = 60,
        humidity_point = 50,
    })

    register_biome({
        name = 'sand',
        node_ceiling = 'default:sandstone',
        node_floor = 'default:sand',
		surface_depth = 2,
		y_max = -20,
		y_min = -31000,
        heat_point = 70,
        humidity_point = 25,
    })

    register_biome({
        name = 'coal',
        node_lining = mod_name..':black_sand',
		stone_type = mod_name..':basalt',
		surface_depth = 2,
		y_max = -20,
		y_min = -31000,
        heat_point = 110,
        humidity_point = 0,
    })
	--]]

    register_biome({
        name = 'hot',
        node_floor = mod_name..':hot_rock',
		stone_type = mod_name..':granite',
        node_cave_liquid = 'default:lava_source',
		y_max = -20,
		y_min = -31000,
        heat_point = 120,
        humidity_point = 35,
    })

    register_biome({
		--deco = mod_name..':will_o_wisp_glow',
        name = 'ice',
        node_lining = 'default:ice',
		surface_depth = 4,
		y_max = -20,
		y_min = -31000,
        heat_point = -15,
        humidity_point = 50,
    })
end


do
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

	minetest.register_decoration({
		deco_type = 'schematic',
		place_on = { 'group:natural_stone', },
		sidelen = 16,
		noise_params = {
			offset = 0.015,
			scale = 0.025,
			spread = { x = 200, y = 200, z = 200 },
			seed = 30,
			octaves = 3,
			persist = 0.6
		},
		biomes = { 'stone', 'algae', 'lichen', },
		schematic = huge_mushroom_sch,
		name = 'huge_mushroom',
		flags = 'all_floors',
	})

	minetest.register_decoration({
		deco_type = 'schematic',
		place_on = { 'group:natural_stone', },
		sidelen = 16,
		noise_params = {
			offset = 0.010,
			scale = 0.025,
			spread = { x = 200, y = 200, z = 200 },
			seed = 20,
			octaves = 3,
			persist = 0.6
		},
		biomes = { 'stone', 'algae', 'lichen', },
		schematic = giant_mushroom_sch,
		name = 'giant_mushroom',
		flags = 'all_floors',
	})

	minetest.register_node(mod_name..':glow_worm', {
		description = 'Glow worm',
		tiles = { 'environ_glow_worm.png' },
		selection_box = {
			type = 'fixed',
			fixed = {
				{ 0.1, -0.5, 0.1, -0.1, 0.5, -0.1, },
			},
		},
		color = '#DDEEFF',
		use_texture_alpha = true,
		light_source = 6,
		paramtype2 = 'facedir',
		walkable = false,
		groups = { oddly_breakable_by_hand=1, dig_immediate=2 },
		drawtype = 'plantlike',
	})

	minetest.register_decoration({
		deco_type = 'simple',
		place_on = { 'group:natural_stone', },
		height_max = 6,
		sidelen = 16,
		noise_params = {
			offset = 0.015,
			scale = 0.025,
			spread = { x = 200, y = 200, z = 200 },
			seed = 52,
			octaves = 3,
			persist = 0.6
		},
		biomes = { 'stone', 'algae', 'lichen', },
		decoration = mod_name..':glow_worm',
		name = 'glow_worm',
		flags = 'all_ceilings',
	})

	minetest.register_decoration({
		deco_type = 'simple',
		place_on = { 'group:natural_stone', },
		sidelen = 16,
		noise_params = {
			offset = 0.015,
			scale = 0.025,
			spread = { x = 200, y = 200, z = 200 },
			seed = -18,
			octaves = 3,
			persist = 0.6
		},
		biomes = { 'sea_cave', 'wet_stone', 'moss', },
		decoration = mod_name..':glowing_fungal_stone',
		place_offset_y = -1,
		name = 'glowing_fungal_stone',
		flags = 'all_ceilings, all_floors',
	})

	minetest.register_decoration({
		deco_type = 'simple',
		place_on = { 'group:sand', },
		sidelen = 16,
		noise_params = {
			offset = 0.015,
			scale = 0.025,
			spread = { x = 200, y = 200, z = 200 },
			seed = -17,
			octaves = 3,
			persist = 0.6
		},
		biomes = { 'sand', 'sandstone', },
		decoration = mod_name..':glowing_gem',
		name = 'glowing_gem',
		flags = 'all_floors',
	})

	minetest.register_decoration({
		deco_type = 'simple',
		place_on = { 'group:natural_stone', },
		sidelen = 16,
		noise_params = {
			offset = 0.025,
			scale = 0.025,
			spread = { x = 200, y = 200, z = 200 },
			seed = -10,
			octaves = 3,
			persist = 0.6
		},
		biomes = { 'sea_cave', },
		decoration = mod_name..':glowing_fungal_stone',
		place_offset_y = -1,
		name = 'glowing_fungal_stone_wet',
		flags = 'all_ceilings, all_floors, aquatic',
	})

	minetest.register_decoration({
		deco_type = 'simple',
		place_on = { mod_name..':granite', mod_name..':basalt', },
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.02,
			spread = { x = 200, y = 200, z = 200 },
			seed = -13,
			octaves = 3,
			persist = 0.6
		},
		biomes = { 'granite_lava', 'basalt_lava', },
		decoration = 'default:lava_source',
		name = 'lava_flow',
		place_offset_y = -1,  -- This fails in C.
		flags = 'all_ceilings',
	})

	minetest.register_decoration({
		deco_type = 'simple',
		place_on = { mod_name..':black_sand', },
		sidelen = 16,
		noise_params = {
			offset = 0.02,
			scale = 0.04,
			spread = { x = 200, y = 200, z = 200 },
			seed = -70,
			octaves = 3,
			persist = 0.6
		},
		biomes = { 'coal', },
		decoration = 'fire:permanent_flame',
		name = 'Gas Flame',
		flags = 'all_floors',
	})

	minetest.register_decoration({
		deco_type = 'simple',
		place_on = { mod_name..':black_sand', },
		sidelen = 16,
		fill_ratio = 0.04,
		place_offset_y = -1,
		biomes = { 'coal', },
		decoration = 'default:coalblock',
		name = 'Coal Seam',
		flags = 'all_floors, all_ceilings',
	})

	minetest.register_decoration({
		deco_type = 'simple',
		place_on = { mod_name..':hot_rock', },
		sidelen = 16,
		fill_ratio = 0.04,
		biomes = { 'hot', },
		decoration = {
			mod_name..':hot_spike',
			mod_name..':hot_spike_2',
			mod_name..':hot_spike_3',
			mod_name..':hot_spike_4',
			mod_name..':hot_spike_5',
		},
		name = 'Hot Spike',
		flags = 'all_floors',
	})
end


do
	newnode = clone_node('default:apple')
	newnode.tiles = { 'environ_orange.png' }
	newnode.inventory_image = 'environ_orange.png'
	newnode.description = 'Orange'
	newnode.name = mod_name..':orange'
	minetest.register_node(newnode.name, newnode)


	newnode = clone_node('default:apple')
	newnode.tiles = { 'environ_pear.png' }
	newnode.inventory_image = 'environ_pear.png'
	newnode.description = 'Pear'
	newnode.name = mod_name..':pear'
	minetest.register_node(newnode.name, newnode)


	for _, leaf in pairs({ 'default:leaves', 'default:pine_needles', 'default:jungleleaves' }) do
		local num = 1
		for _, color in pairs({ 'FFCCCC', 'FFFFCC', 'CCFFCC' }) do
			newnode = clone_node(leaf)
			newnode.color = '#'..color
			local new_leaf_name = leaf:gsub('default', mod_name) .. '_alt_' .. num
			minetest.register_node(new_leaf_name, newnode)
			num = num + 1
		end
	end


	newnode = clone_node('default:leaves')
	newnode.description = 'Cherry Blossoms'
	newnode.tiles = { 'environ_leaves_cherry.png' }
	newnode.special_tiles = { 'environ_leaves_cherry.png' }
	newnode.groups = { snappy = 3, flammable = 2 }
	minetest.register_node(mod_name..':leaves_cherry', newnode)

	newnode = clone_node('default:leaves')
	newnode.description = 'Palm Fronds'
	newnode.tiles = { 'moretrees_palm_leaves.png' }
	newnode.special_tiles = { 'moretrees_palm_leaves.png' }
	minetest.register_node(mod_name..':palm_leaves', newnode)

	newnode = clone_node('default:tree')
	newnode.description = 'Palm Tree'
	newnode.tiles = { 'moretrees_palm_trunk_top.png', 'moretrees_palm_trunk_top.png', 'moretrees_palm_trunk.png', 'moretrees_palm_trunk.png', 'moretrees_palm_trunk.png' }
	newnode.special_tiles = { 'moretrees_palm_trunk.png' }
	minetest.register_node(mod_name..':palm_tree', newnode)

	minetest.register_craft({
		output = 'default:wood 4',
		recipe = {
			{ mod_name..':palm_tree' },
		}
	})

	--newnode = clone_node('default:apple')
	--newnode.description = 'Coconut'
	--newnode.tiles = { 'moretrees_coconut.png' }
	--newnode.inventory_image = 'moretrees_coconut.png'
	--newnode.after_place_node = nil
	--minetest.register_node(mod_name..':coconut', newnode)
end


function new_mts(mts, nmts, opath, npath, replace)
	local f = io.open(opath..'/'..mts, 'r')
	if f then
		f:close()

		local sch = minetest.serialize_schematic(opath..'/'..mts, 'lua', { })
		for _, rep in pairs(replace) do
			sch = sch:gsub(rep[1], rep[2])
		end
		sch = minetest.deserialize('return { '..sch..' }')
		local out = minetest.serialize_schematic(sch.schematic, 'mts', { })
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
				{ 'default:leaves', mod_name..':leaves_alt_'..i },
				{ 'default:pine_needles', mod_name..':pine_needles_alt_'..i },
				{ 'default:jungleleaves', mod_name..':jungleleaves_alt_'..i },
				{ 'default:apple', fruit[i] },
			}
			new_mts(mts, nmts, opath, npath, replace)
		end
	end

	do
		local mts = 'apple_tree.mts'
		local nmts = 'cherry_tree.mts'
		local replace = {
			{ 'default:leaves', mod_name..':leaves_cherry' },
			{ 'default:apple', mod_name..':leaves_cherry' },
		}
		new_mts(mts, nmts, opath, npath, replace)
	end
end


do
	local pine_deco, apple_deco, jungle_deco

	local decos = { }
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
		if v and name:find(':corals') then
			v.flags = v.flags .. ', aquatic'
		end
		if v and name:find(':kelp') then
			v.flags = v.flags .. ', aquatic'
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
			{ ypos = 1, prob = 128 },
			{ ypos = 4, prob = 128 },
		}

		minetest.register_decoration({
			deco_type = 'schematic',
			place_on = { 'default:sand' },
			sidelen = 16,
			fill_ratio = 0.02,
			biomes = { 'desert_ocean' },
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
	local groups = { }
	groups.snappy = 3
	groups.flammable = 2
	groups.flower = 1
	groups.flora = 1
	groups.attached_node = 1
	local img = mod_name .. '_' .. name .. '.png'

	minetest.register_node(mod_name..':' .. name, {
		description = desc,
		drawtype = 'plantlike',
		waving = 1,
		tiles = { img },
		inventory_image = img,
		wield_image = img,
		sunlight_propagates = true,
		paramtype = 'light',
		walkable = false,
		buildable_to = true,
		stack_max = 99,
		groups = groups,
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = 'fixed',
			fixed = { -0.5, -0.5, -0.5, 0.5, -5/16, 0.5 },
		}
	})

	local bi = { }
	if biomes then
		bi = { }
		for _, b in pairs(biomes) do
			bi[b] = true
		end
	end

	if bi['rainforest'] then
		local def = {
			deco_type = 'simple',
			place_on = { 'default:dirt_with_rainforest_litter' },
			sidelen = 16,
			noise_params = {
				offset = 0.015,
				scale = 0.025,
				spread = { x = 200, y = 200, z = 200 },
				seed = seed,
				octaves = 3,
				persist = 0.6
			},
			biomes = { 'rainforest', 'rainforest_swamp' },
			y_min = 1,
			y_max = 31000,
			decoration = mod_name..':'..name,
			name = name,
			flower = true,
		}
		minetest.register_decoration(def)
	end

	local def = {
		deco_type = 'simple',
		place_on = { 'default:dirt_with_grass', 'default:dirt_with_dry_grass', 'default:dirt_with_rainforest_litter' },
		sidelen = 16,
		noise_params = {
			offset = -0.015,
			scale = 0.025,
			spread = { x = 200, y = 200, z = 200 },
			seed = seed,
			octaves = 3,
			persist = 0.6
		},
		biomes = biomes,
		y_min = 1,
		y_max = 31000,
		decoration = mod_name..':'..name,
		name = name,
		flower = true,
	}
	minetest.register_decoration(def)
end

register_flower('orchid', 'Orchid', { 'rainforest', 'rainforest_swamp' }, 783)
register_flower('bird_of_paradise', 'Bird of Paradise', { 'rainforest' }, 798)
register_flower('gerbera', 'Gerbera', { 'savanna', 'rainforest' }, 911)
