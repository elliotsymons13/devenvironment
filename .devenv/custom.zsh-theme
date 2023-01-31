#!/usr/bin/env zsh

# ------------------------------------------------------------------------------
# Extended / adapted from 'refined' pre-packed theme (described below. 
# Adapted by Elliot. 
# 
# Pure - A minimal and beautiful theme for oh-my-zsh
#
# Based on the custom Zsh-prompt of the same name by Sindre Sorhus. A huge
# thanks goes out to him for designing the fantastic Pure prompt in the first
# place! I'd also like to thank Julien Nicoulaud for his "nicoulaj" theme from
# which I've borrowed both some ideas and some actual code. You can find out
# more about both of these fantastic two people here:
#
# Sindre Sorhus
#   GitHub:   https://github.com/sindresorhus
#   Twitter:  https://twitter.com/sindresorhus
#
# Julien Nicoulaud
#   GitHub:   https://github.com/nicoulaj
#   Twitter:  https://twitter.com/nicoulaj
#
# ------------------------------------------------------------------------------

# Set required options
#
setopt prompt_subst


# ------ Prompt contributors ------
# Fastest possible way to check if repo is dirty
#
# git_dirty() {
#     # Check if we're in a git repo
#     command git rev-parse --is-inside-work-tree &>/dev/null || return
#     # Check if it's dirty
#     command git diff --quiet --ignore-submodules HEAD &>/dev/null; [ $? -eq 1 ] && echo "*"
# }

repo_name() {
    git_repo_path=$(git rev-parse --show-toplevel 2> /dev/null)
    if [ $? -eq 0 ]; then
        echo "$(basename $git_repo_path)"
    fi;
}


username() {
   echo "%n"
}

# current directory, two levels deep
directory() {
    # TODO if starts in /home then prepend "~/..."
    # else prepend "/..."
    # curr_dir=$(pwd)
    # home="/home"

    # prefix=""
    # if [[ $curr_dir == *$home* ]]; then
    #     prefix="~%F{000}/...%f"
    # else 
    #     prefix="%F{000}/...%f"
    # fi;
    # echo "$prefix ${"%2~"/"~"/}"
    echo "%2~"
}

# Displays the exec time of the last command if set threshold was exceeded
#
cmd_exec_time() {
    local stop=`date +%s`
    local start=${cmd_timestamp:-$stop}
    let local elapsed=$stop-$start
    [ $elapsed -gt 5 ] && echo ${elapsed}s
}

# Get the initial timestamp for cmd_exec_time
#
preexec() {
    cmd_timestamp=`date +%s`
}

# Output additional information about paths, repos and exec time
#
precmd() {
    ZSH_THEME_GIT_PROMPT_PREFIX=""
    ZSH_THEME_GIT_PROMPT_SUFFIX=""
    ZSH_THEME_GIT_PROMPT_DIRTY="%F{009}\u00b1%f"
    ZSH_THEME_GIT_PROMPT_CLEAN="%F{002}\u00b1%f"
    ZSH_THEME_GIT_PROMPT_BEHIND="%F{215}✈%f" # less bad, pull
    ZSH_THEME_GIT_PROMPT_AHEAD="%F{009}✈%f" # risk of loss of work, more bad, push
    ZSH_THEME_GIT_PROMPT_STASHED="\u2702"

    setopt localoptions nopromptsubst
   # vcs_info # Get version control info before we start outputting stuff
    print -P "\n%B%F{blue}$(username)%b\u00bb$(directory)%f $(repo_name):%F{008}$(git_prompt_info)%f %F{215}$(cmd_exec_time)%f"
    unset cmd_timestamp #Reset cmd exec time.
}

# ------ Prompt top level components ------


# Example:

#PROMPT="%{$fg[red]%}%n%{$reset_color%}$(directory)@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "

PROMPT="%(?.%F{007}.%F{009})❯%f " # Display a red prompt char on failure
RPROMPT="%F{008}${SSH_TTY:+%n@%m}%f"    # Display username if connected via SSH