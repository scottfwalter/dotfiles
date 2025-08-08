# Snapshot file
# Unset all aliases to avoid conflicts with functions
unalias -a 2>/dev/null || true
# Functions
add-zsh-hook () {
	emulate -L zsh
	local -a hooktypes
	hooktypes=(chpwd precmd preexec periodic zshaddhistory zshexit zsh_directory_name) 
	local usage="Usage: add-zsh-hook hook function\nValid hooks are:\n  $hooktypes" 
	local opt
	local -a autoopts
	integer del list help
	while getopts "dDhLUzk" opt
	do
		case $opt in
			(d) del=1  ;;
			(D) del=2  ;;
			(h) help=1  ;;
			(L) list=1  ;;
			([Uzk]) autoopts+=(-$opt)  ;;
			(*) return 1 ;;
		esac
	done
	shift $(( OPTIND - 1 ))
	if (( list ))
	then
		typeset -mp "(${1:-${(@j:|:)hooktypes}})_functions"
		return $?
	elif (( help || $# != 2 || ${hooktypes[(I)$1]} == 0 ))
	then
		print -u$(( 2 - help )) $usage
		return $(( 1 - help ))
	fi
	local hook="${1}_functions" 
	local fn="$2" 
	if (( del ))
	then
		if (( ${(P)+hook} ))
		then
			if (( del == 2 ))
			then
				set -A $hook ${(P)hook:#${~fn}}
			else
				set -A $hook ${(P)hook:#$fn}
			fi
			if (( ! ${(P)#hook} ))
			then
				unset $hook
			fi
		fi
	else
		if (( ${(P)+hook} ))
		then
			if (( ${${(P)hook}[(I)$fn]} == 0 ))
			then
				typeset -ga $hook
				set -A $hook ${(P)hook} $fn
			fi
		else
			typeset -ga $hook
			set -A $hook $fn
		fi
		autoload $autoopts -- $fn
	fi
}
badge () {
	printf "\e]1337;SetBadgeFormat=%s\a" $(echo -n "$1" | base64)
}
cdf () {
	z "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"
}
cecho () {
	text=${1:-hello} 
	foreground=${2:-39} 
	background=${3:-49} 
	effect=${4:-22} 
	echo -e -n "\e[${foreground};${background};${effect}m$text"
}
compaudit () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
compdef () {
	local opt autol type func delete eval new i ret=0 cmd svc 
	local -a match mbegin mend
	emulate -L zsh
	setopt extendedglob
	if (( ! $# ))
	then
		print -u2 "$0: I need arguments"
		return 1
	fi
	while getopts "anpPkKde" opt
	do
		case "$opt" in
			(a) autol=yes  ;;
			(n) new=yes  ;;
			([pPkK]) if [[ -n "$type" ]]
				then
					print -u2 "$0: type already set to $type"
					return 1
				fi
				if [[ "$opt" = p ]]
				then
					type=pattern 
				elif [[ "$opt" = P ]]
				then
					type=postpattern 
				elif [[ "$opt" = K ]]
				then
					type=widgetkey 
				else
					type=key 
				fi ;;
			(d) delete=yes  ;;
			(e) eval=yes  ;;
		esac
	done
	shift OPTIND-1
	if (( ! $# ))
	then
		print -u2 "$0: I need arguments"
		return 1
	fi
	if [[ -z "$delete" ]]
	then
		if [[ -z "$eval" ]] && [[ "$1" = *\=* ]]
		then
			while (( $# ))
			do
				if [[ "$1" = *\=* ]]
				then
					cmd="${1%%\=*}" 
					svc="${1#*\=}" 
					func="$_comps[${_services[(r)$svc]:-$svc}]" 
					[[ -n ${_services[$svc]} ]] && svc=${_services[$svc]} 
					[[ -z "$func" ]] && func="${${_patcomps[(K)$svc][1]}:-${_postpatcomps[(K)$svc][1]}}" 
					if [[ -n "$func" ]]
					then
						_comps[$cmd]="$func" 
						_services[$cmd]="$svc" 
					else
						print -u2 "$0: unknown command or service: $svc"
						ret=1 
					fi
				else
					print -u2 "$0: invalid argument: $1"
					ret=1 
				fi
				shift
			done
			return ret
		fi
		func="$1" 
		[[ -n "$autol" ]] && autoload -rUz "$func"
		shift
		case "$type" in
			(widgetkey) while [[ -n $1 ]]
				do
					if [[ $# -lt 3 ]]
					then
						print -u2 "$0: compdef -K requires <widget> <comp-widget> <key>"
						return 1
					fi
					[[ $1 = _* ]] || 1="_$1" 
					[[ $2 = .* ]] || 2=".$2" 
					[[ $2 = .menu-select ]] && zmodload -i zsh/complist
					zle -C "$1" "$2" "$func"
					if [[ -n $new ]]
					then
						bindkey "$3" | IFS=$' \t' read -A opt
						[[ $opt[-1] = undefined-key ]] && bindkey "$3" "$1"
					else
						bindkey "$3" "$1"
					fi
					shift 3
				done ;;
			(key) if [[ $# -lt 2 ]]
				then
					print -u2 "$0: missing keys"
					return 1
				fi
				if [[ $1 = .* ]]
				then
					[[ $1 = .menu-select ]] && zmodload -i zsh/complist
					zle -C "$func" "$1" "$func"
				else
					[[ $1 = menu-select ]] && zmodload -i zsh/complist
					zle -C "$func" ".$1" "$func"
				fi
				shift
				for i
				do
					if [[ -n $new ]]
					then
						bindkey "$i" | IFS=$' \t' read -A opt
						[[ $opt[-1] = undefined-key ]] || continue
					fi
					bindkey "$i" "$func"
				done ;;
			(*) while (( $# ))
				do
					if [[ "$1" = -N ]]
					then
						type=normal 
					elif [[ "$1" = -p ]]
					then
						type=pattern 
					elif [[ "$1" = -P ]]
					then
						type=postpattern 
					else
						case "$type" in
							(pattern) if [[ $1 = (#b)(*)=(*) ]]
								then
									_patcomps[$match[1]]="=$match[2]=$func" 
								else
									_patcomps[$1]="$func" 
								fi ;;
							(postpattern) if [[ $1 = (#b)(*)=(*) ]]
								then
									_postpatcomps[$match[1]]="=$match[2]=$func" 
								else
									_postpatcomps[$1]="$func" 
								fi ;;
							(*) if [[ "$1" = *\=* ]]
								then
									cmd="${1%%\=*}" 
									svc=yes 
								else
									cmd="$1" 
									svc= 
								fi
								if [[ -z "$new" || -z "${_comps[$1]}" ]]
								then
									_comps[$cmd]="$func" 
									[[ -n "$svc" ]] && _services[$cmd]="${1#*\=}" 
								fi ;;
						esac
					fi
					shift
				done ;;
		esac
	else
		case "$type" in
			(pattern) unset "_patcomps[$^@]" ;;
			(postpattern) unset "_postpatcomps[$^@]" ;;
			(key) print -u2 "$0: cannot restore key bindings"
				return 1 ;;
			(*) unset "_comps[$^@]" ;;
		esac
	fi
}
compdump () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
compinit () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
compinstall () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
edit-command-line () {
	# undefined
	builtin autoload -X
}
fig_osc () {
	printf "\033]697;$1\007" "${@:2}"
}
fig_precmd () {
	local LAST_STATUS=$? 
	fig_reset_hooks
	fig_osc "OSCUnlock=%s" "${QTERM_SESSION_ID}"
	fig_osc "Dir=%s" "$PWD"
	fig_osc "Shell=zsh"
	fig_osc "ShellPath=%s" "${Q_SHELL:-$SHELL}"
	if [[ -n "${WSL_DISTRO_NAME:-}" ]]
	then
		fig_osc "WSLDistro=%s" "${WSL_DISTRO_NAME}"
	fi
	fig_osc "PID=%d" "$$"
	fig_osc "ExitCode=%s" "${LAST_STATUS}"
	fig_osc "TTY=%s" "${TTY}"
	fig_osc "Log=%s" "${Q_LOG_LEVEL}"
	fig_osc "ZshAutosuggestionColor=%s" "${ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE}"
	fig_osc "FigAutosuggestionColor=%s" "${Q_AUTOSUGGEST_HIGHLIGHT_STYLE}"
	fig_osc "User=%s" "${USER:-root}"
	if [ "$Q_HAS_SET_PROMPT" -eq 1 ]
	then
		fig_preexec
	fi
	START_PROMPT=$'\033]697;StartPrompt\007' 
	END_PROMPT=$'\033]697;EndPrompt\007' 
	NEW_CMD=$'\033]697;NewCmd='"${QTERM_SESSION_ID}"$'\007' 
	Q_USER_PS1="$PS1" 
	Q_USER_PROMPT="$PROMPT" 
	Q_USER_prompt="$prompt" 
	Q_USER_PS2="$PS2" 
	Q_USER_PROMPT2="$PROMPT2" 
	Q_USER_PS3="$PS3" 
	Q_USER_PROMPT3="$PROMPT3" 
	Q_USER_PS4="$PS4" 
	Q_USER_PROMPT4="$PROMPT4" 
	Q_USER_RPS1="$RPS1" 
	Q_USER_RPROMPT="$RPROMPT" 
	Q_USER_RPS2="$RPS2" 
	Q_USER_RPROMPT2="$RPROMPT2" 
	if [ -n "${PROMPT+x}" ]
	then
		PROMPT="%{$START_PROMPT%}$PROMPT%{$END_PROMPT$NEW_CMD%}" 
	elif [ -n "${prompt+x}" ]
	then
		prompt="%{$START_PROMPT%}$prompt%{$END_PROMPT$NEW_CMD%}" 
	else
		PS1="%{$START_PROMPT%}$PS1%{$END_PROMPT$NEW_CMD%}" 
	fi
	if [ -n "${PROMPT2+x}" ]
	then
		PROMPT2="%{$START_PROMPT%}$PROMPT2%{$END_PROMPT%}" 
	else
		PS2="%{$START_PROMPT%}$PS2%{$END_PROMPT%}" 
	fi
	if [ -n "${PROMPT3+x}" ]
	then
		PROMPT3="%{$START_PROMPT%}$PROMPT3%{$END_PROMPT$NEW_CMD%}" 
	else
		PS3="%{$START_PROMPT%}$PS3%{$END_PROMPT$NEW_CMD%}" 
	fi
	if [ -n "${PROMPT4+x}" ]
	then
		PROMPT4="%{$START_PROMPT%}$PROMPT4%{$END_PROMPT%}" 
	else
		PS4="%{$START_PROMPT%}$PS4%{$END_PROMPT%}" 
	fi
	if [ -n "${RPROMPT+x}" ]
	then
		RPROMPT="%{$START_PROMPT%}$RPROMPT%{$END_PROMPT%}" 
	else
		RPS1="%{$START_PROMPT%}$RPS1%{$END_PROMPT%}" 
	fi
	if [ -n "${RPROMPT2+x}" ]
	then
		RPROMPT2="%{$START_PROMPT%}$RPROMPT2%{$END_PROMPT%}" 
	else
		RPS2="%{$START_PROMPT%}$RPS2%{$END_PROMPT%}" 
	fi
	Q_HAS_SET_PROMPT=1 
	if command -v q > /dev/null 2>&1
	then
		(
			command q _ pre-cmd --alias "$(\alias)" > /dev/null 2>&1 &
		) > /dev/null 2>&1
	fi
}
fig_preexec () {
	if [ -n "${PS1+x}" ]
	then
		PS1="$Q_USER_PS1" 
	fi
	if [ -n "${PROMPT+x}" ]
	then
		PROMPT="$Q_USER_PROMPT" 
	fi
	if [ -n "${prompt+x}" ]
	then
		prompt="$Q_USER_prompt" 
	fi
	if [ -n "${PS2+x}" ]
	then
		PS2="$Q_USER_PS2" 
	fi
	if [ -n "${PROMPT2+x}" ]
	then
		PROMPT2="$Q_USER_PROMPT2" 
	fi
	if [ -n "${PS3+x}" ]
	then
		PS3="$Q_USER_PS3" 
	fi
	if [ -n "${PROMPT3+x}" ]
	then
		PROMPT3="$Q_USER_PROMPT3" 
	fi
	if [ -n "${PS4+x}" ]
	then
		PS4="$Q_USER_PS4" 
	fi
	if [ -n "${PROMPT4+x}" ]
	then
		PROMPT4="$Q_USER_PROMPT4" 
	fi
	if [ -n "${RPS1+x}" ]
	then
		RPS1="$Q_USER_RPS1" 
	fi
	if [ -n "${RPROMPT+x}" ]
	then
		RPROMPT="$Q_USER_RPROMPT" 
	fi
	if [ -n "${RPS2+x}" ]
	then
		RPS2="$Q_USER_RPS2" 
	fi
	if [ -n "${RPROMPT2+x}" ]
	then
		RPROMPT2="$Q_USER_RPROMPT2" 
	fi
	Q_HAS_SET_PROMPT=0 
	fig_osc "OSCLock=%s" "${QTERM_SESSION_ID}"
	fig_osc PreExec
}
fig_reset_hooks () {
	if [[ "$precmd_functions[-1]" != fig_precmd ]]
	then
		precmd_functions=(${(@)precmd_functions:#fig_precmd} fig_precmd) 
	fi
	if [[ "$preexec_functions[1]" != fig_preexec ]]
	then
		preexec_functions=(fig_preexec ${(@)preexec_functions:#fig_preexec}) 
	fi
}
forgit::add () {
	"$FORGIT" add "$@"
}
forgit::attributes () {
	"$FORGIT" attributes "$@"
}
forgit::blame () {
	"$FORGIT" blame "$@"
}
forgit::branch::delete () {
	"$FORGIT" branch_delete "$@"
}
forgit::checkout::branch () {
	"$FORGIT" checkout_branch "$@"
}
forgit::checkout::commit () {
	"$FORGIT" checkout_commit "$@"
}
forgit::checkout::file () {
	"$FORGIT" checkout_file "$@"
}
forgit::checkout::tag () {
	"$FORGIT" checkout_tag "$@"
}
forgit::cherry::pick () {
	"$FORGIT" cherry_pick "$@"
}
forgit::cherry::pick::from::branch () {
	"$FORGIT" cherry_pick_from_branch "$@"
}
forgit::clean () {
	"$FORGIT" clean "$@"
}
forgit::diff () {
	"$FORGIT" diff "$@"
}
forgit::error () {
	command printf "%b[Error]%b %s\n" '\e[0;31m' '\e[0m' "$@" >&2
	builtin return 1
}
forgit::fixup () {
	"$FORGIT" fixup "$@"
}
forgit::ignore () {
	"$FORGIT" ignore "$@"
}
forgit::ignore::clean () {
	"$FORGIT" ignore_clean "$@"
}
forgit::ignore::get () {
	"$FORGIT" ignore_get "$@"
}
forgit::ignore::list () {
	"$FORGIT" ignore_list "$@"
}
forgit::ignore::update () {
	"$FORGIT" ignore_update "$@"
}
forgit::log () {
	"$FORGIT" log "$@"
}
forgit::rebase () {
	"$FORGIT" rebase "$@"
}
forgit::reflog () {
	"$FORGIT" reflog "$@"
}
forgit::reset::head () {
	"$FORGIT" reset_head "$@"
}
forgit::revert::commit () {
	"$FORGIT" revert_commit "$@"
}
forgit::reword () {
	"$FORGIT" reword "$@"
}
forgit::show () {
	"$FORGIT" show "$@"
}
forgit::squash () {
	"$FORGIT" squash "$@"
}
forgit::stash::push () {
	"$FORGIT" stash_push "$@"
}
forgit::stash::show () {
	"$FORGIT" stash_show "$@"
}
forgit::warn () {
	command printf "%b[Warn]%b %s\n" '\e[0;33m' '\e[0m' "$@" >&2
}
fp () {
	ps Ao pid,comm | gawk '{match($0,/[^\/]+$/); print substr($0,RSTART,RLENGTH)": "$1}' | grep -i $1 | grep -v grep
}
fs () {
	if du -b /dev/null > /dev/null 2>&1
	then
		local arg=-sbh 
	else
		local arg=-sh 
	fi
	if [[ -n "$@" ]]
	then
		du $arg -- "$@"
	else
		du $arg .[^.]* *
	fi
}
fzf-dir () {
	find "$1" -type f | fzf
}
getent () {
	if [[ $1 = hosts ]]
	then
		sed 's/#.*//' /etc/$1 | grep -w $2
	elif [[ $2 = <-> ]]
	then
		grep ":$2:[^:]*$" /etc/$1
	else
		grep "^$2:" /etc/$1
	fi
}
hostip () {
	host $1 | grep " has address " | cut -d" " -f4
}
is-at-least () {
	emulate -L zsh
	local IFS=".-" min_cnt=0 ver_cnt=0 part min_ver version order 
	min_ver=(${=1}) 
	version=(${=2:-$ZSH_VERSION} 0) 
	while (( $min_cnt <= ${#min_ver} ))
	do
		while [[ "$part" != <-> ]]
		do
			(( ++ver_cnt > ${#version} )) && return 0
			if [[ ${version[ver_cnt]} = *[0-9][^0-9]* ]]
			then
				order=(${version[ver_cnt]} ${min_ver[ver_cnt]}) 
				if [[ ${version[ver_cnt]} = <->* ]]
				then
					[[ $order != ${${(On)order}} ]] && return 1
				else
					[[ $order != ${${(O)order}} ]] && return 1
				fi
				[[ $order[1] != $order[2] ]] && return 0
			fi
			part=${version[ver_cnt]##*[^0-9]} 
		done
		while true
		do
			(( ++min_cnt > ${#min_ver} )) && return 0
			[[ ${min_ver[min_cnt]} = <-> ]] && break
		done
		(( part > min_ver[min_cnt] )) && return 0
		(( part < min_ver[min_cnt] )) && return 1
		part='' 
	done
}
jira-from-branchname () {
	echo "$1" | gsed -n 's/.*\b\(CXAPP-[0-9]\{5\}\).*/\1/p'
}
killbygrep () {
	ps -ef | grep $1 | grep -v grep | gawk '{print $2}' | xargs kill -9
}
killbyport () {
	lsof -i :$1 | tail -n+2 | gawk '{ print $2 }' | xargs kill
}
lst () {
	local query
	bool="OR" 
	[[ $1 =~ "all" ]] && bool="AND"  && shift
	if [[ -z $1 || $1 == "+" ]]
	then
		query="kMDItemUserTags == '*'" 
	elif [[ $1 == "-" ]]
	then
		query="kMDItemUserTags != '*'" 
	else
		query="tag:$1" 
		shift
		for tag in $@
		do
			query="$query $bool tag:$tag" 
		done
	fi
	while IFS= read -r -d $'\0' line
	do
		echo ${line#`pwd`/}
	done < <(mdfind -onlyin . -0 "$query")
}
mkd () {
	mkdir -p $1
	z $1
}
ohai () {
	local green='\033[0;32m' 
	local reset='\033[0m' 
	local msg="${1}" 
	echo -e "${green}${msg}${reset}"
}
on_mac () {
	[[ $(uname -a | grep -c "Darwin") -eq 1 ]]
}
on_wsl () {
	[[ $(uname -a | grep -c "Microsoft") -eq 1 ]]
}
portused () {
	count=$(netstat -an | grep $1 | wc -l) 
	if [ $count -eq 0 ]
	then
		echo "Port not in use"
	else
		echo "Port in use"
	fi
}
prompt_starship_precmd () {
	STARSHIP_CMD_STATUS=$? STARSHIP_PIPE_STATUS=(${pipestatus[@]}) 
	if (( ${+STARSHIP_START_TIME} ))
	then
		__starship_get_time && (( STARSHIP_DURATION = STARSHIP_CAPTURED_TIME - STARSHIP_START_TIME ))
		unset STARSHIP_START_TIME
	else
		unset STARSHIP_DURATION STARSHIP_CMD_STATUS STARSHIP_PIPE_STATUS
	fi
	STARSHIP_JOBS_COUNT=${#jobstates} 
}
prompt_starship_preexec () {
	__starship_get_time && STARSHIP_START_TIME=$STARSHIP_CAPTURED_TIME 
}
starship_zle-keymap-select () {
	zle reset-prompt
}
title () {
	echo -n -e "\033]0;$1\007"
}
usingport () {
	sudo lsof -iTCP:$1 -sTCP:LISTEN
}
z () {
	__zoxide_z "$@"
}
zi () {
	__zoxide_zi "$@"
}
# Shell Options
setopt autocd
setopt nocaseglob
setopt globcomplete
setopt nohashdirs
setopt histfindnodups
setopt histignoredups
setopt histreduceblanks
setopt login
setopt promptsubst
setopt sharehistory
# Aliases
alias -- awk=gawk
alias -- cat=bat
alias -- cd=z
alias -- cwd='pwd | pbcopy'
alias -- cxone-docker='cd /Volumes/Tardis/cxone/tools/container-platform-frontend'
alias -- cxone-docker-shell='docker exec -i -t cxone-container /bin/bash'
alias -- edit-git-config='git config --global --edit'
alias -- enginx='code /opt/homebrew/etc/nginx/nginx.conf'
alias -- eobsidian='code "/Users/scott/Library/Mobile Documents/iCloud~md~obsidian/Documents/My Second Brain"'
alias -- ff='find . -name '
alias -- ga=forgit::add
alias -- gat=forgit::attributes
alias -- gbd=forgit::branch::delete
alias -- gbl=forgit::blame
alias -- gcb=forgit::checkout::branch
alias -- gcf=forgit::checkout::file
alias -- gclean=forgit::clean
alias -- gco=forgit::checkout::commit
alias -- gcp=forgit::cherry::pick::from::branch
alias -- gct=forgit::checkout::tag
alias -- gd=forgit::diff
alias -- gfu=forgit::fixup
alias -- gi=forgit::ignore
alias -- glo=forgit::log
alias -- grb=forgit::rebase
alias -- grc=forgit::revert::commit
alias -- grh=forgit::reset::head
alias -- grl=forgit::reflog
alias -- grw=forgit::reword
alias -- gso=forgit::show
alias -- gsp=forgit::stash::push
alias -- gsq=forgit::squash
alias -- gss=forgit::stash::show
alias -- jj='pbpaste | jsonpp | pbcopy'
alias -- jjj='pbpaste | jsonpp'
alias -- ll='eza --color=always --icons=always --long --group-directories-first --git -l'
alias -- ls='eza --color=always --icons=always --group-directories-first --git '
alias -- marked='open /Applications/Marked\ 2.app '
alias -- o='open "$(fzf)"'
alias -- obsidian='cd /Users/scott/Obsidian/My\ Second\ Brain/.obsidian'
alias -- run-help=man
alias -- sed=gsed
alias -- typeit='cat  | pv -q -L 100'
alias -- vim=nvim
alias -- weather='curl https://wttr.in'
alias -- which-command=whence
alias -- zreload='. ~/.zshrc'
# Check for rg availability
if ! command -v rg >/dev/null 2>&1; then
  alias rg='/opt/homebrew/Cellar/ripgrep/14.1.1/bin/rg'
fi
export PATH='/Users/scott/.local/share/nvim/mason/bin:/Users/scott/.rd/bin:/Users/scott/.bun/bin:/Users/scott/.local/state/fnm_multishells/69680_1754659446235/bin:/opt/homebrew/opt/openjdk/bin:/opt/homebrew/bin:/usr/local/bin:/Users/scott/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin://Applications/Topaz Photo AI.app/Contents/Resources/bin:/Library/Apple/usr/bin:/Applications/Little Snitch.app/Contents/Components:/Applications/VMware Fusion.app/Contents/Public:/Applications/Ghostty.app/Contents/MacOS:/Users/scott/.local/bin:/Users/scott/.orbstack/bin:/Users/scott/.lmstudio/bin:/Users/scott/.claude/local/'
