---
layout: page
title: Setup
tags: [sidebar]
---

## Quick start

Setup is fast -- these commits show just how easy it is:

 1. [Add](https://github.com/wireddown/wireddown.github.io/commit/4c204b0a3fe7530423833731e201d60f225405bf?diff=unified) the ghpages-ghcomments files.
 1. [Configure](https://github.com/wireddown/wireddown.github.io/commit/6e3586ea934f9a16ead56ac9572f19fffe4d1e0b?diff=split) comments for your blog.
 1. [Add the CSS](https://github.com/wireddown/wireddown.github.io/commit/74a35798e15fc25ff097a0480ebbb997c0fbabc6?diff=split) to your \<head\>.
 1. [Add the comments tag](https://github.com/wireddown/wireddown.github.io/commit/53d52bce0b4f590129e5cca8dde87910a93dcb95?diff=split) to your post.html layout.
 1. Install the git hooks (skip to [step 4](#step-4) below)

## Step-by-step

{% raw %}

#### 1. [**Download** the ZIP archive](https://github.com/wireddown/ghpages-ghcomments/archive/release.zip) and unpack it.

#### 2. **Copy** the file tree into your Jekyll repository.

#### 3. **Edit** three files:

> **_data/gpgc.yml**
>
> [Specify](https://github.com/wireddown/wireddown.github.io/commit/6e3586ea934f9a16ead56ac9572f19fffe4d1e0b?diff=split) your GitHub username, Jekyll repo, and other preferences:
>
> ```
> repo_owner: __YOUR_GITHUB_USERNAME__
> repo_name: __YOUR_GITHUB_REPOSITORY__
> use_show_action: false
> label_name: Blog post comments
> label_color: 666666
> github_application:
>   client_id: 0ef...807
>   code_authenticator: https://.../authenticate/
>   callback_url: http://.../gpgc_redirect/index.html
> enable_diagnostics: false
> ```
>
> For details about the `github_application` entries, see [Custom GitHub Application](../advanced/custom-github-app/).

-

> **_includes/head.html**
> 
> [Add a link](https://github.com/wireddown/wireddown.github.io/commit/74a35798e15fc25ff097a0480ebbb997c0fbabc6?diff=split) to the `gpgc_styles.css` to the \<head\> element:
>
> ```
> <link
>   rel="stylesheet"
>   href="{{ site.baseurl }}/public/css/gpgc_styles.css">
> ```

-

> **_layouts/post.html**
>
> [Add an include tag](https://github.com/wireddown/wireddown.github.io/commit/53d52bce0b4f590129e5cca8dde87910a93dcb95?diff=split) at the bottom (or wherever you want comments to appear):
>
> ```
> {% include gpgc_comments.html post_title=page.title %}
> ```

#### <a name="step-4"></a>4. **Move** `_tools/gpgcCreateCommentIssue.sh` to your system *$PATH*.

> ```
> $ mv _tools/gpgcCreateCommentIssue.sh /usr/local/bin
> $ which gpgcCreateCommentIssue.sh
> /usr/local/bin/gpgcCreateCommentIssue.sh
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
