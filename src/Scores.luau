local Scores = {}

-- Imports
local Packages = script.Parent.Packages
local Signal = require(Packages.Signal)

Scores.OnScoreAdded = Signal.new()
Scores.OnScoreRemoved = Signal.new()

Scores.SetScore = nil -- Set with DeclareSetScoreCallback
Scores.GetScore = nil -- Set with DeclareGetScoreCallback

local function AssertScoreCallbacks()
    if not Scores.SetScore then
        error("Attempt to call a score method when SetScore was not declared")
    end

    if not Scores.GetScore then
        error("Attempt to call a score method when GetScore was not declared")
    end
end

local function AssertScoreAsNumber(Value : any)
    if typeof(Value) ~= "number" then
        error("Read score value was not a number")
    end

    if math.round(Value) ~= Value then
        error("Read score was not an integer")
    end
end

function Scores.DeclareSetScoreCallback(Callback : (Player : Player, ScoreType : string, ScoreValue : number) -> nil)
    if Scores.SetScore then
        error("Attempt to declare SetScore callback when it already exists")
    end

    Scores.SetScore = Callback
end

function Scores.DeclareGetScoreCallback(Callback : (Player : Player, ScoreType : string) -> nil)
    if Scores.GetScore then
        error("Attempt to declare GetScore callback when it already exists")
    end

    Scores.GetScore = Callback
end

function Scores.AddScoreForPlayer(Player : Player, ScoreType : string, AddedAmount : number)
    AssertScoreCallbacks()
    AssertScoreAsNumber(AddedAmount)

    local ExistingScore = Scores.GetScore(Player, ScoreType)

    AssertScoreAsNumber(ExistingScore)

    ExistingScore += AddedAmount
    Scores.SetScore(Player, ScoreType, ExistingScore)
    Scores.OnScoreAdded:Fire(Player, ScoreType, AddedAmount)
end

function Scores.RemoveScoreForPlayer(Player : Player, ScoreType : string, RemovedAmount : number)
    AssertScoreCallbacks()
    AssertScoreAsNumber(RemovedAmount)

    local ExistingScore = Scores.GetScore(Player, ScoreType)

    AssertScoreAsNumber(ExistingScore)

    ExistingScore -= RemovedAmount

    if ExistingScore < 0 then
        error("Attempt to remove more score than exists for type " .. ScoreType)
    end

    Scores.SetScore(Player, ScoreType, ExistingScore)
    Scores.OnScoreRemoved:Fire(Player, ScoreType, RemovedAmount)
end

function Scores.HasAtLeast(Player : Player, ScoreType : number, Minimum : number)
    AssertScoreCallbacks()
    AssertScoreAsNumber(Minimum)

    local ExistingScore = Scores.GetScore(Player, ScoreType)

    AssertScoreAsNumber(ExistingScore)

    if ExistingScore >= Minimum then
        return
    end
end

return Scores