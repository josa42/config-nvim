# config-nvim

<br>

## Install

```sh
git clone git@github.com:josa42/config-nvim ~/.configim
```

<br>

## Key maps

### Find Files

| Keys                                      | Action                         | Mode |
| :---------------------------------------- | :----------------------------- | :--- |
| <kbd>leader</kbd><kbd>p</kbd>             | Find files                     | `n`  |
| <kbd>leader</kbd><kbd>r</kbd><kbd>p</kbd> | Find files in root             | `n`  |
| <kbd>leader</kbd><kbd>w</kbd><kbd>p</kbd> | Find files in workspace        | `n`  |
| <kbd>leader</kbd><kbd>a</kbd><kbd>p</kbd> | Find files in github workflows | `n`  |
| <kbd>leader</kbd><kbd>c</kbd><kbd>p</kbd> | Find files in config           | `n`  |

### Find String

| Keys                                      | Action                          | Mode |
| :---------------------------------------- | :------------------------------ | :--- |
| <kbd>leader</kbd><kbd>f</kbd>             | Find string                     | `n`  |
| <kbd>leader</kbd><kbd>r</kbd><kbd>f</kbd> | Find string in root             | `n`  |
| <kbd>leader</kbd><kbd>w</kbd><kbd>f</kbd> | Find string in workspace        | `n`  |
| <kbd>leader</kbd><kbd>a</kbd><kbd>f</kbd> | Find string in github workflows | `n`  |
| <kbd>leader</kbd><kbd>c</kbd><kbd>f</kbd> | Find string in config           | `n`  |
| <kbd>leader</kbd><kbd>b</kbd><kbd>f</kbd> | Find string in buffer           | `n`  |

### File Explorer

| Keys                                      | Action                             | Mode |
| :---------------------------------------- | :--------------------------------- | :--- |
| <kbd>leader</kbd><kbd>e</kbd>             | Explorer files                     | `n`  |
| <kbd>leader</kbd><kbd>r</kbd><kbd>e</kbd> | Explorer files in root             | `n`  |
| <kbd>leader</kbd><kbd>w</kbd><kbd>e</kbd> | Explorer files in workspace        | `n`  |
| <kbd>leader</kbd><kbd>a</kbd><kbd>e</kbd> | Explorer files in github workflows | `n`  |
| <kbd>leader</kbd><kbd>c</kbd><kbd>e</kbd> | Explorer files in config           | `n`  |

### Workspaces

| Keys                                      | Action           | Mode |
| :---------------------------------------- | :--------------- | :--- |
| <kbd>leader</kbd><kbd>w</kbd><kbd>w</kbd> | Select workspace | `n`  |

### Go to

| Keys                     | Action                        | Mode |
| :----------------------- | :---------------------------- | :--- |
| <kbd>g</kbd><kbd>d</kbd> | Go to definition              | `n`  |
| <kbd>g</kbd><kbd>D</kbd> | Go to definition in a new tab | `n`  |

### Language Actions

| Keys                                      | Action          | Mode |
| :---------------------------------------- | :-------------- | :--- |
| <kbd>leader</kbd><kbd>l</kbd><kbd>a</kbd> | Run code action | `n`  |
| <kbd>leader</kbd><kbd>l</kbd><kbd>l</kbd> | Run code lense  | `n`  |
| <kbd>leader</kbd><kbd>r</kbd><kbd>n</kbd> | Rename          | `n`  |

### Help

| Keys                        | Action              | Mode |
| :-------------------------- | :------------------ | :--- |
| <kbd>g</kbd><kbd>H</kbd>    | Show signature help | `n`  |
| <kbd>K</kbd>                | Hover               | `n`  |
| <kbd>ctrl</kbd><kbd>h</kbd> | Show signature help | `i`  |

### Completion

| Keys                            | Action                               | Mode |
| :------------------------------ | :----------------------------------- | :--- |
| <kbd>ctrl</kbd><kbd>space</kbd> | Toggle completion                    | `i`  |
| <kbd>tab</kbd>                  | Confirm completion                   | `i`  |
| <kbd>ctrl</kbd><kbd>e</kbd>     | Expand snippet                       | `i`  |
| <kbd>ctrl</kbd><kbd>j</kbd>     | Select next completion item          | `i`  |
| <kbd>ctrl</kbd><kbd>k</kbd>     | Select previous completion item      | `i`  |
| <kbd>ctrl</kbd><kbd>n</kbd>     | Jump to next snippet placeholder     | `i`  |
| <kbd>ctrl</kbd><kbd>p</kbd>     | Jump to previous snippet placeholder | `i`  |

### Tabs

