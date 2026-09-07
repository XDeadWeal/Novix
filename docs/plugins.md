# Novix Plugin System

## Overview

Plugins are installed via GitHub repos and managed through `xudo`.

## Quick Start

```bash
xudo install https://github.com/user/plugin-name
xudo install https://github.com/user/plugin-name -p
xudo list
xudo update all
xudo uninstall plugin-name
xudo info plugin-name
```

## Plugin Structure

```
plugin-repo/
	plugin.json          # required
	install.sh           # optional
	uninstall.sh        # optional
	update.sh           # optional
	src/                # source files
```

## Commands

| Command | Description |
|---------|-------------|
| xudo install <url> [-p] | Install from GitHub |
| xudo uninstall <name> | Uninstall |
| xudo update all | Update all |
| xudo update <name> | Update one |
| xudo list | List installed |
| xudo info <name> | Show info |

## Dependencies

- jq (required)
- git (required)
- gcc (optional)

## Example: hello-world

See `plugins/hello-world/` for a complete example.
