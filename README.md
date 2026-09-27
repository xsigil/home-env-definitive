# home-env-definitive

Minimalist, dependency-free UNIX operational environment and toolchain.

Built around POSIX shell scripts, `gawk`, native kernel subsystems (`nftables`, `memfd_create`), and offline lexical corpora. Designed for zero runtime bloat, determinism, and high signal-to-noise ratio.

---

## Directory Structure

```text
.
├── bin/            # Pure standalone utilities (POSIX sh, Bash, gawk)
├── config/         # XDG-compliant configurations (tmux, zsh, nmap, proxychains)
├── home/           # Minimal dotfiles targeted for $HOME (.zshenv)
├── install.sh      # Idempotent symlink deployment script
└── local/share/    # Persistent corpora and database storage
    ├── db/         # SQLite databases (Japanese WordNet)
    └── dict/       # Dictionaries (EDICT)

```

---

## Notable Utilities (`bin/`)

### Network & Kernel Subsystems

* **`dns-intercept`**: Atomic outbound DNS (UDP/TCP 53) diversion to `127.0.0.1:53` (local Unbound/resolver) via an isolated `nftables` table. Zero lingering rules upon deactivation.
* **`tor-chrome`**: Launches an ephemeral, incognito Chromium instance bound strictly to Tor SOCKS5 (`127.0.0.1:9050`) with host-resolver isolation (`MAP * ~NOTFOUND`) and WebRTC suppression to prevent DNS and interface leaks.
* **`ssh-socks`**: Dynamic SOCKS5 proxy manager backed by persistent SSH multiplexed sockets.
* **`change_gw`**: Runtime default gateway switching utility for interface migration.
* **`pcap-prob`**: Raw pcap inspect tool for passive traffic auditing.

### Lexical & Knowledge Processing

* **`wordconcept`**: Traverses hypernym DAG hierarchies directly within Japanese WordNet (`wnjpn.db`) using SQLite recursive CTEs (`WITH RECURSIVE`) to extract root ontologies in milliseconds.
* **`eng-download` & `pronounce**`: Offline-first phonetic dictionary engine backed by cached Oxford MP3 audio streams.
* **`nandoku`**: Japanese rare and difficult kanji reading lookup utility.

### Workspace & Session Control

* **`tmux-sessionizer`**: Fast project-space switcher tailored for segregated public/secret workspaces (`_laier/public`, `_laier/secret`) via `fzf` popups.
* **`epigraph-rotate`**: Daemon driving `epigraph-wall`, an in-memory wallpaper engine that projects LaTeX Fraktur typography into `hyprpaper` directly via `memfd_create(2)` without disk I/O.
* **`this-week`**: Calendar arithmetic engine for boundary-safe weekly planning templates.
* **`transpose`**: Dependency-free TSV matrix transposition implemented purely in `gawk`.
* **`tsv2latex`**: Escaped, column-aware TSV to LaTeX tabular converter.
* **`urlextract`**: Fast RFC-compliant URL and unique domain stream extractor for pipeline consumption.

---

## Corpora & Offline Data

Lexical resources reside in `local/share/`:

* **Japanese WordNet**: Embedded SQLite schema querying synsets, definitions, and hypernym links.
* **EDICT**: Japanese-English electronic dictionary source.

*Note: Large binary databases (`*.db`, `*.sqlite3`) are git-ignored. Place `wnjpn.db` under `local/share/db/` manually.*

---

## Installation

Symlinks are deployed to standard XDG paths (`~/.config`, `~/.local/share`, `~/.local/bin`):

```sh
git clone [https://github.com/](https://github.com/)<your-username>/home-env-definitive.git
cd home-env-definitive
./install.sh

```

---

## Licensing

* Custom shell scripts, AWK programs, and configurations are released under the **MIT License**.
* Lexical data files retain their respective upstream licenses:
* **EDICT**: Distributed under the [CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/?utm_source=gemini) license (The Electronic Dictionary Research and Development Group). See `local/share/dict/LICENSE-EDICT.txt`.
* **Japanese WordNet**: Copyright (C) NICT. See `local/share/db/LICENSE-WNJPN.txt`.
