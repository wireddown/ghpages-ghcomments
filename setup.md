---
layout: page
title: Setup
tags: [sidebar]
---

## Quick start

Setup is fast -- these commits show just how easy it is:

 1. [Add](https://github.com/wireddown/gpgc-test/commit/e6eefb8539f1630d5e847760b288a857b31fe55e?diff=unified) the ghpages-ghcomments files.
 1. [Configure](https://github.com/wireddown/gpgc-test/commit/f73cc70e931c14f63ea8081ec3c006b67258df4d?diff=split) comments for your blog.
 1. [Add the CSS](https://github.com/wireddown/gpgc-test/commit/b84c65db227b867228178a50554f3374e70a9314?diff=split) to your \<head\>.
 1. [Add the comments tag](https://github.com/wireddown/gpgc-test/commit/240420c7dd0f7ef0f2dd39c06897cf0d3e711c24?diff=split) to your post.html layout.
 1. Install the git hooks (skip to [step 4](#step-4) below)

## Step-by-step

{% raw %}

#### 1. [**Download** the ZIP archive](https://github.com/wireddown/ghpages-ghcomments/archive/release.zip) and unpack it.

#### 2. **Copy** the file tree into your Jekyll repository.

#### 3. **Edit** three files:

> **_data/gpgc.yml**
>
> At a minimum, [specify](https://github.com/wireddown/gpgc-test/commit/f73cc70e931c14f63ea8081ec3c006b67258df4d?diff=split):
>
> * your GitHub username for `repo_owner`
> * your Jekyll repo for `repo_name`
> * the full URL to gpgc\_redirect.html for `callback_url`
>
> ```
> repo_owner: __YOUR_GITHUB_USERNAME__
> repo_name: __YOUR_GITHUB_REPOSITORY__
> use_show_action: false
> label_name: Blog post comments
> label_color: 666666
> github_application:
>   client_id: 0ef5ca17b24db4e46807
>   code_authenticator: https://ghpages-ghcomments.herokuapp.com/authenticate/
>   callback_url: http://__URL_OF_GPGC_REDIRECT_PAGE__
> enable_diagnostics: false
> ```
>
> For details about the `github_application` entries, see [Custom GitHub Application](../advanced/custom-github-app/).

##

> **_includes/head.html**
> 
> [Add a link](https://github.com/wireddown/gpgc-test/commit/b84c65db227b867228178a50554f3374e70a9314?diff=split) to the `gpgc_styles.css` to the \<head\> element:
>
> ```
> <link
>   rel="stylesheet"
>   href="{{ site.baseurl }}/public/css/gpgc_styles.css">
> ```

##

> **_layouts/post.html**
>
> [Add an include tag](https://github.com/wireddown/gpgc-test/commit/240420c7dd0f7ef0f2dd39c06897cf0d3e711c24?diff=split) at the bottom (or wherever you want comments to appear):
>
> ```
> {% include gpgc_comments.html post_title=page.title %}
> ```

#### <a name="step-4"></a>4. **Move** `_tools/gpgcCreateCommentIssue.sh` to your system *$PATH*.

> ```
> $ mv _tools/gpgcCreateCommentIssue.sh /usr/local/bin
> $ sudo chmod +x /usr/local/bin/gpgcCreateCommentIssue.sh
> $ if test -x "`which gpgcCreateCommentIssue.sh`"; then echo ok; fi
> ok
> ```

#### 5. **Install** the git hooks. From your repository root:

```
$ gpgcCreateCommentIssue.sh install <personal_access_token>
```

Where **\<personal\_access\_token\>** is your [GitHub personal API access token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/). Your token must have the `public_repo` [scope](https://developer.github.com/v3/oauth/#scopes) so that the hooks can create labels and issues in your repository.

#### 6. **Push** to your Jekyll site:

```
git add _includes/head.html
git add _layouts/post.html
git add _data/gpgc.yml
git add _includes/gpgc_comments.html
git add public/css/gpgc_styles.css
git add public/html/gpgc_redirect.html
git add public/js/gpgc_core.js
git commit -m "Add ghpages-ghcomments"
git push
```

{% endraw %}

#### 7. New posts now have GitHub comments! See [Usage]({{ site.baseurl }}/usage) for a refresher or [Verbose Usage]({{ site.baseurl }}/advanced/verbose-usage) for more details. If you're having trouble, see [Troubleshooting]({{ site.baseurl }}/advanced/troubleshooting/).

---

## Review
 1. [Advantages]({{ site.baseurl }}/about)
 1. [Examples]({{ site.baseurl }}/examples)
 1. [Usage]({{ site.baseurl }}/usage)
 1. [Options]({{ site.baseurl }}/options)
 1. Setup
