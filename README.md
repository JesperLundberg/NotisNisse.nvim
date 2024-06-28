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
```

#### Available commands

Example (To create a note):

```
:NotisNisse add
```

| Command      | Description                           |
| ------------ | ------------------------------------- |
| add          | Create a new note                     |
| show_all     | Show all notes                        |
| show_project | Show all notes in the current project |

#### TODO

#### Local development

To run tests:

```bash
nvim --headless --noplugin -u tests/minimal.vim -c "PlenaryBustedDirectory tests/ {minimal_init = 'tests/minimal.vim'}"
```

#### Credits
