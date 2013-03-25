require 'profiler'

-- Include the rna module
local RNA = require 'rna'

--- Get the sequences from the input file as a string,
-- and convert them to a indexable table
-- @param input The input file
-- @return A table full of indexible sequences
local function getSequences(input)
  local sequences = {}

  -- Iterate over all the lines in the input file
  for line in input:lines() do
    -- In Lua, striings are not indexible, so to make
    -- things easier for later, I do some very simple
    -- pattern matching to pull out each character
    -- and put it into a Lua table.
    local sequence = {}
    for c in line:gmatch('%a') do
      table.insert(sequence, c)
    end
    table.insert(sequences, sequence)
  end
  return sequences
end

-- Make sure there are at least 2 addition arguments
if #arg < 2 then
  io.stderr:write('Missing input and/or output filenames\n')
  return
end

local input = io.open(arg[1], 'r')
local sequences = getSequences(input)
input:close()

profiler.start(string.format('timing/test_%d.txt', #sequences[1]))
local output = io.open(arg[2], 'w')
for _,sequence in ipairs(sequences) do
  local best = RNA.findBestPairs(sequence)

  output:write(string.format('%2d | ', #best))
  for _,v in ipairs(best) do
    output:write(string.format('{ %s } ', table.concat(v, ', ')))
  end
  output:write('\n')
end
output:close()
profiler.stop()
