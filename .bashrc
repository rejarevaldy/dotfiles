# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes


if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='$'
else
    PS1='$'
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="$"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

#  aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias xampp='cd /opt/lampp && sudo ./manager-linux-x64.run'

alias sdisk='ncdu'

alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'

alias h="history | grep "
alias date='date "+%Y-%m-%d %A %T %Z"'
alias lock='xflock4'
alias suspend='sudo pm-suspend'
alias hibernate='sudo pm-hibernate'
alias konek='ping 1.1.1.1'
alias lt='tree'
alias neofetch='clear && neofetch'
alias todoedit='gedit /home/revv/Documents/todo'
alias todolist='cat /home/revv/Documents/todo'

#Github Alias

alias commit='git commit -m '
alias modified='git commit -ma'
alias push='git push'
alias stats='git status'
alias graph='git log --all --decorate --oneline --graph'

#Django Alias
alias vlenv='virtualenv -p python3'
alias djangorun='python3 manage.py runserver'
alias migrate='python3 manage.py migrate'
alias makemigrate='python3 manage.py makemigrations'


#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi




prompt_git() {
	local s='';
	local branchName='';

	# Check if the current directory is in a Git repository.
	if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then

		# check if the current directory is in .git before running git checks
		if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then

			# Ensure the index is up to date.
			git update-index --really-refresh -q &>/dev/null;

			# Check for uncommitted changes in the index.
			if ! $(git diff --quiet --ignore-submodules --cached); then
				s+='+';
			fi;

			# Check for unstaged changes.
			if ! $(git diff-files --quiet --ignore-submodules --); then
				s+='!';
			fi;

			# Check for untracked files.
			if [ -n "$(git ls-files --others --exclude-standard)" ]; then
				s+='?';
			fi;

			# Check for stashed files.
			if $(git rev-parse --verify refs/stash &>/dev/null); then
				s+='$';
			fi;

		fi;

		# Get the short symbolic ref.
		# If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
		# Otherwise, just give up.
		branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
			git rev-parse --short HEAD 2> /dev/null || \
			echo '(unknown)')";

		[ -n "${s}" ] && s=" [${s}]";

		echo -e "${1}${branchName}${2}${s}";
	else
		return;
	fi;
}


usernamecolor=$(tput setaf 15);
locationcolor=$(tput setaf 240);
workingdirectorycolor=$(tput setaf 15);
white=$(tput setaf 15);
grey=$(tput setaf 245);
gitstatuscolor=$(tput setaf 15);
bold=$(tput bold);
reset=$(tput sgr0);

PS1="\[\033]0;\w\007\]"; # Displays current working directory as title of the terminal
PS1+="\[${grey}\]<< ";
PS1+="\[${white}\]\h"; # Displays host/device
PS1+="\[${locationcolor}\]//";
PS1+="\[${white}\]\u"; # Displays username


PS1+="\[${grey}\] >\[${workingdirectorycolor}\]>\[${grey}\]> \[${workingdirectorycolor}\]";
PS1+="\[${workingdirectorycolor}\]\w"; # Displays base path of current working directory

PS1+="\$(prompt_git \"\[${grey}\] >\[${gitstatuscolor}\]>\[${grey}\]> \[${gitstatuscolor}\]\" \"\[${gitstatuscolor}\]\")"; # Displays git status
PS1+="\n";
PS1+="\[${grey}\]>> \[${reset}\]";
export PS1;

# Quickly find out external IP address for your device by typing 'xip'
alias xip='echo; curl -s ipinfo.io; echo;'

# Quickly check weather for your city right inside the terminal by typing 'weather'
# Remove 'm' from the url to use Fahrenheit instead of Celsius
weather() {
        if [ -z "$1" ]; then
                echo
                curl -s wttr.in/?0mq
        else
                echo
                curl -s wttr.in/"$1"?0mq
        fi
}

# Make a directory and jump right into it. Combination of mkdir and cd. Just use 'mkcdir folder_name'
mkcdir()
{
	mkdir -p -- "$1" &&
		cd -P -- "$1"
}

# Update, upgrade and clean apt packages in your system with just one command. Just type 'update' in terminal
update () {
	echo -e "\nStarting system update..."
	echo -e "\nUpdating list of available apt packages and their versions..."
	sudo apt update -qq
	echo -e "\nUpgrading apt packages to newer version..."
	sudo apt upgrade -yy
	echo -e "\nRemoving packages no more needed as dependencies..."
	sudo apt autoremove -yy
	echo -e "\nRemoving packages that can no longer be downloaded..."
	sudo apt autoclean
	echo -e "\nClearing out local repository of retrieved package files..."
	sudo apt clean
	echo -e "\nUpdate complete!"
}

currency()
{
	tempAppID=0e71a2430e4d43bdbc28e3b4282ca6a2
        # Default: 1 USD to INR
        # Usage: currency
        if [ -z "$1" ]; then
                echo
                curval=$(curl -s -X GET https://openexchangerates.org/api/latest.json?app_id=${tempAppID} | jq -r '.rates.INR')
                echo "1 USD = "${curval}" INR"
        else
                # A certain value to INR
                # Usage: currency 250
                if [ -z "$2" ]; then
                        echo
                        curval=$(curl -s -X GET https://openexchangerates.org/api/latest.json?app_id=${tempAppID} | jq -r ".rates.INR * "$1"")
                        echo "$1 USD = "${curval}" INR" | lolcat
                else
                        # Certain value to certain currency
                        # Usage: currency 250 EUR
                        echo
curval=$(curl -s -X GET https://openexchangerates.org/api/latest.json?app_id=${tempAppID} | jq -r ".rates."$2" * "$1"")
                        echo "$1 USD = "${curval}" $2" | lolcat
                fi
        fi
}

quote()
{
	echo
	curl -s https://favqs.com/api/qotd | jq -r '[.quote.body, .quote.author] | "\(.[0]) -\(.[1])"'
}

news()
{       COLUMNS=$(tput cols)
	# Remove any source from below array if needed
        declare -a sources=("google-news" "hacker-news" "mashable" "polygon" "techcrunch" "techradar" "the-next-web" "the-verge" "wired-de")

        for i in "${sources[@]}"
        do
                echo
                header="Source: "$i""
                printf "%*s\n" $(((${#header}+$COLUMNS)/2)) "$header"
                echo
		# n=20 below displays 20 articles if available.
                curl getnews.tech/"$i"?n=20\&w="$(tput cols)"
        done
}

