--[=[
    A collection of utilities for progression-related development.

    @class ProgressionUtils
]=]

local ProgressionUtils = {}

-- Imports
local Quests = require(script.Quests)
local Scores = require(script.Scores)
local Boosters = require(script.Boosters)
local Inventory = require(script.Inventory)

ProgressionUtils.Quests = Quests
ProgressionUtils.Scores = Scores
ProgressionUtils.Boosters = Boosters
ProgressionUtils.Inventory = Inventory

return ProgressionUtils