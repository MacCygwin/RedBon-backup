sh -c "hyprctl -j getoption animations:enabled | awk '{print $2}' | grep -q '1' && echo true || echo false"
