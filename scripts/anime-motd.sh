#!/usr/bin/env bash

TEXT=$'\033[38;2;205;214;244m'
SUBTEXT=$'\033[38;2;166;173;200m'
OVERLAY=$'\033[38;2;108;112;134m'
SURFACE=$'\033[38;2;69;71;90m'
RESET=$'\033[0m'
ITALIC=$'\033[3m'
BOLD=$'\033[1m'

accents=(
  $'\033[38;2;203;166;247m'  # mauve
  $'\033[38;2;245;194;231m'  # pink
  $'\033[38;2;137;220;235m'  # sky
  $'\033[38;2;250;179;135m'  # peach
  $'\033[38;2;166;227;161m'  # green
  $'\033[38;2;249;226;175m'  # yellow
  $'\033[38;2;148;226;213m'  # teal
  $'\033[38;2;180;190;254m'  # lavender
  $'\033[38;2;243;139;168m'  # red
  $'\033[38;2;245;224;220m'  # rosewater
)
ACCENT="${accents[$((RANDOM % ${#accents[@]}))]}"

quotes=(
  '"The world is not beautiful, therefore it is."|Kino no Tabi'
  '"A lesson without pain is meaningless."|Edward Elric'
  '"Fear is not evil. It tells you what your weakness is."|Gildarts'
  '"Bang."|Spike Spiegel'
  '"Believe in the me that believes in you."|Kamina'
  '"You should enjoy the little detours to the fullest."|Ging Freecss'
  '"The fake is of far greater value. In its deliberate attempt to be real, it is more real than the real thing."|Kaiki Deishuu'
  '"People who cannot throw something important away can never hope to change anything."|Armin Arlert'
  '"Whatever you lose, you will find it again. But what you throw away you will never get back."|Kenshin Himura'
  '"If you do not take risks, you cannot create a future."|Monkey D. Luffy'
  '"In this world, is the destiny of mankind controlled by some transcendental entity or law?"|Berserk'
  '"The loneliest people are the kindest. The saddest people smile the brightest."|Tokyo Ghoul'
  '"I am the bone of my sword."|Archer'
  '"Always, somewhere, someone is fighting for you. As long as you remember her, you are not alone."|Madoka Magica'
  '"Perhaps the distant dawn may never come. But still, you have to walk."|Vinland Saga'
  '"Hard work betrays none."|Hachiman Hikigaya'
  '"It is not the strong who survive but the survivors who are strong."|Reiner Braun'
  '"Power comes in response to a need, not a desire."|Goku'
  '"If you do not like your destiny, do not accept it."|Naruto Uzumaki'
  '"A dropout will beat a genius through hard work."|Rock Lee'
  '"Whatever you do, enjoy it to the fullest. That is the secret of life."|Rider'
  '"Sometimes, the questions are complicated and the answers are simple."|Dr. Seuss via FMA'
  '"The moment you think of giving up, think of the reason why you held on so long."|Natsu Dragneel'
  '"To know sorrow is not terrifying. What is terrifying is to know you cannot go back to happiness."|Matsumoto Rangiku'
  '"Knowing you are different is only the beginning. If you accept these differences you will be able to get past them and grow even closer."|Miss Kobayashi'
)

entry="${quotes[$((RANDOM % ${#quotes[@]}))]}"
quote="${entry%|*}"
author="${entry##*|}"

get_uptime() {
  if uptime -p >/dev/null 2>&1; then
    uptime -p | sed 's/^up //'
  else
    uptime | sed -E 's/^[^,]*up *//; s/, *[0-9]+ users?.*$//; s/, *load averages?:.*$//'
  fi
}

hour=$(date +%H)
if   (( hour < 5  )); then greet="late night"
elif (( hour < 12 )); then greet="morning"
elif (( hour < 17 )); then greet="afternoon"
elif (( hour < 21 )); then greet="evening"
else                        greet="night"
fi

user="${USER:-$(whoami)}"
time_now=$(date '+%H:%M')
up=$(get_uptime)

printf '\n'
printf '  %s❯%s %s%s%s%s %s— %s%s\n' \
  "$ACCENT" "$RESET" \
  "$ITALIC" "$SUBTEXT" "$quote" "$RESET" \
  "$OVERLAY" "$author" "$RESET"
printf '  %s%s%s %s·%s %s%s%s %s·%s %sup %s%s %s·%s %s%s%s\n' \
  "$ACCENT" "$user" "$RESET" \
  "$OVERLAY" "$RESET" \
  "$SUBTEXT" "$greet" "$RESET" \
  "$OVERLAY" "$RESET" \
  "$OVERLAY" "$up" "$RESET" \
  "$OVERLAY" "$RESET" \
  "$SUBTEXT" "$time_now" "$RESET"
printf '\n'
