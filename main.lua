local scriptDir = debug.getinfo(1).source:match("@?(.*/)")
local LoadstringL = dofile(scriptDir .. "Loadstring.lua")

local function readFile(filePath) 
    local file, err = io.open(filePath, "r")
    local content = file:read("*a")

    file:close()
    return content
end

local scriptPath = scriptDir .. "script.lua"
local text, readError = readFile(scriptPath)

-- Replace assignment operators, errors would be caused when interpreting the bytecode using FiOne or another interpreter (thank you birb.yay <3)
text = text:gsub("(%a+)%s*([%+%-*/])=%s*(%d+)", function(variable, operator, value)
    if operator == "+" then
        return variable .. " = " .. variable .. " + " .. value
    elseif operator == "-" then
        return variable .. " = " .. variable .. " - " .. value
    elseif operator == "*" then
        return variable .. " = " .. variable .. " * " .. value
    elseif operator == "/" then
        return variable .. " = " .. variable .. " / " .. value
    else
        return variable .. " " .. operator .. "= " .. value
    end
end)

local func, compileError = LoadstringL(text)

if not func then
    print("Failed to compile script: Line " .. compileError)
    return
end

-- func()