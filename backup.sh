#!/usr/bin/env bash
#
# Program: backup.sh
# Description: 
#
# Author: Maxime Daraiche <maxiscoding@gmail.com>
#
#/ Usage: backup.sh [OPTIONS]... [ARGUMENTS]...
#/
#/ 
#/ OPTIONS
#/   -h, --help
#/                Print this help message
#/
#/ EXAMPLES
#/   backup.sh --user sysadmin 192.168.0.100:/backup/
#/   backup.sh --dry-run 192.168.0.100:/backup/

# Prerequisites:
#   - Having rsync installed on your machine
#   - Public key authentication set up on remote machine
# Optional:
#   - Provide exclude file for non-wanted files/directories

set -eou pipefail  # Don't hide errors within pipes
IFS=$'\n\t'

rsync_options=(
    --archive  # -a option
    --compress # -z option
    --partial  # -P option
    --progress # -P option
    --exclude-from 'backup_exclude.txt')
  
usage() { grep '^#/' "$0" | cut -c4- && exit 0; }

die() { printf "ERROR: %s\n" "$1" && exit 1; }

check_requirements() {
  if ! command -v "rsync" > /dev/null; then
    die "The rsync package is not installed on this system. Aborting." 
  fi 
}

parse_arguments() {
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      help)
	usage
	;;
      --dry-run)
	printf "[INFO] Running dry run.\n"
	rsync_options+=(--dry-run)
	shift
	;;
      --user)
	BACKUP_USER="$2"
	shift 2
	;;
      *)
	BACKUP_DEST="$1"
	shift
	;;
    esac
  done
}

make_backup_id() {
  local hostname=$(cat /etc/hostname)
  local today_date=$(date +%Y-%m-%d)
  
  echo "$hostname-$today_date"
}


main() {
  check_requirements
  
  parse_arguments "$@"
  
  local backup_id=$(make_backup_id)

  if [[ -z "$BACKUP_DEST" ]]; then
    die "The backup destination wasn't specified."
  fi
  
  printf "Creating backup with the following id: %s\n" "$backup_id"

  rsync "${rsync_options[@]}" /home/sysadmin/ "${BACKUP_USER}@${BACKUP_DEST}${backup_id}"
}

main "$@"
