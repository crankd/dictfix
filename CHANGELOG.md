# Changelog

All notable changes to dictfix will be documented in this file.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-03-26

### Added
- README with full documentation, usage examples, and privacy assessment
- MIT license
- CHANGELOG and release notes
- `install.sh` for symlinking to `~/bin`
- CLAUDE.md project context for AI-assisted development
- `dfx` shell alias for faster access
- Multi-word phrase correction support (e.g., "get hub" -> "GitHub")
- `--version` / `-v` flag

### Changed
- `espanso restart` now runs automatically after `add`, `remove`, and `import` commands (no manual restart needed)

## [1.0.0] - 2026-03-26

### Added
- Initial release
- `add` command to create or update corrections
- `remove` / `rm` command to delete corrections
- `list` / `ls` command to display all corrections
- `search` / `find` command to filter corrections
- `import` command for bulk CSV import
- `export` command for CSV export
- `test` command to preview corrections on sample text
- `help` / `-h` / `--help` for usage documentation
- Automatic espanso YAML config generation
- Case propagation support (preserves capitalization)
- Whole-word matching to prevent substring collisions
