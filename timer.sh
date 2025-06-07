#!/bin/bash
# Timer Script - Countdown to a Specific Time
#
# Description:
#   This script starts a countdown timer to a specified target time given in HH:MM:SS format.
#   If the specified time has already passed today, it counts down to that time on the next day.
#
# Usage:
#   ./timer.sh HH:MM:SS
#
# Example:
#   ./timer.sh 07:00:00
#
# Options:
#   -h, --help    Show this help message and exit.
#
# Author:
#   Thomas L.C. van Houten
# Creation date:
#   2025-06-02

show_help() {
  echo "Usage: $0 HH:MM:SS"
  echo "Starts a countdown until the specified time."
  echo "If the time has already passed today, it counts down to that time tomorrow."
  echo
  echo "Example:"
  echo "  $0 07:00:00"
  echo
  echo "Options:"
  echo "  -h, --help    Show this help message and exit."
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  show_help
  exit 0
fi

if [[ ! "$1" =~ ^([01]?[0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$ ]]; then
  echo "Error: Invalid time format. Use HH:MM:SS." >&2
  show_help
  exit 1
fi

TARGET_TIME="$1"
NOW_SECONDS=$(date +%s)
TODAY_DATE=$(date +%F)
TARGET_SECONDS=$(date -d "$TODAY_DATE $TARGET_TIME" +%s)

# If target time has passed, set to tomorrow
if (( TARGET_SECONDS <= NOW_SECONDS )); then
  TOMORROW_DATE=$(date -d "tomorrow" +%F)
  TARGET_SECONDS=$(date -d "$TOMORROW_DATE $TARGET_TIME" +%s)
fi

DEST_TIME=$(date -d "@$TARGET_SECONDS" +%T)

while (( TARGET_SECONDS > $(date +%s) )); do
  NOW=$(date +%s)
  REMAINING=$((TARGET_SECONDS - NOW))
  HOURS=$((REMAINING / 3600))
  MINUTES=$(((REMAINING % 3600) / 60))
  SECONDS=$((REMAINING % 60))
  printf "\rDestination: %s | Countdown: %02d:%02d:%02d" "$DEST_TIME" "$HOURS" "$MINUTES" "$SECONDS"
  sleep 1
done

echo
