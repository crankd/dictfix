# Changelog

All notable changes to dictfix will be documented in this file.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.1] - 2026-03-26

### Added
- `dfx` shell alias auto-added during `./install.sh` (detects .zshrc/.bashrc/.bash_profile, skips if already present)
- MIT disclaimer in README

### Changed
- Installer "Done" section no longer shows alias as a manual step (handled automatically)
- Version bump to 1.3.1

## [1.3.0] - 2026-03-26

### Added
- Interactive `install.sh` with prompts for dependency installation and service registration
- Espanso auto-start on reboot via service registration prompt during install
- Espanso config directory auto-creation during install
- Troubleshooting section in README covering common issues and bug reporting
- PATH check during install with guidance if `~/bin` is not in PATH

### Changed
- Installation section in README rewritten to reflect interactive installer flow
- `install.sh` now checks for Homebrew, Python 3, and espanso before proceeding
- Version bump to 1.3.0

## [1.2.0] - 2026-03-26

### Added
- `doctor` command — checks macOS version, processor, dictation status, microphone volume, espanso status, permissions, and provides actionable fix instructions
- "Improving Dictation Accuracy" section in README with OS-level tips

### Changed
- Removed hardcoded user-specific paths from CLAUDE.md (public repo compatibility)

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
