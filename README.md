scripts
=======

script dump hole

## Setup

### Local Installation

1. Add `~/bin` to your PATH (if not already):
   ```bash
   export PATH="$HOME/bin:$PATH"
   ```

2. Enable ZSH completions by adding to your `.zshrc`:
   ```bash
   fpath=(~/bin/completions $fpath)
   autoload -Uz compinit
   compinit
   ```

3. Reload your shell:
   ```bash
   exec zsh
   ```

### Remote Host Deployment

For deploying to remote hosts (e.g., hypervisors):

1. Clone the repo:
   ```bash
   git clone <repo-url> ~/bin
   ```

2. Add to PATH in `/etc/profile.d/custom.sh` or similar:
   ```bash
   export PATH="$HOME/bin:$PATH"
   ```

3. For ZSH users, add to shell config:
   ```bash
   fpath=(~/bin/completions $fpath)
   autoload -Uz compinit
   compinit
   ```

4. Set any required environment variables (script-specific)

## Scripts with Completions

- **appdir**: Navigate to docker service directories
  - Requires: `DOCKER_APP_ROOT` environment variable
  - Completion: `completions/_appdir`
