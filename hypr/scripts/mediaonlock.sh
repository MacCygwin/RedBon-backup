media_info=$(playerctl metadata --format '  {{title}}')

echo "$media_info"
