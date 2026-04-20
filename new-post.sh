#!/bin/sh
# Blog post creation script
# Author: Levis A <@alevis>

today=`date +%Y-%m-%d`

ext=".md"

title=$1
new_post=""

template="new-post-template$ext"
postdir="./_posts/"
tries=1

create_title(){
    title=${title// /-}
    new_post=$title$ext
    new_post="$today-$new_post"
}

is_unique_title(){
    echo "--------------------------------------------------"
    while [ -f "$postdir$new_post" ]
    do
        if [[ $tries -gt 3 ]]; then
            echo "Too many tries, goodbye!"
            exit 
        fi
        echo ""
        echo "Oops!"
        echo "File already exits!"
        read -p "Enter your post's title ($tries): " title
        create_title $title
        tries=$((tries+1))
    done
}

create_post(){
    create_title $title $new_post $ext
    is_unique_title $new_post $title
    
    echo "Creating your blog post."
    cp $postdir$template $postdir$new_post
    sleep 3

    echo "Get ready to edit in ..."
    echo "...3"
    sleep 1
    echo "...2"
    sleep 1
    echo "...1"
    sleep 1

    if ! command -v vi &> /dev/null 
    then
        if ! command -v nano &> /dev/null 
        then
            if !command -v notepad &> /dev/null 
            then
                echo "What planet are you from?"
                echo "Nevermind, it does not matter!"
                echo "Goodbye!"
            fi
        else
            notepad $postdir/$new_post
        fi
        nano $postdir/$new_post
    else
        vi $postdir/$new_post
    fi
}

echo ""

if [[ -n $title ]]; then
    echo "One moment..."
    create_post
else
    read -p "What is the title of your post? "  title
    create_post $title
fi

 
git add $postdir$new_post 
git status

# fin
