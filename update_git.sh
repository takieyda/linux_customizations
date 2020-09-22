#!/bin/bash 

cur_dir=`pwd`

echo -e "\e[1;36m*****  \e[1;33mUpdating git repositories  \e[1;36m*****\e[0m"

cd ~/git/
for i in `ls ~/git/`; do
    echo -e "\n\e[1;33m# \e[0;32mUpdating \e[1;33m$i\e[0m"
    cd $i
    git fetch
    git merge origin master
    cd - 1>/dev/null
done

echo -e "\n\e[1;36m*****  \e[1;33mGit repositories update complete  \e[1;36m*****\e[0m"
cd $cur_dir
