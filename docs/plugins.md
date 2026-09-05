# Novix Plugin System

## Overview

The Novix Plugin System allows you to extend your OS with custom functionality. Plugins are installed via GitHub repositories and managed through the xudo command.

## Quick Start

### Install a Plugin

```bash
xudo install https://github.com/user/plugin-name
```

### Install Without Prompt

```bash
xudo install https://github.com/user/plugin-name -p
```

### List Installed Plugins

```bash
xudo list
```

### Update All Plugins

```bash
xudo update all
```

### Update Specific Plugin

```bash
xudo update plugin-name
```

### Uninstall a Plugin

```bash
xudo uninstall plugin-name
```

### Show Plugin Info

```bash
xudo info plugin-name
```

## Plugin Structure

Each plugin repository should have the following structure:

```
plugin-repo/
├── plugin.json          # Plugin metadata (required)
├── install.sh          # Installation script (optional)
├── uninstall.sh        # Uninstallation script (optional)
├── update.sh           # Update script (optional)
└── src/                # Source files
    └── ...
```

### plugin.json Format

```json
{
  "name": "plugin-name",
  "version": "1.0.0",
  "description": "Plugin description",
  "author": "Author Name",
  "license": "MIT",
  "homepage": "https://github.com/user/plugin-name"
}
```

## Commands Reference

| Command | Description |
|---------|-------------|
| xudo install <url> [-p] | Install plugin from GitHub URL |
| xudo uninstall <name> | Uninstall a plugin |
| xudo update all | Update all installed plugins |
| xudo update <name> | Update specific plugin |
| xudo list | List all installed plugins |
| xudo info <name> | Show plugin information |
| xudo help | Show help |

## Dependencies

- jq - JSON processor (required)
- git - Version control (required)
- gcc - C compiler (optional, for C-based plugins)

## Creating a Plugin

1. Create a GitHub repository for your plugin
2. Add a plugin.json file with metadata
3. Add optional scripts: install.sh, uninstall.sh, update.sh
4. Add your plugin source code
5. Users can install with: xudo install https://github.com/your/repo

## Example: Hello World Plugin

See plugins/hello-world/ for a complete example.