#!/bin/bash
#
# gpgcCreateCommentIssue.sh
# Copyright 2015 Joe Friedrichsen
# Licensed under the Apache 2.0 License

function PrintUsage
{
   echo >&2 "Usage:"
   echo >&2 "  gpgcCreateCommentIssue.sh install 'personal_access_token'"
   echo >&2 "  gpgcCreateCommentIssue.sh commit"
   echo >&2 "  gpgcCreateCommentIssue.sh push 'personal_access_token'"
   echo >&2
}

function InstallPreCommit()
{
  local preCommitScript="${GitRepoRoot}/.git/hooks/pre-commit"
  local installTag="hook from wireddown/ghpages-ghcomments"
  local beginInstallTag="### BEGIN ${installTag}"
  local endInstallTag="### END ${installTag}"

  if ! test -f "${preCommitScript}"; then
    echo "#!/bin/bash" > "${preCommitScript}"
  else
    if $(grep -q "${installTag}" "${preCommitScript}" 2>/dev/null); then
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

  if ! test -f "${prePushScript}"; then
    echo "#!/bin/bash" > "${prePushScript}"
  else
    if $(grep -q "${installTag}" "${prePushScript}" 2>/dev/null); then
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

function Commit
{
  local changedPosts="$(git diff --name-status --cached | grep "_posts/")"
  local allChangedPosts="$(echo "${changedPosts}" | awk '{print $2}')"
  if test -n "${allChangedPosts}"; then
    for changed_post in ${allChangedPosts}; do
      if ! $(grep -q "${changed_post}" "${GpgcCacheFile}" 2>/dev/null); then
        echo "${changed_post}" >> "${GpgcCacheFile}"
      fi
    done
  fi
}

function Push
{
  local gpgcDataFile="${GitRepoRoot}/_data/gpgc.yml"
  local siteDataFile="${GitRepoRoot}/_config.yml"

  local repo_owner="$(grep "^repo_owner:" "${gpgcDataFile}" 2>/dev/null | sed 's/^repo_owner: \+//g')"
  local repo_name="$(grep "^repo_name:" "${gpgcDataFile}" 2>/dev/null | sed 's/^repo_name: \+//g')"
  local label_name="$(grep "^label_name:" "${gpgcDataFile}" 2>/dev/null | sed 's/^label_name: \+//g')"
  local label_color="$(grep "^label_color:" "${gpgcDataFile}" 2>/dev/null | sed 's/^label_color: \+//g')"

  if ! $(LabelExists "${repo_owner}" "${repo_name}" "${label_name}"); then
    if $(CreateLabel "${repo_owner}" "${repo_name}" "${label_name}" "${label_color}"); then
      echo "Created label \"${label_name}\" for \"${repo_owner}/${repo_name}\""
    else
      echo "Error: could not create label \"${label_name}\" for \"${repo_owner}/${repo_name}\""
      exit
    fi
  fi

  local allCommittedPosts="$(cat "${GpgcCacheFile}" 2>/dev/null)"
  local resetCacheFile=false
  if test -n "${allCommittedPosts}"; then
    for committed_post in ${allCommittedPosts}; do
      if test -f "${committed_post}"; then
        local post_title="$(grep "^title:" "${committed_post}" | sed 's/^title: \+//g')"
        local site="$(grep "^url:" "${siteDataFile}" | sed 's/^url: \+//g')"
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
  local labelList="$(curl -s https://api.github.com/repos/${owner}/${repo}/labels)"
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
  local creationResponse="$(curl -s -H "${AuthHeader}" -d "${body}" https://api.github.com/repos/${owner}/${repo}/labels)"
  if echo "${creationResponse}" | grep -q "\"name\": \"${label}\""; then
    echo :
  else
    echo false
    echo "${creationResponse}" > /dev/stderr
  fi
}

function RawUrlEncode()
{
  local string="${1}"
  local strlen=${#string}
  local encoded=""

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}"
}

function IssueExists()
{
  local owner="$1"
  local repo="$2"
  local title="$3"
  local safeTitle="$(RawUrlEncode "${title}")"
  local issueList="$(curl -s "https://api.github.com/search/issues?q=${safeTitle}+repo:${owner}/${repo}+type:issue+in:title")"
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
  local creationResponse="$(curl -s -H "${AuthHeader}" -d "${body}" https://api.github.com/repos/${owner}/${repo}/issues)"
  if echo "${creationResponse}" | grep -q "\"title\": \"${title}\""; then
    echo :
  else
    echo false
    echo "${creationResponse}" > /dev/stderr
  fi
}

PersonalAccessToken="$2"
AuthHeader="Authorization: token ${PersonalAccessToken}"
GitRepoRoot="$(git rev-parse --show-toplevel)"
GpgcCacheFile="${GitRepoRoot}/.git/gpgc_cache"

case "$1" in
      install) Install ;;
      commit)  Commit  ;;
      push)    Push    ;;
      *) PrintUsage; echo "Unknown action \"$1\""; exit 1 ;;
esac
