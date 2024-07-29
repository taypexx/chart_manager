local utils = {}

--// Searches for a value recursively
---@param t table Table to search in
---@param k any Key of the table
---@return any
function utils.tableFindRecursive(t,k)
  for k1,v1 in pairs(t) do
    if k1 == k then
      return v1
    end
    for k2,v2 in pairs(v1) do
      if k2 == k then
        return v2
      end
    end
  end
end

--// Returns first element of the table
---@param t table
---@return any,any
function utils.firstElement(t) 
  for k,v in pairs(t) do
    return k,v
  end
end

--// Returns a table containing indexes of the given table
---@param t table Table with indexes
---@return table
function utils.getIndexes(t)
  local it = {}
  local n = 0
  for i,_ in pairs(t) do
    n = n+1
    it[n] = i
  end
  return it
end

--// Removes unnecessary spaces from a string
---@param str string String to edit
---@return string
function utils.removeSpaces(str)
  local edited_string = ""
  local split_str = utils.split(str,"")
  local wereOtherChars = false
  for i,char in pairs(split_str) do
    if wereOtherChars or char ~= " " then
      if not (i == #split_str and char == " ")  then
        wereOtherChars = true
        edited_string = edited_string..char
      end
    end
  end
  return edited_string
end

local reservedWindowsNames = {
  "CON","PRN","AUX","NUL",
  "COM1","COM2","COM3","COM4","COM5","COM6","COM7","COM8","COM9","COM0",
  "LPT1", "LPT2", "LPT3", "LPT4", "LPT5", "LPT6", "LPT7", "LPT8", "LPT9", "LPT0",
}

--// Checks if a string is not reserved by windows
---@param str string String to check
---@return boolean
---@return boolean,string
function utils.checkForValidWindowsName(str)
  for _,reservedName in pairs(reservedWindowsNames) do
    if string.upper(str) == reservedName then
      return false,string.format([[Name "%s" is reserved by Windows.]],str)
    end
  end
  return true
end

local forbiddenWindowsCharacters = {
  "<",">",[["]],":","/","\\","|","?","*"
}

--// Removes forbidden windows characters from the string
---@param str string String to edit
---@return string
function utils.removeForbiddenWindowsCharacters(str)
  local chars = utils.split(str,"")
  local edited_str = ""
  for _,char in pairs(chars) do
    local isForbidden = false
    for _,forbChar in pairs(forbiddenWindowsCharacters) do
      if char == forbChar then
        isForbidden = true
      end
    end
    if not isForbidden then
      edited_str = edited_str..char
    end
  end
  return edited_str
end

local forbidden_json_chars = {
  "{","}",'"'
}

--// Checks if a field contains forbidden json characters
---@param str string String to check
---@return boolean
---@return boolean,string
function utils.checkForValidJsonField(str)
  for _,char in pairs(forbidden_json_chars) do
    if string.find(str,char) then
        return false,string.format([[Character %s is not allowed.]],char)
    end
  end
  return true
end

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