# dictfix

CLI tool for managing macOS dictation (speech-to-text) corrections, powered by [espanso](https://espanso.org).

## Problem

macOS dictation frequently transcribes words incorrectly — especially with regional accents, technical vocabulary, or brand names. Built-in Text Replacements don't work reliably in Terminal or VS Code because the correction event fires too late. `dictfix`, a CLI tool, solves this by managing an [espanso](https://espanso.org) correction list that replaces misunderstood words and phrases the instant they appear, in any app on the system.

## Usage

```bash
dictfix add <wrong> <correct>       # Add or update a correction
dictfix remove <wrong>              # Remove a correction (alias: rm)
dictfix list                        # List all corrections (alias: ls)
dictfix search <term>               # Search corrections (alias: find)
dictfix import <csv_file>           # Bulk import from CSV (wrong,correct per line)
dictfix export [csv_file]           # Export to CSV (stdout if no file given)
dictfix test <text>                 # Preview corrections applied to text
dictfix doctor                      # Check system settings for optimal dictation accuracy
dictfix help                        # Show full help (alias: -h, --help)
dictfix --version                   # Show version
```

### Shorthand

Add this alias to your shell profile for faster access:

```bash
alias dfx='dictfix'
```

Then use `dfx` anywhere you would use `dictfix`:

```bash
dfx add "wanna" "want to"
dfx ls
dfx rm "wanna"
```

## Examples

### Single-word corrections

```bash
# Accent-related misrecognition
dfx add "contant" "content" # word misrecognition
dfx add "tronno" "Toronto" # voiced alveolar flap
dfx add "chrono" "Toronto" # voiced alveolar flap
dfx add "warshington" "washington" # City name misrecognition
dfx add "wadder" "water" # word misrecognition

# Informal speech cleanup
dfx add "gonna" "going to"
dfx add "wanna" "want to"
dfx add "gotta" "got to"
dfx add "kinda" "kind of"
dfx add "shoulda" "should have"
dfx add "coulda" "could have"
dfx add "woulda" "would have"

# Brand name misrecognition
dfx add "cloud" "claude"
dfx add "get hub" "GitHub"
dfx add "get her" "GitHub"
dfx add "java script" "JavaScript"
dfx add "type script" "TypeScript"
dfx add "post gress" "Postgres"
dfx add "dock her" "Docker"
```

### Multi-word / phrase corrections

```bash
dfx add "get hub" "GitHub"          # Brand name misrecognition
dfx add "get her" "GitHub"
dfx add "java script" "JavaScript"
dfx add "type script" "TypeScript"
dfx add "post gress" "Postgres"
dfx add "docking her" "Docker"
```

### Bulk import from CSV

Create a CSV file with `wrong,correct` per line:

```csv
Contant,content
get hub,GitHub
gonna,going to
```

Then import:

```bash
dfx import ~/my-corrections.csv
```

### Preview corrections

```bash
dfx test "I wanna push this to get hub"
# Original:  I wanna push this to get hub
# Corrected: I want to push this to GitHub
```

## Installation

```bash
git clone https://github.com/crankd/dictfix.git
cd dictfix
./install.sh
```

The installer walks you through each step interactively:

1. **Dependencies** — checks for Homebrew and Python 3, prompts to install espanso if missing
2. **dictfix CLI** — symlinks the script to `~/bin/dictfix`
3. **Service registration** — prompts to register espanso as a login service (auto-starts on reboot) and optionally starts it immediately
4. **Espanso config** — creates the espanso config directory if it doesn't exist

After installation, grant macOS permissions when prompted:

- **System Settings > Privacy & Security > Accessibility** — enable Espanso
- **System Settings > Privacy & Security > Input Monitoring** — enable Espanso

Then verify your setup:

```bash
dictfix doctor
```

## Improving Dictation Accuracy

Run `dictfix doctor` to check your system settings:

```bash
dfx doctor
```

This checks macOS version, processor type, dictation status, microphone input volume, espanso status, permissions, and correction count. It flags issues and provides fix instructions.

### Tips Beyond dictfix

dictfix corrects errors *after* they happen. To reduce errors at the source:

- **Microphone**: Ensure input volume is 70%+ in System Settings > Sound > Input. Use a headset in noisy or echoey environments.
- **"Correct that"**: Say "Correct that" immediately after a misrecognized word to see alternatives. Select the correct option by number.
- **Enhanced Dictation**: On Apple Silicon Macs, on-device processing provides better accuracy. Toggle dictation off and back on in System Settings > Keyboard > Dictation to reset the service.
- **Language settings**: Verify dictation language matches the language you are speaking in System Settings > Keyboard > Dictation > Language.
- **Keep macOS updated**: Apple regularly improves the speech recognition model. Specific phonetic bugs (e.g., words with 'R') are often fixed in point releases.

## Dependencies

| Dependency | Purpose | Install |
|-----------|---------|---------|
| [espanso](https://espanso.org) | Open-source text expander that performs the actual corrections system-wide | `brew install espanso` |
| Python 3 | Runtime for the dictfix CLI (stdlib only, no pip packages) | Pre-installed on macOS |

## Data Storage

Corrections are stored locally at:

```
~/.config/espanso/match/dictation-fixes.yml
```

This file contains your personal correction data and is excluded from version control via `.gitignore`. It never leaves your machine.

## Privacy and Security

**Assessment date: 2026-03-26**

dictfix itself is a local Python script with no network activity. Its dependency, espanso, has been evaluated for privacy and security:

| Factor | Assessment |
|--------|-----------|
| Runs locally | Yes — fully local, no cloud component |
| Data sent externally | No (only network activity is optional package downloads from GitHub) |
| Telemetry / analytics | None — zero telemetry code in the codebase |
| Open source | Yes — GPL-3.0, written in Rust, ~13.5k GitHub stars |
| Keystroke logging | Intercepts but does not log; only last 3 characters held in memory |
| Known CVEs | Zero (NIST NVD) |
| Formal security audit | None published |
| macOS permissions | Accessibility + Input Monitoring (standard for text expanders) |

**Summary**: All correction data stays on your machine. Espanso is open-source, has no telemetry, does not log keystrokes, and has no known vulnerabilities. The primary trust decision is granting Accessibility and Input Monitoring permissions, which is inherent to any text expander. The source code is fully auditable at [github.com/espanso/espanso](https://github.com/espanso/espanso).

## Troubleshooting

### Is espanso installed?

```bash
brew list --cask espanso
```

If not installed: `brew install espanso`

### Is the service running?

```bash
espanso status
```

If not running:

```bash
espanso start
```

If espanso won't start, it likely needs macOS permissions:

1. Open **System Settings > Privacy & Security > Accessibility** — enable Espanso
2. Open **System Settings > Privacy & Security > Input Monitoring** — enable Espanso
3. Try `espanso start` again

### Does espanso auto-start on reboot?

Check if the LaunchAgent exists:

```bash
ls ~/Library/LaunchAgents/com.federicoterzi.espanso.plist
```

If missing, register it:

```bash
espanso service register
```

### Corrections aren't being applied

1. Verify espanso is running: `espanso status`
2. Verify your corrections exist: `dictfix ls`
3. Check if Secure Input is active (blocks espanso in password fields — this is expected)
4. Some apps may need a restart to recognize espanso
5. Run `dictfix doctor` for a full diagnostic

### espanso was working but stopped

This can happen after a macOS update revokes permissions. Re-grant:

1. **System Settings > Privacy & Security > Accessibility** — remove and re-add Espanso
2. **System Settings > Privacy & Security > Input Monitoring** — remove and re-add Espanso
3. Run `espanso restart`

### Antivirus flags espanso

Some antivirus software (e.g., Bitdefender) flags espanso as suspicious because text expanders use keylogger-like techniques for keystroke detection. This is a **false positive**. Espanso is open-source, has zero telemetry, and does not log keystrokes. Add it to your antivirus allowlist.

### The `dfx` alias doesn't work

The alias must be loaded in your shell session. Either:

- Open a new terminal tab/window
- Run `source ~/.zshrc` (or your shell profile)
- Verify the alias exists: `grep dfx ~/.zshrc`

You can always use the full `dictfix` command directly.

### Reporting a bug

File an issue at [github.com/crankd/dictfix/issues](https://github.com/crankd/dictfix/issues) with:

- Output of `dictfix doctor`
- Output of `dictfix --version`
- macOS version (`sw_vers`)
- Description of the problem and steps to reproduce

## Contributing

Contributions are welcome! Here's the process:

### Getting started

1. Fork the repo on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/<your-username>/dictfix.git
   cd dictfix
   ```
3. Create a feature branch from `dev`:
   ```bash
   git checkout dev
   git checkout -b feat/your-feature-name
   ```

### Development workflow

- **All work happens on feature branches off `dev`** — never commit directly to `main`
- `main` is the release branch (published, tagged)
- `dev` is the integration branch (merged to `main` at release time)
- dictfix is a single Python script with **zero pip dependencies** (stdlib only) — keep it that way. espanso is the only external dependency.
- Run `./install.sh` to symlink your local copy to `~/bin/dictfix` for testing

### Submitting changes

1. Test your changes locally:
   ```bash
   dictfix doctor          # verify setup
   dictfix add "test" "ok" # test mutations
   dictfix ls              # verify
   dictfix rm "test"       # clean up
   ```
2. Commit with a clear message describing the "why":
   ```bash
   git commit -m "Add support for regex triggers

   Allows users to define pattern-based corrections for common
   dictation errors that vary slightly each time."
   ```
3. Push your branch and open a PR against `dev`:
   ```bash
   git push origin feat/your-feature-name
   gh pr create --base dev
   ```

### PR guidelines

- Keep PRs focused — one feature or fix per PR
- Update `CHANGELOG.md` under an `[Unreleased]` section
- Update `README.md` if you add a new command or change behavior
- No external Python dependencies (stdlib only)
- Personal correction data (`.yml`, `.csv`) must never be committed

### Reporting bugs

File an issue at [github.com/crankd/dictfix/issues](https://github.com/crankd/dictfix/issues) with:

- Output of `dictfix doctor`
- Output of `dictfix --version`
- macOS version (`sw_vers`)
- Steps to reproduce

### Ideas for contributions

- Linux support (espanso is cross-platform, dictfix currently assumes macOS)
- Tab completion for zsh/bash
- `dictfix undo` to revert the last add/remove
- Regex-based trigger patterns
- Community-maintained correction packs (e.g., medical terms, legal terms)

## License

[MIT](LICENSE)

### Disclaimer

This software is provided "as is", without warranty of any kind, express or implied. The authors are not responsible for any damages, data loss, or unintended behavior arising from the use of this software. dictfix modifies espanso configuration files on your local machine and restarts the espanso service — use at your own risk. By using this software, you agree to the terms of the [MIT License](LICENSE).