| Keys                                       | Action              | Mode |
| :----------------------------------------- | :------------------ | :--- |
| <kbd>tab</kbd>                             | Select next tab     | `n`  |
| <kbd>shift</kbd><kbd>tab</kbd>             | Select previous tab | `n`  |
| <kbd>m</kbd><kbd>tab</kbd>                 | Move tab right      | `n`  |
| <kbd>m</kbd><kbd>shift</kbd><kbd>tab</kbd> | Move tab left       | `n`  |
| <kbd>leader</kbd><kbd>1</kbd>              | Select tab 1        | `n`  |
| <kbd>leader</kbd><kbd>2</kbd>              | Select tab 2        | `n`  |
| <kbd>leader</kbd><kbd>3</kbd>              | Select tab 3        | `n`  |
| <kbd>leader</kbd><kbd>4</kbd>              | Select tab 4        | `n`  |
| <kbd>leader</kbd><kbd>5</kbd>              | Select tab 5        | `n`  |
| <kbd>leader</kbd><kbd>6</kbd>              | Select tab 6        | `n`  |
| <kbd>leader</kbd><kbd>7</kbd>              | Select tab 7        | `n`  |
| <kbd>leader</kbd><kbd>8</kbd>              | Select tab 8        | `n`  |
| <kbd>leader</kbd><kbd>9</kbd>              | Select tab 9        | `n`  |

### Diagnositics

| Keys                                      | Action           | Mode |
| :---------------------------------------- | :--------------- | :--- |
| <kbd>leader</kbd><kbd>d</kbd><kbd>l</kbd> | Show Diagnostics | `n`  |

### Comments

| Keys                                 | Action         | Mode     |
| :----------------------------------- | :------------- | :------- |
| <kbd>g</kbd><kbd>c</kbd><kbd>c</kbd> | Toggle comment | `n`, `v` |

### Git

| Keys                                      | Action                  | Mode |
| :---------------------------------------- | :---------------------- | :--- |
| <kbd>leader</kbd><kbd>g</kbd><kbd>s</kbd> | Show git status         | `n`  |
| <kbd>leader</kbd><kbd>g</kbd><kbd>b</kbd> | Show git buffer commits | `n`  |
| <kbd>leader</kbd><kbd>g</kbd><kbd>l</kbd> | Shod commits            | `n`  |

### Fuzzy select (telescope)

| Keys                           | Action                       | Mode |
| :----------------------------- | :--------------------------- | :--- |
| <kbd>ctrl</kbd><kbd>j</kbd>    | Select next item             | `i`  |
| <kbd>ctrl</kbd><kbd>k</kbd>    | Select previous item         | `i`  |
| <kbd>esc</kbd>                 | Close                        | `i`  |
| <kbd>return</kbd>              | Confirm                      | `i`  |
| <kbd>ctrl</kbd><kbd>e</kbd>    | Open in current buffer       | `i`  |
| <kbd>ctrl</kbd><kbd>x</kbd>    | Open in horizintal split     | `i`  |
| <kbd>ctrl</kbd><kbd>v</kbd>    | Open in vertical split       | `i`  |
| <kbd>ctrl</kbd><kbd>t</kbd>    | Open in tab                  | `i`  |
| <kbd>ctrl</kbd><kbd>n</kbd>    | Create new file              | `i`  |
| <kbd>ctrl</kbd><kbd>p</kbd>    | Toggle preview               | `i`  |
| <kbd>ctrl</kbd><kbd>w</kbd>    | Toggle width                 | `i`  |
| <kbd>ctrl</kbd><kbd>u</kbd>    | Scrol preview donw           | `i`  |
| <kbd>ctrl</kbd><kbd>d</kbd>    | Scrol preview up             | `i`  |
| <kbd>tab</kbd>                 | Toggle selection             | `i`  |
| <kbd>shift</kbd><kbd>tab</kbd> | Toggle selection and move up | `i`  |
| <kbd>ctrl</kbd><kbd>q</kbd>    | Send to quick fix list       | `i`  |

### Quickfix list

| Keys                        | Action                                  | Mode |
| :-------------------------- | :-------------------------------------- | :--- |
| <kbd>d</kbd><kbd>d</kbd>    | Remove line                             | `n`  |
| <kbd>ctrl</kbd><kbd>j</kbd> | Show next item in quickfix list         | `n`  |
| <kbd>ctrl</kbd><kbd>k</kbd> | Show prepreviouss item in quickfix list | `n`  |

### Misc

| Keys                          | Action               | Mode |
| :---------------------------- | :------------------- | :--- |
| <kbd>leader</kbd><kbd>t</kbd> | Show highlight group | `n`  |

[MIT © Josa Gesell](LICENSE)
