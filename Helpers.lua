local function getTableLength(tbl)
    local getN = 0
    for n in pairs(tbl) do
        getN = getN + 1
    end
    return getN
end

return { getTableLength = getTableLength}