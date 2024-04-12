#!/usr/bin/env /opt/homebrew/bin/bash

cat > $1 << EOF
#!/usr/bin/env /opt/homebrew/bin/bash
#!/usr/bin/env /bin/zsh
#!/usr/bin/env zx

echo "Here is your script!"
EOF

chmod 755 $1
