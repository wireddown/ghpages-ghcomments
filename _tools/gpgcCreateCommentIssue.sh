#!/bin/bash
#
# gpgcCreateCommentIssue.sh
# Copyright 2015 Joe Friedrichsen
# Licensed under the Apache 2.0 License

function PrintUsage
{
   echo >&2 "Usage:"
   echo >&2 "  gpgcCreateCommentIssue.sh install 'personal_access_token'"
   echo >&2 "  gpgcCreateCommentIssue.sh bootstrap"
   echo >&2 "  gpgcCreateCommentIssue.sh commit"
   echo >&2 "  gpgcCreateCommentIssue.sh push 'personal_access_token'"
   echo >&2
}

function Diagnose()
{
  local sender="$1"
  local message="$2"
  if ${Verbose}; then
    echo "${sender}: ${message}" >> /dev/stderr
  fi
}

function InstallPreCommit()
{
  local preCommitScript="${GitRepoRoot}/.git/hooks/pre-commit"
  local installTag="hook from wireddown/ghpages-ghcomments"
  local beginInstallTag="### BEGIN ${installTag}"
  local endInstallTag="### END ${installTag}"
  Diagnose "InstallPreCommit" "preCommitScript == ${preCommitScript}"

  if ! test -f "${preCommitScript}"; then
    Diagnose "InstallPreCommit" "Creating ${preCommitScript}"
    echo "#!/bin/bash" > "${preCommitScript}"
  else
    if $(grep -q "${installTag}" "${preCommitScript}" 2>/dev/null); then
      Diagnose "InstallPreCommit" "Updating ${preCommitScript}"
      local everythingExceptThisHook="$(cat "${preCommitScript}" | sed "\!${beginInstallTag}!,\!${endInstallTag}!d")"
      echo "${everythingExceptThisHook}" > "${preCommitScript}"
    fi
  fi

  cat >> "${preCommitScript}" <<-pre-commit-hook

	${beginInstallTag}

	gpgcCreateCommentIssue="\$(which gpgcCreateCommentIssue.sh)"

	if test -x "\${gpgcCreateCommentIssue}"; then
	  "\${gpgcCreateCommentIssue}" commit
	fi

	${endInstallTag}

pre-commit-hook
}

function InstallPrePush()
{
  local prePushScript="${GitRepoRoot}/.git/hooks/pre-push"
  local installTag="hook from wireddown/ghpages-ghcomments"
  local beginInstallTag="### BEGIN ${installTag}"
  local endInstallTag="### END ${installTag}"
  Diagnose "InstallPrePush" "prePushScript == ${prePushScript}"

  if ! test -f "${prePushScript}"; then
    Diagnose "InstallPrePush" "Creating ${prePushScript}"
    echo "#!/bin/bash" > "${prePushScript}"
  else
    if $(grep -q "${installTag}" "${prePushScript}" 2>/dev/null); then
      Diagnose "InstallPrePush" "Updating ${prePushScript}"
      local everythingExceptThisHook="$(cat "${prePushScript}" | sed "\!${beginInstallTag}!,\!${endInstallTag}!d")"
      echo "${everythingExceptThisHook}" > "${prePushScript}"
    fi
  fi

  cat >> "${prePushScript}" <<-pre-push-hook

	${beginInstallTag}

	gpgcCreateCommentIssue="\$(which gpgcCreateCommentIssue.sh)"

	if test -x "\${gpgcCreateCommentIssue}"; then
	  "\${gpgcCreateCommentIssue}" push ${PersonalAccessToken}
	fi

	${endInstallTag}

pre-push-hook
}

function Install
{
  InstallPreCommit
  InstallPrePush
}

function Bootstrap
{
  local allPosts="$(find _posts -type f)"
  Diagnose "Bootstrap" "allPosts == ${allPosts}"
  AddPostsToCache ${allPosts}
}

function Commit
{
  local changedPosts="$(git diff --name-status --cached | grep "_posts/")"
  local allChangedPosts="$(echo "${changedPosts}" | awk '{print $2}')"
  Diagnose "Commit" "changedPosts == ${changedPosts}"
  Diagnose "Commit" "allChangedPosts == ${allChangedPosts}"
  AddPostsToCache ${allChangedPosts}
}

