# Riddance's game library
Simplify Roblox development for games.
## How to use?
### Getting the library
I recommend you start with the raw source files instead of the minified builds to avoid debugging issues.

You may switch to the minified builds after you are done making it.

- Pick the game you want.
- Go to it's folder and the containing `lib.lua` file.
- Click on the "Raw" button to go to the raw file viewer.
- Copy the URL that you get redirected to.
- The URL should be something like: `raw.githubusercontent.com`

Minified builds can be accessed by using this syntax:

`https://github.com/riddance-club/library/releases/latest/download/{filename}.lua`

Please check the correct library file name in the actual minified builds release. They are not the same as the ones in the raw source.

Embed the library somewhere in your code like this:

```lua
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/riddance-club/library/refs/heads/main/Dandy's%20World/lib.lua"))()
```

Minified builds should look something like this:

```lua
local lib = loadstring(game:HttpGet("https://github.com/riddance-club/library/releases/latest/download/Dandys_World.lua"))()
```

### Using the library

Check the game's folder for a `README.md` file. 

If it exists then it should have some form of documentation explaining what it does. 

If it is missing, then you will have to check the code yourself to see what it does. 

Example code:

```lua
local lib = loadstring(game:HttpGet("https://github.com/riddance-club/library/releases/latest/download/Dandys_World.lua"))()

print(lib.Game.IsRun()) -- boolean
print(lib.Generators.IsLast()) -- boolean
print(lib.Players.GetLocalCharacter()) -- Model (Player Character)
```

## Contributing

Currently this project is very incomplete and work in progress and we would really appreciate a lot of community support.

Whenever you encounter a problem, bug, something unclear, etc, or if you have any suggestions or ideas then it would be appreciated if you could open an issue about it.

It would also be extremely helpful if you could make fixes, improvements, code clean up, new features, new game support, making or improving documentation or something else.

Any form of contribution is helpful!
