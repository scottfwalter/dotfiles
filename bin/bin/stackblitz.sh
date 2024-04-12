REPO_NAME=$(basename -s .git $(git remote show -n origin | grep Fetch | cut -d: -f2-))
echo $REPO_NAME
open "https://stackblitz.com/github/scottfwalter/$REPO_NAME"
