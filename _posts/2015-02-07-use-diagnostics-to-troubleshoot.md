---
layout: post
title: Use Diagnostics to Troubleshoot
---

If you're having trouble adding ghpages-ghcomments to your site, there's a setting that will help you learn more about what is failing.

In your `_data/gpgc.yml` file, add a new line:

```
enable_diagnostics: true
```

With this setting, both the console output from the git hooks (in commit and push) and the blog page will give diagnostic information.

## Example


### Terminal



### HTML

ghpages-ghcomments can detect four problems:

#### 1. gpgc Error: Missing CSS

![gpgc Error: Missing CSS]({{ site.baseurl }}/images/DiagnosticMissingCss.png)

#### 2. gpgc Error: CSS 404

![gpgc Error: CSS 404]({{ site.baseurl }}/images/DiagnosticCss404.png)

#### 3. gpgc Error: Search Failed

![gpgc Error: Search Failed]({{ site.baseurl }}/images/DiagnosticSearchFailed.png)

#### 4. gpgc Error: Missing Issue

![gpgc Error: Missing Issue]({{ site.baseurl }}/images/DiagnosticMissingIssue.png)
