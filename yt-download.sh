#!/opt/homebrew/bin/bash
# download youtube songs and convert to mp3
# drop songs.txt into folder action ~/DropFile

DROPPATH="/Users/USER/DropFile"
SONGS_PATH="/Users/USER/Downloads/youtube-dl/songs"
SONGS="/Users/USER/DropFile/songs.txt"
VIDEOS="/Users/USER/DropFile/videos.txt"
SONGS_COUNT=$(cat $SONGS | wc -l)
VIDEOS_COUNT=$(cat $VIDEOS | wc -l)
MUSIC_PATH="/Users/USER/Music/Music/Media.localized/iTunes/iTunes Media/Music/Automatically Add to Music.localized/"

if [[ -f "$SONGS" && "$SONGS_COUNT" -gt 0 ]]; then
for x in $(cat "$SONGS"); do
   /opt/homebrew/bin/youtube-dl -x -o "/Users/USER/Downloads/youtube-dl/songs/%(title)s.%(ext)s" "$x"
done;

cd "$SONGS_PATH"
for y in *.webm; do
    /opt/homebrew/bin/ffmpeg -i "${y}" -vn -ab 192k -ar 44100 -y "${y%.webm}.mp3";
    rm "$y" >/dev/null 2>&1
done;

for z in *.m4a; do
    /opt/homebrew/bin/ffmpeg -i "${z}" -vn -ab 192k -ar 44100 -y "${z%.m4a}.mp3";
    rm "$z" >/dev/null 2>&1
done;

for v in *.mp3; do
    mv *.mp3 "$MUSIC_PATH"
done;

fi

#--------------------------------------------------
# download youtube videos
# drop videos.txt into folder action ~/DropFile

if [[ -f "$VIDEOS" && "$VIDEOS_COUNT" -gt 0 ]]; then
for j in $(cat "$VIDEOS"); do
   /opt/homebrew/bin/youtube-dl -o "/Users/USER/Downloads/youtube-dl/videos/%(title)s.%(ext)s" "$j"
done;

fi

rm -fr "$DROPPATH/"*

exit 0
