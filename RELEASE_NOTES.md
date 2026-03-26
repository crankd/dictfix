# Release Notes — dictfix v1.1.0

**Release date:** 2026-03-26

## What's New

### Auto-restart espanso
Previously, after adding or removing corrections you had to manually run `espanso restart`. Now dictfix handles this automatically — corrections are live the moment you add them.

### Multi-word phrase support
Corrections aren't limited to single words. Fix entire phrases that dictation gets wrong:

```bash
dfx add "get hub" "GitHub"
dfx add "java script" "JavaScript"
```

### `dfx` shorthand alias
For faster access, `dfx` is available as a shell alias:

```bash
dfx add "gonna" "going to"
dfx ls
```

### Project documentation
- Full README with usage, examples, privacy assessment, and installation instructions
- MIT license
- CHANGELOG for tracking changes across versions

## Upgrade

If you already have dictfix installed, pull the latest and the symlink picks up changes automatically:

```bash
cd /path/to/dictfix
git pull
```

## Full Changelog

See [CHANGELOG.md](CHANGELOG.md) for the complete list of changes.
