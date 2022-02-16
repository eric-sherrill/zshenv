#============================================================================#
# zsh confuguration
# Created by Konstantin Shulgin <konstantin.shulgin@gmail.com>
#============================================================================#

#----------------------------------------------------------------------------#
# utility functions
#----------------------------------------------------------------------------#

# check if application exists via 'which' utility
function provided_in_env()
{
    local bin=$1

    if which $bin > /dev/null 2>&1; then
	return 0
    fi

    return 1
}

#----------------------------------------------------------------------------#
# User enviroment settings
#----------------------------------------------------------------------------#

# zsh home directory
export ZSH_HOME=$HOME/.zsh

# Editor
export EDITOR=vim

# Path (add macports)
export PATH=/opt/local/bin:/opt/local/sbin:$PATH

# Man path (add macports)
export MANPATH=/opt/local/share/man:$MANPATH

# Set terminal type
export TERM=xterm-color

# Enable color in the terminal
export CLICOLOR=1

export PATH=$PATH:~/Library/Python/3.9/bin/
export PATH=/usr/local/opt/bison/bin:$PATH
export PATH=/usr/local/bin:~/bin:$PATH
export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home/
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/opt/openssl/lib/pkgconfig
export CS3_DEPLOY_PREFIX=eric.sherrill.224c10614220ab29

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/eric.sherrill/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/eric.sherrill/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/eric.sherrill/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/eric.sherrill/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
eval "$(pyenv init --path)"
. "$HOME/.cargo/env"

# >>>> Vagrant command completion (start)
fpath=(/opt/vagrant/embedded/gems/2.2.19/gems/vagrant-2.2.19/contrib/zsh $fpath)
compinit
# <<<<  Vagrant command completion (end)

#-----------------------------------------------------------------------------#
# zsh modules
#-----------------------------------------------------------------------------#

# Initialize colors
autoload -U colors; colors

# Initialize compinit
autoload -U compinit; compinit

#----------------------------------------------------------------------------#
# include completion
#----------------------------------------------------------------------------#
. ~/.zsh/completion

#-----------------------------------------------------------------------------#
# Load plugins and settings
#-----------------------------------------------------------------------------#

#
# Plugins loader
#

# load plugin from directory
function zsh_plugin_load()
{
    local plugin_dir=$1

    if [ ! -d $plugin_dir ];
    then
	return 1
    fi

    for ext in 'zsh' 'bash' 'sh'
    do
	local plugin_source=$plugin_dir/$(basename $plugin_dir).$ext
	if [ -e $plugin_source ]
	then
	    source $plugin_source
	    return 0
	fi
    done

    echo "$plugin_dir's soruce not found"
    return 1
}

# load all plugins from directory
function zsh_plugin_dir_load()
{
    local plugins_dir=$1
    if [ ! -d $plugins_dir ]; then
	echo "'$plugins_dir' isn't directory";
	return 1
    fi

    if [ ! "$(ls -A $plugins_dir)" ];
    then
	echo "'$plugins_dir' is empty"
	return 1
    fi

    for plugin in $plugins_dir/*
    do
	zsh_plugin_load $plugin
    done
}

# load all plugins
zsh_plugin_dir_load $ZSH_HOME/plugins

#
# Git plugin settings
#

# show dirty state in the branch
export GIT_PS1_SHOWDIRTYSTATE=true

#----------------------------------------------------------------------------#
# prompt settings
#----------------------------------------------------------------------------#

# Allow for functions in the prompt.
setopt PROMPT_SUBST

# Prompt settings
PROMPT='%F{yellow}%n@%m%f:%F{cyan}%~%F{magenta}$(__git_ps1 "(%s)")%F{green}$%f '

#----------------------------------------------------------------------------#
# Colors
#----------------------------------------------------------------------------#

local dircolors_bin=""
for itr in 'dircolors' 'gdircolors'
do
    if (provided_in_env $itr); then
	dircolors_bin=$itr
	break
    fi
done

if [[ "$dircolors_bin" != "" ]]; then
    eval $($dircolors_bin ~/.zsh/dir_colors)
fi

#----------------------------------------------------------------------------#
# Aliases
#----------------------------------------------------------------------------#

local platform=`uname`
if [[ "$platform" == "Linux" ]]; then
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
else if [[ "$platform" == "Darwin" ]]
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    if (provided_in_env 'gls'); then
        # gls provids by coreutils from macports
	alias ls='gls --color=auto'
    else
	# gls doesn't exists, use BSD version
	alias ls='ls -G'
    fi

    if (provided_in_env 'gdir'); then
        # gls provids by coreutils from macports
	alias dir='gdir --color=auto'
    fi
fi

# lists
alias l='ls -CF'
alias la='ls -AL'
alias ll='ls -lF'
alias lla='ls -lsa'

# move-rename w/o correction and always in interactive mode
alias mv='nocorrect mv -i'
# recursive copy w/o correction and always in interactive mode
alias cp='nocorrect cp -iR'
# remove w/o correction and always in interactive mode
alias rm='nocorrect rm -i'
# create directory w/o correction
alias mkdir='nocorrect mkdir'

#----------------------------------------------------------------------------#
# History
#----------------------------------------------------------------------------#

# History file
HISTFILE=$ZSH_HOME/zsh_history

# Commands count history in history file
SAVEHIST=5000

# Commands count history in one seance
HISTSIZE=5000

# Append history list to the history file (important for multiple parallel zsh sessions!)
setopt  APPEND_HISTORY
setopt  HIST_IGNORE_ALL_DUPS
setopt  HIST_IGNORE_SPACE
setopt  HIST_REDUCE_BLANKS
eval "$(starship init zsh)"

# zsh.zshrc end here