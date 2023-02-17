function Open-Current-Directory {
    explorer .
}

Set-Alias e. Open-Current-Directory
New-Alias which Get-Command
New-Alias exp explorer.exe
New-Alias vim nvim

#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
(& "~\scoop\apps\miniconda3\current\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
#endregion

Invoke-Expression (&starship init powershell)