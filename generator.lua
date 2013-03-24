-- On some older systems, even after seeding the random,
-- Lua produces a few identical random numbers near the beginning.
-- To avoid that, simply call random a few times
math.randomseed(os.time())
math.random(); math.random(); math.random()

local size = tonumber(arg[1])
if not size then
  error('Need a size for the generated sequence')
end

-- The possible random values
local values = { 'A', 'U', 'G', 'C' }

local f = io.open(string.format('input/test_%d.txt', size), 'w')

for i = 1, 100 do
  local t = {}
  for j = 1, size do
    -- To save memory, add the random values to a table
    table.insert(t, values[math.random(#values)])
  end
  -- and then concatenate that table for the write
  f:write(string.format('%s\n', table.concat(t, '')))
end

f:close()
