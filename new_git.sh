#!/bin/bash

# init set repo non private
is_private="false"

# help text
function usage {
        echo "Usage: $(basename $0) <filename> [-ph]" 2>&1
        echo '   -p   set to private'
        echo '   -h   show help '
        exit 1
}

# Define list of arguments expected in the input
optstring=":ph"

# parse the args
while getopts ${optstring} arg; do
  case "${arg}" in
    p )
      is_private="true"
      ;;
    h )
      usage
      ;;

    \? )
      echo "Invalid option: -$OPTARG."
      echo
      usage
      ;;
  esac
done
shift "$((OPTIND -1))"

# set repo name if exists
repo_name=$1

# catch wrong order if private (this is a kludge)
if [[ $2 == "-p" ]]; then
is_private="true"
fi

# get name of current dir
dir_name=`basename $(pwd)`

# prompt name or use pwd
if [ "$repo_name" = "" ]; then
echo "Repo name (hit enter to use '$dir_name')?"
read repo_name
fi

if [ "$repo_name" = "" ]; then
repo_name=$dir_name
fi

# set new_dir=1 if new
if [ "$repo_name" != "$dir_name" ]; then
new_dir=1
fi

# get+set username, error check
username=`git config github.user`
if [ "$username" = "" ]; then
echo "Could not find username, run 'git config --global github.user <username>'"
invalid_credentials=1
fi

# get+set token, error check
token=`git config github.token`
if [ "$token" = "" ]; then
echo "Could not find token, run 'git config --global github.token <token>'"
invalid_credentials=1
fi

if [ "$invalid_credentials" == "1" ]; then
return 1
fi

echo -n "Creating Github repository '$repo_name' ..."
if [ "$is_private" == "true" ]; then
echo -n "$repo_name set to PRIVATE"
curl -u "$username:$token" https://api.github.com/user/repos -d '{"name":"'$repo_name'","private":"true"}' > /dev/null 2>&1
else
curl -u "$username:$token" https://api.github.com/user/repos -d '{"name":"'$repo_name'"}' > /dev/null 2>&1
fi
#curl -u "$username:$token" https://api.github.com/user/repos -d '{"name":"'$repo_name'","private":"'$is_private'"}' > /dev/null 2>&1
echo " done."

if [ "$new_dir" == "1" ]; then
echo "Creating directory: '$repo_name'..."
mkdir $repo_name
cd $repo_name
echo "# $repo_name" > README.md
else
add_list=`ls`
if [ "$add_list" = "" ]; then
echo "This is an empty directory... adding README.md"
echo "# $repo_name" > README.md
fi
fi

git init
git add --all
git commit -m "first commit"
git branch -M main

echo -n "Pushing local code to remote ..."
git remote add origin git@github.com:$username/$repo_name.git > /dev/null 2>&1
git push -u origin main > /dev/null 2>&1
echo " done."