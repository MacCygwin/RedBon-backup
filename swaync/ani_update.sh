hyprctl -j getoption animations:enabled | grep -q '"bool": true' && echo true || echo false
