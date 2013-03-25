--------------------------------------------------------------
-- The RNA module:
--
-- Public interface:
-- - findBestPairs(sequence)
--------------------------------------------------------------

--- Builds a square matrix
-- @param size The length of a size of the square matrix
-- @return A square matrix of size * size
local function buildMatrix(size)
  local t = {}

  -- Note, in Lua, tables typically begin at 1, not 0
  for r = 1, size do
    t[r] = {}
    for c = 1, size do
      t[r][c] = {}
    end
  end
  return t
end

--- Check if a and b are an RNA pair
-- @param a One RNA letter
-- @param b One RNA letter
-- @return Whether they pair together (i.e., AU or GC)
local function isPair(a, b)
  local p = { 'A', 'U', 'G', 'C' }

  -- If a is found in p, then we check its pair:
  -- - if i % 2 == 0, its pair is the previous index (i - 1);
  -- - otherwise,     its pair is the following index (i + 1);
  for i = 1, #p do
    if a == p[i] then
      return ((i % 2 == 0) and (b == p[i - 1])) or
             ((i % 2 == 1) and (b == p[i + 1]))
    end
  end

  return false
end

--- Searches the given range for any matches
-- @param sequence The RNA sequence
-- @param opt The dynamic programming table
-- @param i The beginning of the range
-- @param j The end of the range
-- @return The value of the opt table @ (i, j)
local function checkRange(sequence, opt, i, j)
  local fMax = {}
  local fT = 0

  -- Anything less too close will just waste time,
  -- so subtract 5 from j
  for t = i, j - 5 do
    if isPair(sequence[t], sequence[j]) then
      -- Get the existing best pairs of opt[i][t - 1] and opt[t + 1][j - 1]
      local lhs = opt[i][t - 1] or {}
      local rhs = opt[t + 1][j - 1] or {}

      -- In Lua, table's are passed by reference, so to not interfere
      -- with the opt table, copy the values from lhs and rhs into
      -- another table, cMax
      local cMax = {}
      for _,v in ipairs(lhs) do
        table.insert(cMax, v)
      end
      for _,v in ipairs(rhs) do
        table.insert(cMax, v)
      end

      -- Finds the best t to use for later
      if #fMax <= #cMax then
        fMax = cMax
        fT = t
      end
    end
  end

  -- If I have found a pair
  if fT > 0 then
    -- Add in the new pair
    table.insert(fMax, { fT, j })
    
    -- See if the number of pairs with this new pair is better
    -- than what we have found earlier
    if #opt[i][j - 1] < #fMax then
      return fMax
    end
  end

  -- Otherwise, just copy over the value from the previous span
  return opt[i][j - 1]
end

--- Given a sequence of RNA molecules,
-- find the best fold which produces the greatest number of pairs
-- @param sequence The RNA sequence
-- @return A table containing all the pairs for the best fold
local function findBestPairs(sequence)
  -- Create the table to store the optimum values of sequences
  -- from 0, #sequence
  local opt = buildMatrix(#sequence)

  local matches = {}

  -- I want to build the table diagonally from the center
  -- diagonal to the top right, so rather than iterate i and j,
  -- I iterate i and span, and set j = i + span
  for span = 0, #sequence do
    for i = 1, #sequence - span do
      local j = i + span
      -- Guard against sharp turns
      if math.abs(i - j) > 4 then
        opt[i][j] = checkRange(sequence, opt, i, j)
      end
    end
  end

  -- Due to the way the opt-table is constructed, the
  -- best value will always be found in the top right
  -- corner of the table
  return opt[1][#sequence]
end

return {
  findBestPairs = findBestPairs,
}
