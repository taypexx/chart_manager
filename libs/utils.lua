local utils = {}

--// Reads content from the json file and returns decoded table
---@param filepath string Filepath of the json file
---@return table
function utils.jsonR(filepath)
    local file = io.open(filepath,"r")
    if not file then return end
    local content = json.decode(file:read("*a"))
    file:close()
    return content or {}
end

--// Writes content to the json file and returns true if succeeded
---@param filepath string Filepath of the json file
---@param content table Content to write to the file
---@return boolean
function utils.jsonW(filepath,content)
    local file = io.open(filepath,"w")
    if not file then return end
    content = json.encode(content)
    file:write(content)
    file:close()
    return true
end

local function gsplit(text, pattern, plain)
    local splitStart, length = 1, #text
    return function ()
      if splitStart then
        local sepStart, sepEnd = string.find(text, pattern, splitStart, plain)
        local ret
        if not sepStart then
          ret = string.sub(text, splitStart)
          splitStart = nil
        elseif sepEnd < sepStart then
          ret = string.sub(text, splitStart, sepStart)
          if sepStart < length then
            splitStart = sepStart + 1
          else
            splitStart = nil
          end
        else
          ret = sepStart > splitStart and string.sub(text, splitStart, sepStart - 1) or ''
          splitStart = sepEnd + 1
        end
        return ret
      end
    end
end

--// Splits string into an array of characters
---@param text string Text to split
---@param pattern string Characters that will separate the string
---@return table
function utils.split(text, pattern, plain)
    local ret = {}
    for match in gsplit(text, pattern, plain) do
      table.insert(ret, match)
    end
    return ret
end

--// Clamps the value between min and max values
---@param min number Minimum number
---@param max number Maximum number
---@param value number Number to clamp
---@return number value Clamped value
function utils.clamp(min,max,value)
    if value > max then
      return max
    elseif value < min then
      return min
    else return value end
end

--// Finds an element by the value in the table and returns index
---@param t table Table to check
---@param toFind any Value to find
---@return integer Index Index of the found value
function utils.tableFind(t,toFind)
    for i,v in pairs(t) do
        if v == toFind then
          return i
        end
    end
    return false
end

--// Compares two tables
---@param a table First table
---@param b table Second table
function utils.compareTables(a,b)
  local eq = true
  for k,v in pairs(a) do
    eq = eq and b[k]==v
  end
  return eq
end

--// Multiplies two tables
---@param a table First table
---@param b table Second table
function utils.multiplyTables(a,b)
  local output = {}
  for k,v in pairs(b) do
    output[k] = a[k] * v
  end
  return output
end

--// Returns length of the provided dictionary
---@param t table Dictionary
function utils.dictionary_len(t)
  local len = 0
  for _,_ in pairs(t) do
    len = len + 1
  end
  return len
end

function utils.numtostr(num)
  local str = ""
  num = utils.split(tostring(num),"")
  for i,v in pairs(num) do
    if v == "," then
      v = "."
    end
    str = str..v
  end
  return str
end

return utils