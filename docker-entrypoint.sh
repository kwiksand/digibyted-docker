#!/bin/sh
set -e
DIGIBYTE_DATA=/home/digibyte/.digibyte
cd /home/digibyte/digibyted

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for digibyted"

  set -- digibyted "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "digibyted" ]; then
  mkdir -p "$DIGIBYTE_DATA"
  chmod 700 "$DIGIBYTE_DATA"
  chown -R digibyte "$DIGIBYTE_DATA"

  echo "$0: setting data directory to $DIGIBYTE_DATA"

  set -- "$@" -datadir="$DIGIBYTE_DATA"
fi

if [ "$1" = "digibyted" ] || [ "$1" = "digibyte-cli" ] || [ "$1" = "digibyte-tx" ]; then
  echo
  exec gosu digibyte "$@"
fi

echo
exec "$@"
