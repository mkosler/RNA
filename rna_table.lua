--------------------------------------------------------------
-- The RNA module:
--
-- Public interface:
-- - findBestPairs(sequence)
--------------------------------------------------------------

--- Stringify the opt table (for debugging)
-- @param opt The opt table
-- @return The opt table, as a string
local function stringifyOptTable(opt)
  local s = '   | '
  for i = 1, #opt do
    s = s .. string.format('%2d ', i)
  end
  s = s .. '\n'
  s = s .. string.rep('-', s:len())
  s = s .. '\n'

  for i = 1, #opt do
    s = s .. string.format('%2d | ', i)
    for j = 1, #opt[i] do
      if j >= i then
        s = s .. string.format('%2d ', opt[i][j])
      else
        s = s .. '   '
      end
    end
    s = s .. '\n'
  end

  return s
end

--- Builds a square matrix
-- @param size The length of a size of the square matrix
-- @return A square matrix of size * size
local function buildMatrix(size)
  local t = {}

  -- Note, in Lua, tables typically begin at 1, not 0
  for r = 1, size do
    t[r] = {}
    for c = 1, size do
      t[r][c] = 0
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
  -- If we find at least one t which pairs with j, flag it
  local found = false
  local fMax = 0
  local fT = -1

  -- Only check values in the range sufficiently far away
  -- from j
  for t = i, j - 5 do
    -- Check to see if sequence[t] and sequence[j] match
    if isPair(sequence[t], sequence[j]) then
      -- Flag the sequence
      found = true

      -- If there are any more matches between
      -- t and j, only care about the maximum of those matches
      -- NOTE: If i == t, then we may go out of bounds, so
      -- replace the value with 0
      --fMax = math.max(fMax, opt[t + 1][j - 1] + (opt[i][t - 1] or 0))
      local value = opt[t + 1][j - 1] + (opt[i][t - 1] or 0)
      if value > fMax then
        fMax = value
        fT = t
      end
    end
  end

  -- Initialize our return as the best pairs from the
  -- previous range
  local ret = opt[i][j - 1]
  if found then
    ret = math.max(ret, 1 + fMax)
  end

  return ret
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