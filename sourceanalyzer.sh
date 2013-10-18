_sourceanalyzer()
{
	local cur prev opts
	COMPREPLY=()									#Output array
	cur="${COMP_WORDS[COMP_CWORD]}"					#Current word
	prev="${COMP_WORDS[COMP_CWORD-1]}"				#Previous word

	opts="-64 -append -b -build-label -build-project -build-version -cp -classpath -clean"
	opts="$opts -debug -debug-verbose -disable-default-rule-type -disable-source-rendering -dotnet-sources"
	opts="$opts -encoding -exclude -f -filter -findbugs -format -h -help -j -libdirs -logfile"
	opts="$opts -no-default-issue-rules -no-default-rules -no-default-source-rules -no-default-sink-rules"
	opts="$opts -python-path -quick -quiet -rules"
	opts="$opts -scan -show-files -show-build-ids -show-build-tree -show-build-warnings -source -sql-language"
	opts="$opts -verbose -version -vsversion -Xms -Xmx -Xss -?"


	local completions=()

	if [[ ${prev} == "-b" ]] ; then
		#Complete from known build IDs
		completions=$(sourceanalyzer -show-build-ids | grep -v " ")
	elif [[ ${cur} == -* ]] ; then
		#Complete from the list if current word starts with a -
		completions=$opts
	fi

	COMPREPLY=( $(compgen -W "${completions}" -- ${cur}) )
	return 0
}

complete -F _sourceanalyzer sourceanalyzer
