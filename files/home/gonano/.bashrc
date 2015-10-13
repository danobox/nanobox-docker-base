if [ "$PS1" ]; then
        shopt -s checkwinsize cdspell extglob histappend
        alias ll='ls -lF'
        alias ls='ls --color=auto'
        HISTCONTROL=ignoreboth
        HISTIGNORE="[bf]g:exit:quit"
        PS1="[\u@\h \w]\\$ "
        if [ -n "$SSH_CLIENT" ]; then
                PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME%%\.*} \007" && history -a'
        fi
fi

# clear PATH so we can explicitly build it
export PATH=""

# source any environment variables that were dropped by engines
# including, perhaps, a custom PATH
if [ -d /data/etc/env.d ]; then
        for env in $(/bin/ls /data/etc/env.d); do
                export "$env=$(/bin/cat /data/etc/env.d/$env)"
        done
fi

# if the engine manipulated the PATH, let's append to it instead of reset
if [[ -n $PATH ]]; then
        export PATH=${PATH}:
fi

# set the ubuntu defaults
export PATH=${PATH}/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# prefix ubuntu defaults with the gonano pkgsrc bootstrap
export PATH=/opt/gonano/sbin:/opt/gonano/bin:${PATH}

# if we have a base bootstrap, then let's add that first
if [ -d /data ]; then
        export PATH=/data/sbin:/data/bin:${PATH}
fi

# with the environment variables exported and the PATH set
# we need to source any custom profile scripts
if [ -d /data/etc/profile.d ]; then
        for profile in $(/bin/ls /data/etc/profile.d); do
                . /data/etc/profile.d/$profile
        done
fi