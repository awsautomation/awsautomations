#!/bin/bash
whoami

if [ $BUILD_CAUSE == "TIMERTRIGGER" ]
then

	REPOS="$1"
	echo $REPOS
    
    PROMOTED_BRANCH="master"
	echo $PROMOTED_BRANCH
    
    BASE_BRANCH="dev"
    echo $BASE_BRANCH
    
    TRIGGERER="Auto"
    echo $TRIGGERER
    
fi    


	echo "TRIGGERER: $TRIGGERER"

	echo "Git promote script starting...\n"
	: ${BASE_BRANCH:?"Error: No BASE_BRANCH specified."}
	: ${PROMOTED_BRANCH:?"Error: No PROMOTED_BRANCH specified."}
	: ${REPOS:?"Error: No REPOS specified"}
	: ${TRIGGERER:?"Error: No TRIGGERER specified "}
	TIMES=$(date +"%Y%b%d_%H%M%S")
	UNDERSCORE=_

    
	# takes repo, baseb_ranch, promoted_branch
	promote_branch()
	{
    	REPO=$1;BASEB=$2;PROMOTEDB=$3
    	REPOPATH=git@git.assembla.com:caprizaportfolio/capriza-ng.${REPO}.git
    	TAGNAME=$PROMOTEDB$UNDERSCORE$TIMES
    	echo "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
        echo "Promoting branch $PROMOTEDB to be as $BASEB in repository $REPO with path $REPOPATH. Tagging with $TAGNAME before"
    	rm -rf $REPO
    	git clone $REPOPATH $REPO
    	cd $REPO
    	git checkout $BASEB
    	git branch -f $PROMOTEDB origin/$PROMOTEDB
    	git checkout $PROMOTEDB
    	git tag -a $TAGNAME -m"Git promote script: before reset --hard. done by $TRIGGERER"
    	git push origin $TAGNAME
    	git reset --hard origin/$BASEB
    	git push -f origin $PROMOTEDB
    	git checkout $BASEB
    	git branch -D $PROMOTEDB
    	cd ..
	}

	for rpo in $REPOS
	do
	    promote_branch $rpo $BASE_BRANCH $PROMOTED_BRANCH
	done

