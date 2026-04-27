#!/usr/bin/env bash

set -eo pipefail

if [[ ! -f "$HOME/bin/nvim-update" ]]; then
  mkdir -p "$HOME/bin"
  cat > "$HOME/bin/nvim-update" <<'EOF'
#!/usr/bin/env bash
exec bash ~/.config/nvim/update.sh "$@"
EOF
  chmod +x "$HOME/bin/nvim-update"
fi

################################################################################
# Config
URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz"
KEEP_BACKUP_COUNT=5
################################################################################

echo ""
echo "################################################################################"
echo "# Backup neovim"

bin_dir="$HOME/bin"
dir="$bin_dir/neovim"
date=$(date "+%Y-%m-%d")
backup_name="neovim_${date}.tar.gz"

cd ~/.config/nvim 2>/dev/null || exit 1

if [[ -d $dir ]]; then
  i=1

  while [[ -f "${bin_dir}/${backup_name}" ]]; do
    backup_name="neovim_${date}_${i}.tar.gz"
    i=$((i + 1))
  done

  last_backup="$(ls -t "${bin_dir}"/neovim_*.tar.gz 2>/dev/null | head -n1)"

  echo "Backing up... $backup_name"
  (cd $bin_dir && tar -zcvf "${backup_name}" "neovim" 2>/dev/null)

  # Delete new backup if identical to the last one
  if [[ -n "$last_backup" && -f "${bin_dir}/${backup_name}" ]]; then
    new_hash="$(tar -xzf "${bin_dir}/${backup_name}" -O 2>/dev/null | md5)"
    old_hash="$(tar -xzf "$last_backup" -O 2>/dev/null | md5)"
    if [[ "$new_hash" == "$old_hash" ]]; then
      echo "No changes detected since last backup. Removing new backup."
      rm "${bin_dir}/${backup_name}"
    fi
  fi

  # Rotate old backups: keep all of today's, only latest per day for older days,
  # and keep at most KEEP_BACKUP_COUNT older days
  mapfile -t all_backups < <(ls -t "${bin_dir}"/neovim_*.tar.gz 2>/dev/null)
  seen_days=()
  kept_days=0
  for b in "${all_backups[@]}"; do
    name="$(basename "$b")"
    # Extract date (YYYY-MM-DD) from filename
    day="$(echo "$name" | sed -E 's/^neovim_([0-9]{4}-[0-9]{2}-[0-9]{2}).*/\1/')"

    # Always keep today's backups
    if [[ "$day" == "$date" ]]; then
      continue
    fi

    # For older days: keep only the latest backup (first seen per day, since sorted newest-first)
    if [[ " ${seen_days[*]} " == *" $day "* ]]; then
      echo "Removing backup for $day: $name"
      rm "$b"
      continue
    fi

    seen_days+=("$day")
    kept_days=$((kept_days + 1))

    # Remove if beyond KEEP_BACKUP_COUNT
    if [[ $kept_days -gt $KEEP_BACKUP_COUNT ]]; then
      echo "Removing old backup: $name"
      rm "$b"
    fi
  done
fi

if [[ ! -z "$(git status -s)" ]]; then
  echo ""
  echo "################################################################################"
  echo "# Commit config"


  msg="$(git log --oneline | head -n1 | cut -d ' ' -f 2- 2>/dev/null || true)"

  echo "msg: '$msg'"

  commit_args=()

  if [[ $msg == "wip: auto commit "* ]]; then
    commit_args+=("--amend")
  fi

  git add -A
  git commit -m "wip: auto commit ($(date "+%Y-%m-%d %H:%M:%S"))" "${commit_args[@]}"
fi

echo ""
echo "################################################################################"
echo "# Update neovim"

rm -rf $dir && mkdir -p $dir

curl -SsL $URL | tar zxv --strip-components=1 --directory=$dir 2>/dev/null

echo ""
echo "################################################################################"
echo "# Update config"

checksum_before="$(md5 -q ~/.config/nvim/update.sh)"
(cd ~/.config/nvim && git pull origin main --rebase)
checksum_after="$(md5 -q ~/.config/nvim/update.sh)"

if [[ "$checksum_before" != "$checksum_after" ]]; then
  echo "update.sh changed, restarting..."
  exec bash ~/.config/nvim/update.sh "$@"
fi

echo ""
echo "################################################################################"
echo "# Update plugins"

nvim --headless "+Lazy! sync" -c "qall"

echo ""
echo "################################################################################"
echo "# Update tools"

nvim --headless -c 'autocmd User MasonUpdateAllComplete quitall' -c 'MasonUpdateAll'

echo ""
echo "################################################################################"
echo "# Update treesitter"

nvim --headless -c 'lua vim.notify = function(msg, ...) io.write(msg .. "\n") end' -c "TSUpdate" -c "qall"


