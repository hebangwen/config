function Open-Current-Directory {
    explorer .
}


function rcode($remote_name, $remote_path) {
    code --folder-uri=vscode-remote://ssh-remote+$remote_name/$remote_path
}

function Replace-NewLine-In-PDF {
	$s = $(Get-Clipboard) | ? {$_ -notlike "file:*"} | ? {$_ -notlike "条款*"}
	$s = $s -join ""
	echo $s
	Set-Clipboard $s
}

New-Alias rnip Replace-NewLine-In-PDF

Set-Alias e. Open-Current-Directory
New-Alias which Get-Command
New-Alias exp explorer.exe
New-Alias vim nvim

function git-status { git status }
New-Alias gst git-status

function git-diff { git diff }
New-Alias gd git-diff

function git-log { git log --decorate --graph}
New-Alias glog git-log

function git-log-stat { git log --stat }
New-Alias glgs git-log-stat

function hexo-clean-generate-deploy { hexo clean; hexo g; hexo d }
New-Alias hexo-cgd hexo-clean-generate-deploy

function hexo-clean-generate-server { hexo clean; hexo g; hexo s }
New-Alias hexo-cgs hexo-clean-generate-server

# function git-commit-m { git commit -m $args }
# New-Alias gcm git-commit-m

#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
(& "~\scoop\apps\miniconda3\current\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
#endregion

Invoke-Expression (&starship init powershell)
# open history suggestion
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History