function AddPostsToCache()
{
  if test -n "$*"; then
    for post in $@; do
      if ! $(grep -q "${post}" "${GpgcCacheFile}" 2>/dev/null); then
        Diagnose "AddPostsToCache" "Adding ${post} to ${GpgcCacheFile}"
        echo "${post}" >> "${GpgcCacheFile}"
      fi
    done
  fi
}

function GetValueFromYml()
{
  local ymlFile="$1"
  local ymlKey="$2"
  local value="$(grep "^${ymlKey}:" "${ymlFile}" 2>/dev/null | head -n1 | sed "s/${ymlKey}:[[:space:]]//g" | sed s/[[:space:]]*#.*$//g | tr -d '"')"
  Diagnose "GetValueFromYml" "ymlFile == ${ymlFile}"
  Diagnose "GetValueFromYml" "ymlKey == ${ymlKey}"
  Diagnose "GetValueFromYml" "value == ${value}"
  echo "${value}"
}

function Push
{
  local siteDataFile="${GitRepoRoot}/_config.yml"
  Diagnose "Push" "siteDataFile == ${siteDataFile}"

  local repo_owner="$(GetValueFromYml "${GpgcDataFile}" repo_owner)"
  local repo_name="$(GetValueFromYml "${GpgcDataFile}" repo_name)"
  local label_name="$(GetValueFromYml "${GpgcDataFile}" label_name)"
  local label_color="$(GetValueFromYml "${GpgcDataFile}" label_color)"

  if ! $(LabelExists "${repo_owner}" "${repo_name}" "${label_name}"); then
    if $(CreateLabel "${repo_owner}" "${repo_name}" "${label_name}" "${label_color}"); then
      echo "Created label \"${label_name}\" for \"${repo_owner}/${repo_name}\""
    else
      echo "Error: could not create label \"${label_name}\" for \"${repo_owner}/${repo_name}\""
      exit
    fi
  fi

  local allCommittedPosts="$(cat "${GpgcCacheFile}" 2>/dev/null)"
  Diagnose "Push" "allCommittedPosts == ${allCommittedPosts}"
  local resetCacheFile=false
  if test -n "${allCommittedPosts}"; then
    for committed_post in ${allCommittedPosts}; do
      if test -f "${committed_post}"; then
        local post_title="$(GetValueFromYml "${committed_post}" title)"
        local site="$(GetValueFromYml "${siteDataFile}" url)"
        local year="$(basename "${committed_post}" | awk -F '-' '{print $1}')"
        local month="$(basename "${committed_post}" | awk -F '-' '{print $2}')"
        local day="$(basename "${committed_post}" | awk -F '-' '{print $3}')"
        local post_slug="$(basename "${committed_post}" | sed 's/^[0-9]\+-[0-9]\+-[0-9]\+-//' | sed 's/\.[a-zA-Z]\+$//')"
        local post_url="${site}/${year}/${month}/${day}/${post_slug}"

        if ! $(IssueExists "${repo_owner}" "${repo_name}" "${post_title}"); then
          if $(CreateIssue "${repo_owner}" "${repo_name}" "${post_title}" "${post_url}" "${label_name}"); then
            echo "Created issue \"${post_title}\" for \"${repo_owner}/${repo_name}\""
            resetCacheFile=:
          else
            echo "Error: could not create issue \"${post_title}\" for \"${repo_owner}/${repo_name}\""
            exit
          fi
        else
          resetCacheFile=:
        fi

        if ${resetCacheFile}; then
          Diagnose "Push" "Resetting ${GpgcCacheFile}"
          echo > "${GpgcCacheFile}"
        fi
      fi
    done
  fi

}

function LabelExists()
{
  local owner="$1"
  local repo="$2"
  local label="$3"
  Diagnose "LabelExists" "Querying \"https://api.github.com/repos/${owner}/${repo}/labels\" for \"${label}\""
  local labelList="$(curl -s https://api.github.com/repos/${owner}/${repo}/labels)"
  Diagnose "LabelExists" "${labelList}"
  if echo "${labelList}" | grep -q "\"name\": \"${label}\""; then
    echo :
  else
    echo false
  fi
}

