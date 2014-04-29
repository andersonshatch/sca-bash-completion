#!/bin/bash

#Bash completion for SCA and tools - http://github.com/andersonshatch/sca-bash-completion
#Copyright (c) 2014 Josh Anderson
#See attached LICENSE or visit above URL

_sourceanalyzer()
{
	local cur prev opts
	COMPREPLY=()									#Output array
	cur="${COMP_WORDS[COMP_CWORD]}"					#Current word
	prev="${COMP_WORDS[COMP_CWORD-1]}"				#Previous word

	opts="-64 -append -b -build-label -build-project -build-version -cp -classpath -clean -clobber-log"
	opts="$opts -debug -debug-verbose -disable-default-rule-type -disable-source-rendering -dotnet-sources"
	opts="$opts -encoding -exclude -f -filter -findbugs -format -h -help -j -libdirs -logfile"
	opts="$opts -no-default-issue-rules -no-default-rules -no-default-source-rules -no-default-sink-rules"
	opts="$opts -php-source-root -python-path -quick -quiet -rules"
	opts="$opts -scan -show-files -show-build-ids -show-build-tree -show-build-warnings -source -sql-language"
	opts="$opts -verbose -version -vsversion -Xms -Xmx -Xss -?"

	local completions=()

	if [[ ${prev} == "-b" ]] ; then
		#Complete from known build IDs
		local fortifyDir="$HOME/.fortify"
		if [[ -n $COMSPEC ]] ; then
			#Windows, assume cygwin
			local fortifyDir=`cygpath $LOCALAPPDATA/fortify`
		fi

		local buildDir=`ls -dr $fortifyDir/sca*/build 2> /dev/null | head -n 1`
		completions=`find $buildDir -name "*.scasession" -exec basename {} .scasession \;`
	elif [[ ${prev} == "-rules" ]] ; then
		#Filename completion - .xml and .bin
		_filedir '@(xml|bin)'
		return 0
	elif [[ ${prev} == "-source" ]] ; then
		#Complete supported JDK versions
		completions=`echo 1.{3..8}`
	elif [[ ${prev} == "-sql-language" ]] ; then
		#Complete SQL dialects
		completions="PLSQL TSQL"
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
	local cur prev keywords switches
	COMPREPLY=()								#Output array
	cur="${COMP_WORDS[COMP_CWORD]}"				#Current word
	prev="${COMP_WORDS[COMP_CWORD-1]}"			#Previous word

	keywords="archiveRuntimeEvents checkPermission"
	keywords="$keywords deleteRuntimeEventArchive downloadAttachment downloadFPR downloadRuntimeEventArchive"
	keywords="$keywords import invalidatetoken listProjectVersions listRuntimeApplications listRuntimeEventArchives listtokens"
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
	elif [[ ${prev} == "-f" ]] || [[ ${prev} == "-file" ]] || [[ ${prev} == "-bundle" ]] ; then
		#File completion
		_filedir
		return 0
	elif [[ ${prev} == "-url" ]] ; then
		#Complete from user specified SSC URL
		completions=$SSC_URL
	elif [[ ${prev} == "-user" ]] ; then
		if [[ -n $SSC_USER ]] ; then
			#Complete user specified SSC username
			completions=$SSC_USER
		else
			#Complete guessed usernames (just admin and current username)
			completions="admin $USER"
		fi
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
	local cur prev switches
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
	local cur prev switches
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
	local cur prev switches
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

_scastate()
{
	local cur prev switches
	COMPREPLY=()							#Output array
	cur="${COMP_WORDS[COMP_CWORD]}"			#Current word
	prev="${COMP_WORDS[COMP_CWORD-1]}"		#Previous word

	switches="-a --all -debug -h -help --heap-dump -progress -properties"
	switches="$switches -scaversion -timers -version -vminfo"

	if [[ $cur =~ ^[0-9]+$ ]] ; then
		#Process ID completion
		_pids
	elif [[ $prev == "--heap-dump" ]] ; then
		#Filename completion - all
		_filedir
		return 0
	else
		#Switch completion
		COMPREPLY=( $(compgen -W "${switches}" -- ${cur} ) )
	fi

	return 0
}

complete -F _scastate SCAState SCAState.cmd

_auditworkbench()
{
	local cur prev
	COMPREPLY=()							#Output array
	cur="${COMP_WORDS[COMP_CWORD]}"			#Current word
	prev="${COMP_WORDS[COMP_CWORD-1]}"		#Previous word

	#Complete openable types
	_filedir '@(fpr|fvdl)'
	return 0
}

complete -F _auditworkbench auditworkbench auditworkbench.cmd
