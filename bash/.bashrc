# Torstein's .bashrc

# window
shopt -s checkwinsize
PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
TERM=xterm-color

# prompt
PS1="\[\033[0;36m\]{\[\033[0;50m\]\w\[\033[0;36m\]} \[\033[0;32m\]what now\[\033[0;39m\]\$(if [ \$? -eq 0 ]; then echo '...'; else echo '..,'; fi) "

# history
shopt -s histappend
HISTCONTROL=ignoredups
HISTSIZE=1000000
HISTFILESIZE=1000000
HISTTIMEFORMAT="%F %H:%M:%S "
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ;}"\
'echo "$(history 1)" >> ~/.bash_eternal_history'

# aliases
alias df='df -hT'
alias eternal='cat ~/.bash_eternal_history | grep'
alias grep='grep -i --color'
alias ls='ls -lh'
alias uprompt="unset PROMPT_COMMAND; export PS1='\u@\h \w$ '"
alias mypublicip="curl -s checkip.dyndns.org | sed 's/.*<body>.*: \(.*\)<\/body>.*/\1/'"

# bash completion
export FIGNORE=.svn
l="
  $HOME/src/my-little-friends/bash_completion.d/tkj
  $HOME/src/ece-scripts/etc/bash_completion.d/ece
  /usr/share/bash-completion/bash_completion
"
for el in $l; do
  if [ -r $el ]; then
    source $el
  fi
done
# java
export JAVA_HOME=/usr/lib/jvm/java-6-sun

# path
PATH=$HOME/src/ece-scripts/usr/bin:\
$HOME/src/my-little-friends/bash:\
$HOME/src/common-bashing/net:\
/opt/maven/bin:\
/opt/local/bin:\
$JAVA_HOME/bin:\
$PATH

# p4
export P4CONFIG=$HOME/.p4config

# language & time zone
export TZ='Europe/Oslo'
export LANG=en_GB.utf8
export LC_ALL=en_GB.utf8

# local overrides & private bash settings
if [ -e ~/.bashrc.private ]; then
  source ~/.bashrc.private
fi

