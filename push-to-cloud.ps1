$Env:GIT_TERMINAL_PROMPT=0

git config user.email "devops@dotcontrol.nl"
git config user.name "DevOps Release”

git pull

if(git status --porcelain) {
    git add .
    git status
    git commit -m "Release $(Release.ReleaseId) via Azure DevOps"
}

git push origin master --force