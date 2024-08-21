-- Gets the directory of the current script
local compilerDir = debug.getinfo(1).source:match("@?(.*/)")
local compile = dofile(compilerDir .. "compiler.lua")
-- local createExecutable = require("FiOne") -- Used for interpreting the bytecode

return function(source)
    local executable
    local env = "5.1"
    local name = env or "unknown"

    local ran, failureReason = pcall(function()
        local compiledBytecode = compile(source, name)
        
        -- Write bytecode to bytecode.txt
        local file = io.open(compilerDir .. "bytecode.txt", "wb")
        if file then
            file:write(compiledBytecode)
            file:close()
        else
            error("Failed to open bytecode.txt for writing")
        end

        -- executable = createExecutable(compiledBytecode, env)       
        -- executable = compiledBytecode
    end)

    if ran then
        return executable
    else
        return nil, failureReason
    end
end
