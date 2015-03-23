---
layout: post
title: Use Diagnostics to Troubleshoot
---

If you're having trouble adding ghpages-ghcomments to your site, there's a setting that will help you learn more about what is failing.

In your `_data/gpgc.yml` file, update this line:

```
enable_diagnostics: true
```

With this setting, both the terminal output from the git hooks (in `commit` and `push`) and the blog pages will give diagnostic information.

## Example

### Terminal

```
$ git add _posts/2015-02-07-use-diagnostics-to-troubleshoot.md

$ git commit -m "Add post describing new setting 'enable_diagnostics'"
(global): enable_diagnostics == true
(global): GitRepoRoot == c:/repos/ghpages-ghcomments
(global): GpgcCacheFile == c:/repos/ghpages-ghcomments/.git/gpgc_cache
(global): GpgcDataFile == c:/repos/ghpages-ghcomments/_data/gpgc.yml
(global): operation == commit
Commit: changedPosts == A       _posts/2015-02-07-use-diagnostics-to-troubleshoot.md
Commit: allChangedPosts == _posts/2015-02-07-use-diagnostics-to-troubleshoot.md
Commit: Adding _posts/2015-02-07-use-diagnostics-to-troubleshoot.md to c:/repos/ghpages-ghcomments/.git/gpgc_cache
[gh-pages 45905f0] Add post describing new setting 'enable_diagnostics'
 1 file changed, 41 insertions(+)
 create mode 100644 _posts/2015-02-07-use-diagnostics-to-troubleshoot.md

$ git push origin gh-pages
(global): enable_diagnostics == true
(global): GitRepoRoot == c:/repos/ghpages-ghcomments
(global): GpgcCacheFile == c:/repos/ghpages-ghcomments/.git/gpgc_cache
(global): GpgcDataFile == c:/repos/ghpages-ghcomments/_data/gpgc.yml
(global): operation == push
Push: siteDataFile == c:/repos/ghpages-ghcomments/_config.yml
GetValueFromYml: ymlFile == c:/repos/ghpages-ghcomments/_data/gpgc.yml
GetValueFromYml: ymlKey == repo_owner
GetValueFromYml: value == wireddown
GetValueFromYml: ymlFile == c:/repos/ghpages-ghcomments/_data/gpgc.yml
GetValueFromYml: ymlKey == repo_name
GetValueFromYml: value == ghpages-ghcomments
GetValueFromYml: ymlFile == c:/repos/ghpages-ghcomments/_data/gpgc.yml
GetValueFromYml: ymlKey == label_name
GetValueFromYml: value == Example GitHub Pages Comments
GetValueFromYml: ymlFile == c:/repos/ghpages-ghcomments/_data/gpgc.yml
GetValueFromYml: ymlKey == label_color
GetValueFromYml: value == 90a959
LabelExists: Querying "https://api.github.com/repos/wireddown/ghpages-ghcomments/labels" for "Example GitHub Pages Comments"
LabelExists: [
  {
    "url": "https://api.github.com/repos/wireddown/ghpages-ghcomments/labels/bug",
    "name": "bug",
    "color": "fc2929"
  },
  {
    "url": "https://api.github.com/repos/wireddown/ghpages-ghcomments/labels/duplicate",
    "name": "duplicate",
    "color": "cccccc"
  },
  {
    "url": "https://api.github.com/repos/wireddown/ghpages-ghcomments/labels/enhancement",
    "name": "enhancement",
    "color": "84b6eb"
  },
  {
    "url": "https://api.github.com/repos/wireddown/ghpages-ghcomments/labels/help%20wanted",
    "name": "help wanted",
    "color": "159818"
  },
  {
    "url": "https://api.github.com/repos/wireddown/ghpages-ghcomments/labels/invalid",
    "name": "invalid",
    "color": "e6e6e6"
  },
  {
    "url": "https://api.github.com/repos/wireddown/ghpages-ghcomments/labels/question",
    "name": "question",
    "color": "cc317c"
  },
  {
    "url": "https://api.github.com/repos/wireddown/ghpages-ghcomments/labels/wontfix",
    "name": "wontfix",
    "color": "ffffff"
  },
  {
    "url": "https://api.github.com/repos/wireddown/ghpages-ghcomments/labels/Example%20GitHub%20Pages%20Comments",
    "name": "Example GitHub Pages Comments",
    "color": "90a959"
  },
  {
    "url": "https://api.github.com/repos/wireddown/ghpages-ghcomments/labels/in%20work",
    "name": "in work",
    "color": "5319e7"
  }
]
Push: allCommittedPosts == _posts/2015-02-07-use-diagnostics-to-troubleshoot.md
GetValueFromYml: ymlFile == _posts/2015-02-07-use-diagnostics-to-troubleshoot.md
GetValueFromYml: ymlKey == title
GetValueFromYml: value == Use Diagnostics to Troubleshoot
GetValueFromYml: ymlFile == c:/repos/ghpages-ghcomments/_config.yml
GetValueFromYml: ymlKey == url
GetValueFromYml: value == http://wireddown.github.io/ghpages-ghcomments
RawUrlEncode: Encoding "Use Diagnostics to Troubleshoot"
RawUrlEncode: Result: "Use%20Diagnostics%20to%20Troubleshoot"
IssueExists: Querying "https://api.github.com/search/issues?q=Use%20Diagnostics%20to%20Troubleshoot+repo:wireddown/ghpages-ghcomments+type:issue+in:title" for "Use Diagnostics to Troubleshoot"
IssueExists: {
  "total_count": 0,
  "incomplete_results": false,
  "items": [

  ]
}
CreateIssue: Posting to "https://api.github.com/repos/wireddown/ghpages-ghcomments/issues" with '{"title":"Use Diagnostics to Troubleshoot","body":"This is the comment thread for [Use Diagnostics to Troubleshoot](http://wireddown.github.io/ghpages-ghcomments/2015/02/07/use-diagnostics-to-troubleshoot).","assignee":"wireddown","labels":["Example GitHub Pages Comments"]}'
Created issue "Use Diagnostics to Troubleshoot" for "wireddown/ghpages-ghcomments"
Push: Resetting c:/repos/ghpages-ghcomments/.git/gpgc_cache
Counting objects: 8, done.
Delta compression using up to 2 threads.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 860 bytes | 0 bytes/s, done.
Total 4 (delta 2), reused 0 (delta 0)
To https://github.com/wireddown/ghpages-ghcomments.git
   49f71a6..45905f0  gh-pages -> gh-pages
```

### HTML

ghpages-ghcomments can detect four problems:

#### 1. gpgc Error: Missing CSS

> ![gpgc Error: Missing CSS]({{ site.baseurl }}/images/DiagnosticMissingCss.png)

#### 2. gpgc Error: CSS 404

> ![gpgc Error: CSS 404]({{ site.baseurl }}/images/DiagnosticCss404.png)

#### 3. gpgc Error: Search Failed

![gpgc Error: Search Failed]({{ site.baseurl }}/images/DiagnosticSearchFailed.png)

#### 4. gpgc Error: Missing Issue

![gpgc Error: Missing Issue]({{ site.baseurl }}/images/DiagnosticMissingIssue.png)
