foreach($extension in Get-Content .\vscode-extensions-for-install.txt) {
	code --install-extension $extension
}
Write-Output "Finished installing VScode extensions."