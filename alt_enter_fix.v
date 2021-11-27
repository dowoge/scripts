import os
mut rblxpath := ''
if os.user_os()[0..'windows'.len] == 'windows' {
	rblxpath = os.getenv('LOCALAPPDATA') + '\\Roblox'
	println('User is on windows, rblxpath = $rblxpath')
} else {
	println('Not on windows, please enter the path to the Roblox directory')
	rblxpath = os.input('')
}
for folder in os.ls(rblxpath+'\\Versions')? {
	if folder.contains('version') {
		versionpath := rblxpath+'\\Versions\\'+folder
		if os.is_file(versionpath+'\\RobloxPlayerBeta.exe') {
			if !os.is_dir(versionpath+'\\ClientSettings') {
				os.mkdir(versionpath+'\\ClientSettings')?
				println('Created ClientSettings folder in $folder')
			} else {
				println('ClientSettings folder already exists in $folder')
			}
			if !os.is_file(versionpath+'\\ClientSettings\\ClientAppSettings.json') {
				os.write_file(versionpath+'\\ClientSettings\\ClientAppSettings.json', '{"FFlagHandleAltEnterFullscreenManually":"False"}')?
				println('Wrote file to $folder')
			} else {
				println('ClientAppSettings.json already exists in $folder')
			}
		}
	}
}
os.input('Done')
