$Env:GIT_TERMINAL_PROMPT=0
$cloudLogin = [uri]::EscapeDataString("$(cloudUsername)")
$cloudEscapedPassword= [uri]::EscapeDataString("$(cloudPassword)")
$folderName = "$(solutionNamespace).Cloud"
$cloneUrl = "https://${cloudLogin}:${cloudEscapedPassword}@$(cloudGit)"

Write-Host $cloneUrl

git clone ${cloneUrl} ${folderName}