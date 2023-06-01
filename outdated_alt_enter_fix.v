// SEE DEDICATED REPOSITORY FOR REWRITTEN PROGRAM: https://github.com/dowoge/alt_enter_fix
import os

mut rblxpath := ''

if os.user_os()[0..'windows'.len] == 'windows' {
	env_pf := os.getenv('ProgramFiles(x86)')
	env_lap := os.getenv('LOCALAPPDATA')

	if os.is_dir('$env_pf\\Roblox') {
		rblxpath = '$env_pf\\Roblox'
	} else if os.is_dir('$env_lap\\Roblox') {
		rblxpath = '$env_lap\\Roblox'
	}
}

if rblxpath != '' {
	println('Roblox found: $rblxpath')
} else {
	os.input('Roblox not found, press enter to exit')
	exit(0)
}

for folder in os.ls(rblxpath+'\\Versions')! {
	if folder.contains('version') {
		versionpath := rblxpath+'\\Versions\\'+folder
		if os.is_file(versionpath+'\\RobloxPlayerBeta.exe') {
			if !os.is_dir(versionpath+'\\ClientSettings') {
				os.mkdir(versionpath+'\\ClientSettings')!
				println('Created ClientSettings folder in $folder')
			} else {
				println('ClientSettings folder already exists in $folder')
			}
			if !os.is_file(versionpath+'\\ClientSettings\\ClientAppSettings.json') {
				os.write_file(versionpath+'\\ClientSettings\\ClientAppSettings.json', '{"FFlagHandleAltEnterFullscreenManually":"False","DFIntTaskSchedulerTargetFps":5588562}')!
				println('Wrote file to $folder')
			} else {
				println('ClientAppSettings.json already exists in $folder')
			}
		}
	}
}

os.input('Done, press enter to exit')
