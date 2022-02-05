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
#/   backup.sh --user sysadmin --host 192.168.0.100:/backup
#/   backup.sh --dry-run --host 192.168.0.100:/backup

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
  
# Boy, what a very useful wizardry, jolly good !
usage() {
  grep '^#/' "$0" | cut -c4-
  exit 0
}

die() {
  local err_msg="$1"
  printf "ERROR: %s\n" "$err_msg" && exit 1
}

check_requirements() {
  if ! command -v "rsync" > /dev/null; then
    die "The rsync package is not installed on this system. Aborting." 
  fi 
}

parse_arguments() {
  for i in "$@"; do
    case "$i" in
      help)
	usage
	;;
      --dry-run)
	printf "[INFO] Running dry run.\n"
	rsync_options+=(--dry-run)
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

  printf "Creating backup with the following id: %s\n" "$backup_id"

  rsync "${rsync_options[@]}" /home/sysadmin/ sysadmin@192.168.0.104:/backup/"$backup_id"
}

main "$@"
