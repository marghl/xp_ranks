local MODNAME = core.get_current_modname()
local storage = core.get_mod_storage()

core.register_privilege("area_protect", {
	description = "Can create personal protected areas",
	give_to_singleplayer = false,
})

local rank_groups = {
	{
		id = "newcomer",
		name = "Newcomer",
		color = { r = 180, g = 200, b = 210 },
		levels = {
			{ xp = 0, label = "I" },
			{ xp = 100, label = "II" },
			{ xp = 200, label = "III" },
			{ xp = 300, label = "IV" },
			{ xp = 500, label = "V" },
			{ xp = 700, label = "VI" },
		},
	},
	{
		id = "inhabitant",
		name = "Inhabitant",
		color = { r = 110, g = 200, b = 120 },
		levels = {
			{ xp = 1000, label = "I" },
			{ xp = 2500, label = "II" },
			{ xp = 5000, label = "III" },
			{ xp = 10000, label = "IV" },
			{ xp = 25000, label = "V" },
			{ xp = 50000, label = "VI" },
			{ xp = 75000, label = "VII" },
		},
	},
	{
		id = "citizen",
		name = "Citizen",
		color = { r = 90, g = 160, b = 240 },
		levels = {
			{ xp = 100000, label = "I" },
			{ xp = 200000, label = "II" },
			{ xp = 350000, label = "III" },
			{ xp = 500000, label = "IV" },
			{ xp = 700000, label = "V" },
			{ xp = 900000, label = "VI" },
			{ xp = 1100000, label = "VII" },
		},
	},
	{
		id = "noble",
		name = "Noble",
		color = { r = 235, g = 190, b = 60 },
		levels = {
			{ xp = 1200000 },
		},
	},
}

for _, group in ipairs(rank_groups) do
	for _, level in ipairs(group.levels) do
		local name = group.name
		if level.label then
			name = name .. " " .. level.label
		end

		xp_redo.register_rank({
			name = name,
			icon = "xp_mese_crystal.png",
			color = group.color,
			xp = level.xp,
		})
	end
end

local function parse_privileges(value)
	local result = {}
	for privilege in (value or ""):gmatch("[^,%s]+") do
		result[privilege] = true
	end
	return result
end

local configured_privileges = {}
for _, group in ipairs(rank_groups) do
	configured_privileges[group.id] = parse_privileges(
		core.settings:get("xp_ranks.privileges." .. group.id)
	)
end

local function get_group_index(xp)
	local index = 1
	for i, group in ipairs(rank_groups) do
		if xp >= group.levels[1].xp then
			index = i
		else
			break
		end
	end
	return index
end

local function get_desired_privileges(xp)
	local desired = {}
	local group_index = get_group_index(xp)

	for i = 1, group_index do
		for privilege in pairs(configured_privileges[rank_groups[i].id]) do
			desired[privilege] = true
		end
	end

	return desired
end

local function storage_key(playername)
	return "granted_privileges:" .. playername
end

local function read_tracked_privileges(playername)
	local value = storage:get_string(storage_key(playername))
	if value == "" then
		return {}
	end
	return core.deserialize(value) or {}
end

local function write_tracked_privileges(playername, privileges)
	storage:set_string(storage_key(playername), core.serialize(privileges))
end

local function sync_privileges(playername, xp)
	if not core.player_exists(playername) then
		return
	end

	local current = core.get_player_privs(playername)
	local desired = get_desired_privileges(xp)
	local tracked = read_tracked_privileges(playername)
	local changed = false

	for privilege in pairs(desired) do
		if not core.registered_privileges[privilege] then
			core.log("warning", "[" .. MODNAME .. "] Unknown configured privilege: " .. privilege)
		elseif not current[privilege] then
			current[privilege] = true
			tracked[privilege] = true
			changed = true
		end
	end

	if core.settings:get_bool("xp_ranks.revoke_on_demotion", false) then
		for privilege in pairs(tracked) do
			if not desired[privilege] then
				current[privilege] = nil
				tracked[privilege] = nil
				changed = true
			end
		end
	end

	if changed then
		core.set_player_privs(playername, current)
		write_tracked_privileges(playername, tracked)
	end
end

xp_redo.register_hook({
	rank_change = function(playername, xp)
		sync_privileges(playername, xp)
	end,
})

core.register_on_joinplayer(function(player)
	local playername = player:get_player_name()
	core.after(0, function()
		sync_privileges(playername, xp_redo.get_xp(playername))
	end)
end)
