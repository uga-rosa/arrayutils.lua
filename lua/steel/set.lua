---@class Set
local Set = {}
Set.__index = Set

Set.__tostring = function(self)
    local t = {}
    for k, _ in pairs(self) do
        table.insert(t, k)
    end
    if #t == 0 then
        return "{}"
    end
    return string.format("{ %s }", table.concat(t, ", "))
end

---Create a set type instance from an array.
---@param arr? Array|any[]
---@return Set
function Set.new(arr)
    arr = arr or {}
    vim.validate({
        arr = { arr, "table", true },
    })

    local res = {}
    for _, v in ipairs(arr) do
        res[v] = true
    end
    return setmetatable(res, Set)
end

---Return a copy of set.
---@param s Set
---@return Set
function Set.copy(s)
    local res = Set.new()
    for k, _ in pairs(s) do
        res[k] = true
    end
    return res
end

---Convert to an array.
---@param self Set
---@return Array|any[]
function Set:toArray()
    local res = {}
    for k, _ in pairs(self) do
        table.insert(res, k)
    end
    return res
end

---Add an element to a set
---@param self Set
---@param e any
function Set:add(e)
    self[e] = true
end

---Add an element to a set
---@param self Set
---@param e any
function Set:remove(e)
    self[e] = nil
end

----- Set operation

---Union.
---@param self Set
---@param s Set
---@return Set
function Set:union(s)
    local res = Set.copy(self)
    for k, _ in pairs(s) do
        res[k] = true
    end
    return res
end

---The + operator is used for union.
Set.__add = Set.union

---Intersection.
---@param self Set
---@param s Set
---@return Set
function Set:intersection(s)
    local res = Set.new()
    for k, _ in pairs(self) do
        if s[k] then
            res[k] = true
        end
    end
    return res
end

---The * operation is used for intersection.
Set.__mul = Set.intersection

---Set difference.
---@param self Set
---@param s Set
---@return Set
function Set:difference(s)
    local res = Set.copy(self)
    for k, _ in pairs(s) do
        res[k] = nil
    end
    return res
end

---The - operation is used for set difference.
Set.__sub = Set.difference

---XOR
---@param self Set
---@param s Set
---@return Set
function Set:symmetric_difference(s)
    local res = Set.new()

    for k, _ in pairs(self) do
        if not s[k] then
            res[k] = true
        end
    end

    for k, _ in pairs(s) do
        if not self[k] then
            res[k] = true
        end
    end

    return res
end

---The ^ operation is used for XOR
Set.__pow = Set.symmetric_difference

-----

return Set
