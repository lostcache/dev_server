Dev Server

A simple, cross-platform development server script that watches for file changes and automatically re-runs commands.

## Features

- Watches a specified directory for file changes
- Automatically re-runs your command when files change
- Cross-platform support (macOS and Linux)

## Installation

### Dependencies

- **macOS**: `fswatch`

```bash
brew install fswatch
```

- **Linux**: `inotify-tools`

```bash
apt-get install inotify-tools
```

## Usage

```bash
./dev_server.sh <directory-to-watch> <command-to-run>
```

### Examples

```bash
# Watch the current directory and run tests when files change
./dev_server.sh . "npm test"

# Watch the src directory and rebuild your project
./dev_server.sh ./src "make build"

# Watch multiple directories using bash expansion
./dev_server.sh "{src,tests}" "cargo test"
```

## License

MIT
