---
layout: page
title: Setup
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
> repo_owner: your_github_username
> repo_name: your_github_repository
> use_show_action: true
> label_name: Blog post comments
> label_color: 666666
> ```

-

> **_includes/head.html**
> 
> [Add a link](https://github.com/wireddown/wireddown.github.io/commit/74a35798e15fc25ff097a0480ebbb997c0fbabc6?diff=split) to the `ghpages-ghcomments.css` to the \<head\> element:
>
> ```
> <link rel="stylesheet" href="{{ site.baseurl }}public/css/ghpages-ghcomments.css">
> ```

-

> **_layouts/post.html**
>
> [Add an include tag](https://github.com/wireddown/wireddown.github.io/commit/53d52bce0b4f590129e5cca8dde87910a93dcb95?diff=split) at the bottom (or wherever you want comments to appear):
>
> ```
> {% include gpgc_comments.html post_title=page.title %}
> ```

#### <a name="step-4"></a>4. **Move** `_tools/gpgcCreateCommentIssue.sh` to your *$PATH*.

#### 5. **Install** the git hooks:

```
$ gpgcCreateCommentIssue.sh install <personal_access_token>
```

Where **\<personal\_access\_token\>** is your [GitHub personal API access token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/).

#### 6. **Push** to your Jekyll site:

```
git add _includes/head.html
git add _layouts/post.html
git add _data/gpgc.yml
git add _includes/gpgc_comments.html
git add public/css/ghpages-ghcomments.css
git commit -m "Add ghpages-ghcomments"
git push
```

{% endraw %}

#### 7. New posts now have GitHub comments! See [Usage]({{ site.baseurl }}usage) for a refresher.

---

## Review
 1. [Advantages]({{ site.baseurl }}about)
 1. [Examples]({{ site.baseurl }}examples)
 1. [Usage]({{ site.baseurl }}usage)
 1. [Options]({{ site.baseurl }}options)
 1. Setup
