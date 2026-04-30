```lua
lib.Game.IsRun() -> boolean
lib.Game.IsLobby() -> boolean
lib.Game.GetMap() -> Model or nil
lib.Game.GetPlayersFolder() -> Folder or nil
lib.Game.GetInfoFolder() -> Folder or nil
lib.Game.GetInfoData() -> table
lib.Game.GetInfoValueObject(string) -> ValueBase or nil
lib.Game.GetInfoValue(ValueBase) -> number
lib.Game.GetGameState() -> string

lib.Generators.GetCompleted() -> number
lib.Generators.GetRequired() -> number
lib.Generators.GetRemaining() -> number
lib.Generators.IsLast() -> boolean
lib.Generators.GetTotalProgressDecimal() -> number
lib.Generators.GetTotalProgressPercent() -> number
lib.Generators.GetAll() -> table (contains GeneratorModels)
lib.Generators.IsCompleted(GeneratorModel) -> boolean
lib.Generators.IsAvailable(GeneratorModel) -> boolean
lib.Generators.IsUncompleted(GeneratorModel) -> boolean
lib.Generators.IsUnavailable(GeneratorModel) -> boolean
lib.Generators.GetAnyCompleted() -> GeneratorModel or nil
lib.Generators.GetAnyUncompleted() -> GeneratorModel or nil
lib.Generators.GetAnyAvailable() -> GeneratorModel or nil
lib.Generators.GetAnyUnavailable() -> GeneratorModel or nil
lib.Generators.GetClosest() -> Model, distance (number) or nil
lib.Generators.GetCurrentAmount(GeneratorModel) -> number
lib.Generators.GetRequiredAmount(GeneratorModel) -> number
lib.Generators.GetProgress(GeneratorModel) -> number

lib.Players.GetAll() -> table (contains Players)
lib.Players.GetLocal() -> LocalPlayer
lib.Players.GetLocalCharacter() -> CharacterModel
lib.Players.GetCharacter(Player) -> CharacterModel
lib.Players.GetHealth(Player) -> number
lib.Players.IsAlive(Player) -> boolean
lib.Players.IsDead(Player) -> boolean
lib.Players.GetAlive() -> table
lib.Players.GetDead() -> table
lib.Players.GetAliveCharacters() -> table
lib.Players.GetClosest() -> Player, distance (number)
lib.Players.GetStats(Player) -> Folder
lib.Players.GetCurrentStamina(Player) -> number
lib.Players.GetMaxStamina(Player) -> number
lib.Players.GetStaminaRemaining(Player) -> number
lib.Players.GetInventory(Player) -> table
lib.Players.IsExtracting(Player) -> boolean

lib.Twisteds.GetAll() -> table (contains Monsters)
lib.Twisteds.GetClosest() -> Monster, distance (number)

lib.Map.GetElevator() -> ElevatorModel
```
