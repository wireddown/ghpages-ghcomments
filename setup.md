---
layout: page
title: Setup
---

Setup is fast -- [this commit](https://github.com/wireddown/ghpages-ghcomments/commit/fbaee48cd7a8be33b76e26813d4fe81733146aac?diff=unified) shows just how easy it is.

{% raw %}

#### 1. [**Download** the ZIP archive](https://github.com/wireddown/ghpages-ghcomments/archive/release.zip) and unpack it.

#### 2. **Copy** the file tree into your Jekyll repository.

#### 3. **Move** `_tools/gpgcCreateCommentIssue.sh` to your *$PATH*.

#### 4. **Edit** three files:

> **_includes/head.html**
> 
> Add a link to the `ghpages-ghcomments.css` to the \<head\> element:
>
> ```
> <link rel="stylesheet" href="{{ site.baseurl }}public/css/ghpages-ghcomments.css">
> ```

-

> **_layouts/post.html**
>
> Add an include tag at the bottom (or wherever you want comments to appear):
>
> ```
> {% include gpgc_comments.html post_title=post.title %}
> ```

-

> **_data/gpgc.yml**
>
> Specify your GitHub username, Jekyll repo, and other preferences:
>
> ```
> repo_owner: your_github_username
> repo_name: your_github_repository
> use_show_action: true
> label_name: Blog post comments
> label_color: 666666
> ```

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
