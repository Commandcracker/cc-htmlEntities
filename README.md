# htmlEntities for ComputerCraft

HTML entities decoding/encoding for [ComputerCraft](https://tweaked.cc/).

Based on [htmlEntities-for-lua](https://github.com/TiagoDanin/htmlEntities-for-lua).

## Features

- Fast!
- No dependencies!
- Easy to implement!

## Changes

- Removed
  - global [string:htmlDecode], [string:htmlEncode],
  - [global_module options] and [global_module registration]
  - [debug_htmlEntities]
- Merged [Improve regex to not match empty html entities]
- Added LDoc documentation
- [ASCII_htmlEntities] is now a parameter for decode and encode
- Replaced [error_msg_htmlEntities] with [assert]
- Optimized all functions and made them easier to read
- Added ComputerCraft support and function to convert entities to ASCII only
- Added better tests and changed to [busted]
- Fixed encode, decode ignoring html entities without ;

## Installation

soon™

## Example

```lua
local htmlEntities = require('htmlEntities')
print(htmlEntities.encode('Commandcracker'))
print(htmlEntities.decode('&#84;&#105;&#97;&#103;&#111;&#32;&#68;&#97;&#110;&#105;&#110;&#32;&#58;&#41;'))
```

## Documentation

### API

| Function                      | Info                                                                  |
| ----------------------------- | --------------------------------------------------------------------- |
| htmlEntities                  | Return table with information about module                            |
| htmlEntities.decode(input)    | Decode HTML entities                                                  |
| htmlEntities.encode(input)    | Encode in HTML entities (in ASCII) NOTE: Emoji is not supported here! |
| htmlEntities.ASCII_HEX(input) | Decode ASCII HEX                                                      |
| htmlEntities.ASCII_DEC(input) | Decode ASCII DEC                                                      |

## Tests

To run the test suite:

```sh
# Lua
lua tests/cli.lua
# Or
lua tests/travis.lua
```

## Contributors

Pull requests and stars are always welcome. For bugs and feature requests, please [create an issue].

## License

[MIT] &copy; [Tiago Danin], [Commandcracker]

[MIT]: LICENSE
[Improve regex to not match empty html entities]: https://github.com/TiagoDanin/htmlEntities-for-lua/pull/13
[string:htmlDecode]: https://github.com/TiagoDanin/htmlEntities-for-lua/blob/124ee6d1e224bbc0e3528003db67149cad7ee8f7/src/htmlEntities.lua#L2386-L2389
[string:htmlEncode]: https://github.com/TiagoDanin/htmlEntities-for-lua/blob/124ee6d1e224bbc0e3528003db67149cad7ee8f7/src/htmlEntities.lua#L2391-L2394
[Tiago Danin]: https://TiagoDanin.github.io
[global_module options]: https://github.com/TiagoDanin/htmlEntities-for-lua/blob/124ee6d1e224bbc0e3528003db67149cad7ee8f7/src/htmlEntities.lua#L5-L6
[global_module registration]: https://github.com/TiagoDanin/htmlEntities-for-lua/blob/124ee6d1e224bbc0e3528003db67149cad7ee8f7/src/htmlEntities.lua#L17-L19
[debug_htmlEntities]: https://github.com/TiagoDanin/htmlEntities-for-lua/blob/124ee6d1e224bbc0e3528003db67149cad7ee8f7/src/htmlEntities.lua#L3
[ASCII_htmlEntities]: https://github.com/TiagoDanin/htmlEntities-for-lua/blob/124ee6d1e224bbc0e3528003db67149cad7ee8f7/src/htmlEntities.lua#L4
[error_msg_htmlEntities]: https://github.com/TiagoDanin/htmlEntities-for-lua/blob/124ee6d1e224bbc0e3528003db67149cad7ee8f7/src/htmlEntities.lua#LL2C37-L2C37
[assert]: https://www.lua.org/pil/8.3.html
[Commandcracker]: https://github.com/Commandcracker
[create an issue]: https://github.com/Commandcracker/cc-htmlEntities/issues
[busted]: https://github.com/lunarmodules/busted
