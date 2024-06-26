#!/bin/bash
#
#

case $1 in
  msg)
    # curl -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
    #   -d chat_id="${CHAT_ID}" \
    #   -d "disable_web_page_preview=true" \
    #   -d "parse_mode=html" \
    #   -d text="$(echo "$2" | sed 's/%nl/\n/g')"

      curl -sX POST https://api.telegram.org/bot"${token}"/sendMessage \
        -d chat_id="${chat_id}" \
        -d parse_mode=Markdown -\
        -d disable_web_page_preview=true \
        -d text="$1" &>/dev/null
  ;;
  up | upload)
    curl -F chat_id="${CHAT_ID}" \
      -F document=@"$2" \
      -F parse_mode=markdown https://api.telegram.org/bot${BOT_TOKEN}/sendDocument \
      -F caption="$(echo "$3" | sed 's/%nl/\n/g')"
  ;;
esac