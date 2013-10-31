#!/bin/bash

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
	opts="$opts -php-source-root -python-path -quick -quiet -rules"
	opts="$opts -scan -show-files -show-build-ids -show-build-tree -show-build-warnings -source -sql-language"
	opts="$opts -verbose -version -vsversion -Xms -Xmx -Xss -?"


	local completions=()

	if [[ ${prev} == "-b" ]] ; then
		#Complete from known build IDs
		completions=$(sourceanalyzer -show-build-ids | grep -v " ")
	elif [[ ${cur} == -* ]] ; then
		#Complete from the list if current word starts with a -
		completions=$opts
	else
		#Fallback to file/folder completions
		_filedir
		return 0
	fi

	COMPREPLY=( $(compgen -W "${completions}" -- ${cur}) )
	return 0
}

complete -F _sourceanalyzer sourceanalyzer sourceanalyzer.exe

_fortifyclient()
{
	local cur prev opts
	COMPREPLY=()								#Output array
	cur="${COMP_WORDS[COMP_CWORD]}"				#Current word
	prev="${COMP_WORDS[COMP_CWORD-1]}"			#Previous word

	keywords="archiveRuntimeEvents checkPermission"
	keywords="$keywords deleteRuntimeEventArchive downloadAttachment downloadFPR downloadRuntimeEventArchive"
	keywords="$keywords import invalidatetoken listProjectVersions listRuntimeApplications listRuntimeEventArchives listTokens"
	keywords="$keywords purgeProjectVersion restoreRuntimeEventArchive"
	keywords="$keywords token uploadFPR uploadSource"

	switches="-applicationIds -archiveId -attachmentId -authtoken -bundle -daysToLive -debug"
	switches="$switches -endDate -entityId -f -file -force -gettoken -help"
	switches="$switches -includeSource -invalidate -invalidateById -invalidateForUser"
	switches="$switches -machineoutput -password -permissionName -project -projectVersionID -proxyurl"
	switches="$switches -scanDate -startDate -url -user -version"

	local completions=()

	if [[ $(($COMP_CWORD-1)) == 0 ]] ; then
		#Keyword completion
		completions=$keywords
	elif [[ ${prev} == "-f" ]] || [[ ${prev} == "-file" ]] ; then
		#File completion
		_filedir
		return 0
	elif [[ ${prev} == "-user" ]] ; then
		#Complete users (just admin and current username)
		completions="admin $USER"
	elif [[ ${prev} == "-gettoken" ]] ; then
		#Complete default token types
		completions="AnalysisDownloadToken AnalysisUploadToken AuditToken DownloadFileTransferToken"
		completions="$completions ReportFileTransferToken UnifiedLoginToken UploadFileTransferToken"
	else
		#Switch completion
		completions=$switches
	fi

	COMPREPLY=( $(compgen -W "${completions}" -- ${cur} ) )
	return 0

}

complete -F _fortifyclient fortifyclient fortifyclient.bat

_fprutility()
{
	local cur prev opts
	COMPREPLY=()								#Output array
	cur="${COMP_WORDS[COMP_CWORD]}"				#Current word
	prev="${COMP_WORDS[COMP_CWORD-1]}"			#Previous word

	switches="-analyzerIssueCounts -categoryIssueCounts -errors -extract -f -forceMigration"
	switches="$switches -iidmigratorOptions -information -mappings -merge -mergeArchive -migrate -project"
	switches="$switches -query -search -settings -signature -source -sourceArchive"
	switches="$switches -useMigrationFile -useSourceProjectTemplate"

	if [[ ${prev} == "-project" ]] || [[ ${prev} == "-source" ]] ; then
		#Filename completion - .fpr and .fsa
		_filedir '@(fpr|fsa)'
	elif [[ ${prev} == "-f" ]] ; then
		#Filename completion - all
		_filedir
	else
		#Switch completion
		COMPREPLY=( $(compgen -W "${switches}" -- ${cur} ) )
	fi

	return 0
}

complete -F _fprutility FPRUtility FPRUtility.bat

_fortifyupdate()
{
	local cur prev opts
	COMPREPLY=()								#Output array
	cur="${COMP_WORDS[COMP_CWORD]}"				#Current word
	prev="${COMP_WORDS[COMP_CWORD-1]}"			#Previous word

	switches="-acceptKey -coreDir -h -help -import -locale"
	switches="$switches -proxyhost -proxyPassword -proxyport -proxyUsername -url"

	if [[ ${prev} == "-import" ]] ; then
		#Filename completion - .zip
		_filedir 'zip'
	elif [[ ${prev} == "-coreDir" ]] ; then
		#Directory completion
		_filedir -d
	else
		#Switch completion
		COMPREPLY=( $(compgen -W "${switches}" -- ${cur} ) )
	fi

	return 0
}

complete -F _fortifyupdate fortifyupdate fortifyupdate.cmd

_reportgenerator()
{
	local cur prev opts
	COMPREPLY=()							#Output array
	cur="${COMP_WORDS[COMP_CWORD]}"			#Current word
	prev="${COMP_WORDS[COMP_CWORD-1]}"		#Previous word

	switches="-f -filterSet -format -showHidden -showRemoved -showSuppressed -source"
	switches="$switches -template -user -verbose"

	completions=()

	if [[ ${prev} == "-format" ]] ; then
		#Output format completion
		completions="pdf rtf xml"
	elif [[ ${prev} == "-source" ]] ; then
		#Filename completion - .fpr
		_filedir 'fpr'
		return 0
	elif [[ ${prev} == "-f" ]] || [[ ${prev} == "-template" ]] ; then
		#Filename completion - all
		_filedir
		return 0
	else
		#Switch completion
		completions=$switches
	fi


	COMPREPLY=( $(compgen -W "${completions}" -- ${cur} ) )
	return 0
}

complete -F _reportgenerator ReportGenerator ReportGenerator.bat