function CreateLabel()
{
  local owner="$1"
  local repo="$2"
  local label="$3"
  local color="$4"
  local body="{\"name\":\"${label}\",\"color\":\"${color}\"}"
  Diagnose "CreateLabel" "Posting to \"https://api.github.com/repos/${owner}/${repo}/labels\" with '${body}'"
  local creationResponse="$(curl -s -H "${AuthHeader}" -d "${body}" https://api.github.com/repos/${owner}/${repo}/labels)"
  if echo "${creationResponse}" | grep -q "\"name\": \"${label}\""; then
    echo :
  else
    echo false
    echo "${creationResponse}" > /dev/stderr
    if ! ${Verbose} ; then echo "For more information, set 'enable_diagnostics' to 'true' in ${GpgcDataFile}" > /dev/stderr; fi
  fi
}

function RawUrlEncode()
{
  local string="${1}"
  local strlen=${#string}
  local encoded=""
  Diagnose "RawUrlEncode" "Encoding \"${string}\""

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  Diagnose "RawUrlEncode" "Result: \"${encoded}\""
  echo "${encoded}"
}

function IssueExists()
{
  local owner="$1"
  local repo="$2"
  local title="$3"
  local safeTitle="$(RawUrlEncode "${title}")"
  Diagnose "IssueExists" "Querying \"https://api.github.com/search/issues?q=${safeTitle}+repo:${owner}/${repo}+type:issue+in:title\" for \"${title}\""
  local issueList="$(curl -s "https://api.github.com/search/issues?q=${safeTitle}+repo:${owner}/${repo}+type:issue+in:title")"
  Diagnose "IssueExists" "${issueList}"
  if echo "${issueList}" | grep -q "\"title\": \"${title}\""; then
    echo :
  else
    echo false
  fi
}

function CreateIssue()
{
  local owner="$1"
  local repo="$2"
  local title="$3"
  local url="$4"
  local label="$5"
  local body="{\"title\":\"${title}\",\"body\":\"This is the comment thread for [${title}](${url}).\",\"assignee\":\"${owner}\",\"labels\":[\"${label}\"]}"
  Diagnose "CreateIssue" "Posting to \"https://api.github.com/repos/${owner}/${repo}/issues\" with '${body}'"
  local creationResponse="$(curl -s -H "${AuthHeader}" -d "${body}" https://api.github.com/repos/${owner}/${repo}/issues)"
  if echo "${creationResponse}" | grep -q "\"title\": \"${title}\""; then
    echo :
  else
    echo false
    echo "${creationResponse}" > /dev/stderr
    if ! ${Verbose} ; then echo "For more information, set 'enable_diagnostics' to 'true' in ${GpgcDataFile}" > /dev/stderr; fi
  fi
}

PersonalAccessToken="$2"
AuthHeader="Authorization: token ${PersonalAccessToken}"
GitRepoRoot="$(git rev-parse --show-toplevel)"
GpgcCacheFile="${GitRepoRoot}/.git/gpgc_cache"
GpgcDataFile="${GitRepoRoot}/_data/gpgc.yml"

Verbose=false
enable_diagnostics="$(GetValueFromYml "${GpgcDataFile}" enable_diagnostics)"
if test "x${enable_diagnostics}" = "xtrue"; then Verbose=: ; fi
Diagnose "(global)" "enable_diagnostics == ${enable_diagnostics}"
Diagnose "(global)" "GitRepoRoot == ${GitRepoRoot}"
Diagnose "(global)" "GpgcCacheFile == ${GpgcCacheFile}"
Diagnose "(global)" "GpgcDataFile == ${GpgcDataFile}"

Diagnose "(global)" "operation == $1"
case "$1" in
      install)   Install ;;
      bootstrap) Bootstrap ;;
      commit)    Commit  ;;
      push)      Push    ;;
      *) PrintUsage; echo "Unknown action \"$1\""; exit 1 ;;
esac
