# git-archive-branch / git-unarchive-branch / git-list-archived

Archive git branches by creating annotated tags under `archive/` and deleting the branch. Branches can be listed and restored later with full metadata preserved.

## Commands

### git archive-branch

```
git archive-branch [options] <branch> [<branch>...]
```

Creates an annotated tag at `archive/<branch>` and deletes the local branch.

**Options:**

| Flag | Description |
|------|-------------|
| `-m <message>` | Extra annotation text appended to the tag message |
| `-n, --dry-run` | Show what would happen without doing it |
| `-f, --force` | Force-delete unmerged branches (`git branch -D`) and overwrite existing archive tags |
| `-r, --include-remote` | Also delete the branch from the remote |
| `-R <remote>` | Specify remote (default: `origin`, implies `-r`) |
| `--list` | Shortcut that execs `git-list-archived` |
| `-h, --help` | Show help |

**Safety checks** (all validated before any mutations):

- Refuses to archive the currently checked-out branch
- Refuses if the branch doesn't exist locally
- Refuses if `archive/<branch>` tag already exists (unless `--force`)
- Tag is always created before the branch is deleted — if tagging fails, the branch is preserved
- Remote deletion is best-effort (warns on failure, local archive is already done)

**Multi-branch behavior:** fail-fast. If any branch fails validation, no branches are processed. Branches already archived in the loop are preserved.

**Tag message format:**

```
Archived branch: <branch>

Archived-By: Name <email>
Archived-Date: 2026-02-16T14:30:00Z
Original-Branch: <branch>
Branch-Tip: a1b2c3d
Branch-Author: Name <email>
Branch-Date: 2026-02-15T10:00:00-05:00
Branch-Subject: Last commit message

<user message if -m provided>
```

### git unarchive-branch

```
git unarchive-branch [options] <branch> [<branch>...]
```

Restores branches from their `archive/` tags.

Accepts both `foo` and `archive/foo` — the `archive/` prefix is stripped automatically.

**Options:**

| Flag | Description |
|------|-------------|
| `-n, --dry-run` | Show what would happen without doing it |
| `-k, --keep-tag` | Restore the branch but don't delete the archive tag |
| `-h, --help` | Show help |

**Errors if:**

- The archive tag doesn't exist
- A local branch with that name already exists

### git list-archived

```
git list-archived [options]
```

Lists all `archive/*` tags with parsed metadata.

**Options:**

| Flag | Description |
|------|-------------|
| `-v, --verbose` | Show full tag annotation |
| `-h, --help` | Show help |

**Default output:**

```
feature/foo
  Tag:       archive/feature/foo
  Archived:  2026-02-16T14:30:00Z
  By:        Name <email>
  Commit:    a1b2c3d Last commit message
```

## Examples

Archive a branch with a note:

```sh
git archive-branch -m "superseded by feature/bar" feature/foo
```

Archive multiple branches:

```sh
git archive-branch feature/old-1 feature/old-2 feature/old-3
```

Archive and remove from remote:

```sh
git archive-branch -r feature/foo
git archive-branch -R upstream feature/foo   # non-origin remote
```

Dry run to preview:

```sh
git archive-branch -n feature/foo
```

List all archived branches:

```sh
git list-archived
git list-archived -v   # full tag annotations
```

Restore an archived branch:

```sh
git unarchive-branch feature/foo
git unarchive-branch archive/feature/foo   # also works
```

Restore but keep the archive tag:

```sh
git unarchive-branch -k feature/foo
```

Force-archive an unmerged branch, overwriting an existing tag:

```sh
git archive-branch -f feature/experimental
```
