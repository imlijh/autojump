local AUTOJUMP_BIN = (AUTOJUMP_BIN_DIR or clink.get_env("LOCALAPPDATA") .. "\\autojump\\bin") .. "\\autojump"

local function autojump_add_to_database()
  -- Start a python process in background and return without waiting for
  -- subprocess to exit.
  -- Use "%TEMP%/autojump_error.txt" as a lock file.
  local cmdline = string.format(
    [[(start "" /b python "%s" --add "%s" 2> "%s") 2>nul]],
    AUTOJUMP_BIN,
    clink.get_cwd(),
    clink.get_env("TEMP") .. "\\autojump_error.txt"
  )
  os.execute(cmdline)
end

clink.prompt.register_filter(autojump_add_to_database, 99)

local function autojump_completion(word)
  for line in io.popen("python " .. "\"" .. AUTOJUMP_BIN .. "\"" ..  " --complete " .. word):lines() do
    clink.add_match(line)
  end
  return {}
end

local autojump_parser = clink.arg.new_parser()
autojump_parser:set_arguments({ autojump_completion })

clink.arg.register_parser("j", autojump_parser)
