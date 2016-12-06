skill=$1

if [[ -n "$skill" ]]; then

	if [[ -d "$skill" ]]; then

		echo -e "\033[1;31m Building $skill \033[0m"
		if [[ -f "index.zip" ]]; then
			echo "   Deleting existing 'index.zip'..."
			rm index.zip
		fi

		cd $skill
		echo "   Zipping files..."
		zip -rq ../index.zip *
		cd .. 
		echo "   Pushing to Lamba..."
		aws lambda update-function-code --function-name $skill --zip-file fileb://index.zip >/dev/null
		echo "   Deleting all log streams from Cloudwatch..."
		aws logs delete-log-group --log-group-name /aws/lambda/$skill
		aws logs create-log-group --log-group-name /aws/lambda/$skill

		echo -e "\033[1;31m Done \033[0m ✓"
	else
		echo "$skill does not exist."
	fi

else
	echo "Usage: ./publish.sh <skill_name_directory>"
fi
