chuck initialize.ck --silent
mkdir -p temp && for f in *.wav; do lame --vbr-new -V 3  "$f" ./temp/"${f%.wav}.mp3"; done
