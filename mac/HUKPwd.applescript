on run {input, parameters}
	try
		-- To get the ID of the Item with the HUK Password run: 'op item list'
		set itemName to "TYPE YOUR OWN 1Password ITEM NAME HERE"
		set pwdText to do shell script "/opt/homebrew/bin/op --account quantco.1password.eu item get " & quoted form of itemName & " --field password --reveal"
        set userName to "TYPE YOUR OWN HUK USERNAME HERE"
		set delaySeconds to 0.05


		if application "Citrix Viewer" is running then
			set shouldTypeUserName to false
			try
                display dialog "Type user name, as well?" buttons {"No", "Yes"} default button "Yes" cancel button "No"
                set shouldTypeUserName to true
            on error number -128
                -- "No" or Esc: keep shouldTypeUserName false
            end try

			tell application "Citrix Viewer" to activate
			delay 0.2 -- give the window a moment to take focus before typing

			if shouldTypeUserName then 
				typeText(userName, delaySeconds)
				typeTab(1, delaySeconds)
			end if
			typeText(pwdText, delaySeconds)
		else if application "Citrix Workspace" is running then
			tell application "Citrix Workspace" to activate
			delay 0.2 -- give the window a moment to take focus before typing

			-- Citrix Workspace has three fields (username, one-time-code, and password)
            typeText(userName, delaySeconds)
			tell application "System Events" to keystroke return
			typeTab(2, delaySeconds)
			typeText(pwdText, delaySeconds)
			-- Shift-Tab: step back one field to get to the one-time-code field.
			tell application "System Events"
				key code 48 using shift down -- shift-tab
			end tell

		else
			error "Neither Citrix Viewer nor Citrix Workspace is running."
		end if
	on error errorMessage number errorNumber
		display dialog "Error " & errorNumber & ": " & errorMessage ¬
			buttons {"OK"} default button "OK" with icon stop
	end try
	
	return input
end run

-- Type the given text with a delay between each character
on typeText(textToType, delaySeconds)
	tell application "System Events"
		repeat with characterToType in characters of textToType
			keystroke characterToType
			delay delaySeconds
		end repeat
	end tell
end typeText

on typeTab(tabCount, delaySeconds)
	tell application "System Events"
		repeat tabCount times
			key code 48 -- tab
			delay delaySeconds
		end repeat
	end tell
end typeTab
