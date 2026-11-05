# Editors
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx SUDO_EDITOR nvim

set -gx XDG_PICTURES_DIR ~/Pictures/Screenshots/

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH
set -gx PATH ~/.local/share/nvim/mason/bin/ $PATH # Share LSP servers installed by mason with other editors

# Removes the filtering of less
set -gx LESSOPEN

# Go
set -g GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH

# Editors
function mkcd
    if test (count $argv) -eq 0
        echo "Usage: mkcd <directory_name>"
        return 1
    end
    mkdir -p $argv[1]
    cd $argv[1]
end

# git (ssh)
function __ssh_agent_is_started -d "check if ssh agent is already started"
   if begin; test -f $SSH_ENV; and test -z "$SSH_AGENT_PID"; end
      source $SSH_ENV > /dev/null
   end

   if test -z "$SSH_AGENT_PID"
      return 1
   end

   ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep -q ssh-agent
   #pgrep ssh-agent
   return $status
end


function __ssh_agent_start -d "start a new ssh agent"
   ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
   chmod 600 $SSH_ENV
   source $SSH_ENV > /dev/null
   true  # suppress errors from setenv, i.e. set -gx
end


function fish_ssh_agent --description "Start ssh-agent if not started yet, or uses already started ssh-agent."
   if test -z "$SSH_ENV"
      set -xg SSH_ENV $HOME/.ssh/environment
   end

   if not __ssh_agent_is_started
      __ssh_agent_start
   end
end

fish_ssh_agent

# Binds 
function fish_user_key_bindings
    # bind \cc 'stty sane; commandline -f cancel; commandline -f repaint'
    bind \cj history-search-forward
    bind \ck history-search-backward
    bind \cf 'bash -c ~/.local/bin/tmux-sessionizer'
end

# reload conig 
function resource
    source ~/.config/fish/config.fish
    echo "Reloaded config.fish 🚀"
end

# abbrevations
# if command -v eza > /dev/null
#     abbr -a ls 'eza --icons=always'
#     abbr -a lsa 'eza --icons=always -a'
#     abbr -a l 'eza -alF -s=modified --icons=always'
#     abbr -a ll 'eza -alF --icons=always'
#     abbr -a lll 'eza -laF -s=modified --icons=always --total-size --sort=size'
#     abbr -a la 'eza -A --icons=always'
# else
#     abbr -a l 'ls'
#     abbr -a ll 'ls -l'
#     abbr -a lsa 'ls -a'
#     abbr -a lll 'ls -la'
# end
abbr -a l 'ls'
abbr -a ll 'ls -l'
abbr -a lsa 'ls -a'
abbr -a lll 'ls -la'

abbr -a vi 'nvim'
abbr -a vim 'nvim'

abbr -a py3 'python3'

abbr -a ff 'fastfetch'

abbr -a mv 'mv -i'
abbr -a rm 'rm -i' # confirm before deleting unless specified with -f flag
abbr -a mkdir 'mkdir -pv'

abbr -a g 'git'
abbr -a gd 'git diff'
abbr -a gca 'git commit -a'
abbr -a gs 'git status'

abbr -a cdg 'cd $(git rev-parse --show-toplevel)' # go to root directory

abbr -a sizeof "sudo du -sh"
abbr -a sizeall 'sudo du -sh --exclude "/mnt" /* | sort -h'
abbr -a sizehere 'sudo du -sh {*,.*} 2>/dev/null | sort -h'
abbr -a info 'glxinfo -B'
abbr -a hardware 'inxi -Fzxx'

abbr -a logout 'loginctl terminate-user $USER'

function fish_greeting
	echo -e (uname -ro | awk '{print " \\\\e[1mOS: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (uptime | sed 's/^.*up  *\([^,]*\),.*/\1/' | awk '{print " \\\\e[1mUptime: \\\\e[0;32m"$0"\\\\e[0m"}')
  echo

	set_color normal

	if test -s $HOME/todo
    set_color red
    echo -e " \e[1mTODOs:\e[0;32m"
		set_color magenta
    rtd clean_list
		echo
	end

	if test -s $HOME/Documents/scratchpad.txt
    set_color red
    echo -e " \e[1mSchedule:\e[0;32m"
		set_color magenta
		cat $HOME/Documents/scratchpad.txt | sed 's/^/ /'
		echo
	end

	set_color normal
end

set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate ''
set __fish_git_prompt_showupstream 'none'
set __fish_git_prompt_char_upstream_ahead "↑"
set __fish_git_prompt_char_upstream_behind "↓"
set __fish_git_prompt_char_upstream_prefix ""
