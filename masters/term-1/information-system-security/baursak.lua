local database = "pamyatny_kadr"

-- -I: sqlcmd по умолчанию выключает QUOTED_IDENTIFIER
local sqlcmd = [[docker compose exec -T mssql /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -C -I -f 65001 -W -s "|"]]

local function quote(s)
	return "'" .. s:gsub("'", [['\'']]) .. "'"
end

local function query(sql)
	local pipe = assert(io.popen(sqlcmd .. " -b -h -1 -Q " .. quote("set nocount on; " .. sql)))
	local lines = {}
	for line in pipe:lines() do
		if line ~= "" then
			table.insert(lines, line)
		end
	end
	assert(pipe:close(), table.concat(lines, "\n"))
	return lines
end

local function migrations()
	local list = {}
	local pipe = assert(io.popen("ls migrations"))
	for file in pipe:lines() do
		local version, name = file:match("^(%d+)_(.+)%.sql$")
		if version then
			table.insert(list, { version = tonumber(version), name = name, file = file })
		end
	end
	pipe:close()
	table.sort(list, function(a, b)
		return a.version < b.version
	end)
	return list
end

task("default", "bk --list")

task("up", "docker compose up --detach --wait")

task("down", "docker compose down --volumes")

task("migrate", {
	args = { "target" },
	depends = { "up" },
	run = function(args)
		local target = tonumber(args.target) or math.huge

		query([[
			if object_id('master.dbo.schema_migrations') is null
				create table master.dbo.schema_migrations(
					version int primary key,
					name nvarchar(200) not null,
					applied_at datetime2(0) not null default sysdatetime())]])

		local applied = {}
		for _, version in ipairs(query("select version from master.dbo.schema_migrations")) do
			applied[tonumber(version)] = true
		end

		for _, m in ipairs(migrations()) do
			if m.version <= target and not applied[m.version] then
				print("==> " .. m.file)
				sh(sqlcmd .. " -b -i " .. quote("/work/migrations/" .. m.file))
				query(string.format(
					"insert into master.dbo.schema_migrations(version, name) values(%d, N'%s')",
					m.version,
					m.name
				))
			end
		end
	end,
})

task("reset", {
	args = { "target" },
	run = function(args)
		run("down")
		run("migrate", { target = args.target })
	end,
})

task("sql", {
	args = { "script", "output" },
	depends = { "up" },
	run = function(args)
		local script = assert(args.script, "bk sql <файл.sql | запрос> [файл вывода]")
		local db = query(string.format("select coalesce(db_name(db_id('%s')), 'master')", database))[1]
		local cmd = sqlcmd .. " -d " .. db

		local file = io.open(script, "r")
		if file then
			file:close()
			cmd = cmd .. " -i " .. quote("/work/" .. script:gsub("^%./", ""))
		else
			cmd = cmd .. " -Q " .. quote(script)
		end

		if args.output then
			cmd = cmd .. " > " .. quote(args.output)
		end

		sh(cmd)
	end,
})
