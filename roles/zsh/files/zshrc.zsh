#region OS-specific setup
if [ "$(uname)" = "Darwin" ]; then
  # export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
  source "$(brew --prefix)/share/antigen/antigen.zsh"

  antigen bundle robbyrussell/oh-my-zsh plugins/macos

  test -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" && source "${HOME}/.nix-profile/etc/profile.d/nix.sh"
  test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
else
  # assuming `antigen` AUR package
  source /usr/share/zsh/share/antigen.zsh
fi
#endregion

#region Plugins

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zdharma-continuum/fast-syntax-highlighting
antigen bundle gem
antigen bundle git
antigen bundle ruby
antigen bundle rbenv
antigen bundle rails
antigen bundle sudo
antigen bundle z

antigen apply
#endregion

#region ZSH Options
setopt auto_cd
setopt prompt_subst

# Completions
autoload -Uz compinit
compinit

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git

precmd() {
  vcs_info
}

precmd_functions+=(precmd)
#endregion

#region Aliases
alias ff='cd $(dirname $(fzf))'
alias p='cd $(find ~/Projects -maxdepth 1 -type d -exec test -e '{}'/.git \;  -print | fzf)'
#endregion

#region Functions
function _p_sc {
  echo -n "%(0?..%F{yellow}%? %f)"
}

function uart {
  if [ "$(uname)" = "Darwin" ]; then
    screen /dev/tty.usbserial-143230 115200
  else
    screen /dev/ttyUSB0 115200
  fi
}
#endregion

PROMPT="%F{red}%m%>>%f %2~%F{blue}\${vcs_info_msg_0_}%f
$(_p_sc)%# "

eval "$(rbenv init -)"
