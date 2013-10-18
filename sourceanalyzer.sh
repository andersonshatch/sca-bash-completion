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

	if [[ ${cur} == -* ]] ; then
		COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
		return 0
	fi
}

complete -F _sourceanalyzer sourceanalyzer
