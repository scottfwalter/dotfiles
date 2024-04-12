command=$(printf '%s\n' "Rebuild Launch Services" "Flush DNS" "three" | fzf)

case $command in

  "Rebuild Launch Services")
    /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -seed -r && echo "Launch Services have been rebuilt."
    ;;
  "Flush DNS")
    sudo killall -HUP mDNSResponder && echo "DNS has been flushed"
    ;;
  *)
    echo "Unsupported command"
    ;;
esac
