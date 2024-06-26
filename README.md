# notisnisse.nvim

#### Demo

#### Why?

This is a plugin where you can create todos or notes that are connected to the current project that you are working on.

#### Required system dependencies

You also need nerdfonts patched version installed to get proper symbols.
Get fonts from [here](https://github.com/ryanoasis/nerd-fonts).

#### How to install

Using lazy package manager:

```lua
"JesperLundberg/notisnisse.nvim",
dependencies = {
    "nvim-lua/plenary.nvim",
    "kkharji/sqlite.lua",
},
-- config = function()
--     require("notisnisse").setup({})
-- end,
```

#### Available commands

Example (To create a note):

```
:NotisNisse add
```

| Command | Description       |
| ------- | ----------------- |
| add     | Create a new note |

#### Configuration

You must always run the setup method like this:

```lua
-- config = function()
-- 	require("notisnisse").setup()
-- end
```

There are a few settings that might be relevant to change. The defaults are as follows:

```lua
local defaults = {}
```

#### TODO

#### Local development

To run tests:

```bash
nvim --headless --noplugin -u tests/minimal.vim -c "PlenaryBustedDirectory tests/ {minimal_init = 'tests/minimal.vim'}"
```

#### Credits
