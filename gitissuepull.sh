#!/bin/bash

function beginIssuePull {
	# Get info for pull request
	echo "Please specify the following:\n"
	read -e -p "GitHub username: " USERNAME
	read -e -p "Issue number: " ISSUE
	read -e -p "Fork branch name: " FORKBRANCH
	read -e -p "Destination branch name (e.g. master): " DESTBRANCH
	read -e -p "Destination repository (<original_user>/<repo_name>): " DESTREPO
	
	# Verify info is correct 
	echo "\nPlease verify the following information is correct:\n\n\
	GitHub username: $USERNAME\n\
	Issue Number: $ISSUE\n\
	Fork branch name: $USERNAME:$FORKBRANCH\n\
	Destination branch name: $DESTBRANCH\n\
	Destination repository: $DESTREPO\n"
	echo "Is that all correct?"
	select yn in "Yes" "No"; do
		case $yn in
			Yes )	echo "\nAlright, then. Moving on...\n"
				break
				;;
			No )	echo "\nPlease start over. Bye!\n"
				exit
				;;
		esac
	done
	
	# Prepare to use TFA if necessary
	echo "Do you use Two-Factor Authentication?"
	select yn in "Yes" "No"; do
		case $yn in
			Yes )	echo ""
				read -e -p "Current One-Time Password: " OTP
				OTPSTRING="--header 'X-GitHub-OTP: $OTP' "
				break
				;;
			No )	OTPSTRING=""
				break
				;;
		esac
	done
	
	CMDSTRING="curl -u $USERNAME $OTPSTRING--request POST --data '{\"issue\":\"$ISSUE\", \"head\":\"$USERNAME:$FORKBRANCH\", \"base\":\"$DESTBRANCH\"}' https://api.github.com/repos/$DESTREPO/pulls"
	
	echo "\nRunning the following command:\n\n$CMDSTRING\n\nPrepare to enter your password..."
	
	eval $CMDSTRING;
	
	exit
}

echo "Do you need to append a pull request to an existing issue?"
select yn in "Yes" "No"; do
	case $yn in
		No )	echo "\nOK, bye!\n"
			exit
			;;
		Yes )	echo "\nOK, here we go!\n"
			beginIssuePull
			;;
	esac
done

