---
layout: page
title: Manual
---

## Contents

* [Theory of Operation](#theory-of-operation)
  * [Jekyll](#jekyll)
  * [JavaScript](#javascript)
  * [git](#git)
* [HTML Structure](#html-structure)
  * [On load](#on-load)
  * [When there are no comments](#no-comments)
  * [When there are comments](#comments)
  * [When comments are presented](#presented)
  * [Comment structure](#comment-structure)
* [Look and Feel with CSS](#look-and-feel)

## <a id="theory-of-operation"></a>Theory of Operation

ghpages-ghcomments associates a blog post with a GitHub issue using the post's **title** front matter.

For example, using this title in a post

```
---
layout: post
title: The Phrenic Shrine Reveals Itself
---
```

causes ghpages-ghcomments to look for an issue titled _The Phrenic Shrine Reveals Itself_ in a specific GitHub repository.

### <a id="jekyll"></a>Jekyll

The algorithm for retrieving and presenting comments is in **\_includes/gpgc_comments.html**, and the input data is provided by **_data/gpgc.yml** and Jekyll variables.

Including gpgc\_comments.html requires one [tag parameter](http://jekyllrb.com/docs/templates/#includes): **post_title**.

For example, adding this line to **_layouts/post.html**

{% raw %}
<pre>
{% include gpgc_comments.html post_title=page.title %}
</pre>
{% endraw %}

yields this input to **\_includes/gpgc_comments.html**

{% raw %}
<pre>
findAndCollectComments(
  "{{ site.data.gpgc.repo_owner }}",
  "{{ site.data.gpgc.repo_name }}",
  "{{ include.post_title }}");
</pre>
{% endraw %}

and is rendered to HTML by Jekyll like this:

``` html
findAndCollectComments(
  "wireddown",
  "ghpages-ghcomments",
  "The Phrenic Shrine Reveals Itself");
```

### <a id="javascript"></a>JavaScript

The JavaScript in **\_includes/gpgc_comments.html** has one entry point:

```
findAndCollectComments(
  userName,
  repositoryName,
  issueTitle);
```

The function uses its parameters to build a [GitHub query](https://developer.github.com/v3/search/#search-issues) to search a repository's issues. Continuing the example above, the request looks like:

```
https://api.github.com/search/issues?
  q=The%20Phrenic%20Shrine%20Reveals%20Itself
  +repo:wireddown/ghpages-ghcomments
  +type:issue
  +in:title
```

When the request returns, `onSearchComplete` parses the JSON sent by GitHub and

* stores the issue's browser URL in the global variable `IssueUrl`
* sends a request to [retrieve the issue's comments](https://developer.github.com/v3/issues/comments/#list-comments-on-an-issue)

Continuing the example above, the request looks like:

```
https://api.github.com/repos/wireddown/ghpages-ghcomments/issues/4/comments
```

When the request returns, `onCommentsUpdated` parses the JSON sent by GitHub and

* appends the returned comments in the global variable `CommentsArray`
* sends a request to retrieve the next page of the issue's comments

If the issue has more than 30 comments, GitHub will [paginate its responses](https://developer.github.com/guides/traversing-with-pagination/). The response's HTTP **Link** header indicates where the next page is:

```
Link:

<https://api.github.com/repositories/29450581/issues/4/comments?page=2>; rel="next",
<https://api.github.com/repositories/29450581/issues/4/comments?page=2>; rel="last"
```

Continuing the example above, the second page of comments is retrieved by sending a request that looks like:

```
https://api.github.com/repositories/29450581/issues/4/comments
```

Once the last page has been collected, `updateCommentActions` adjusts the contents of the HTML structural elements (discussed below) to show the reader two actions:

* _Show *N* Comments_, which uses `presentAllComments` and `CommentsArray` to format and insert the comments in the document
* _Leave a Comment_, which sends the reader to the comment entry box at `IssueUrl`, at the bottom of the issue page

All of the web requests for searches and comments are sent using `XMLHttpRequest` with a custom request header:

```
Accept:	application/vnd.github.v3.html+json
```

This asks GitHub to return everything in JSON but to [render the markdown content to HTML](https://developer.github.com/v3/media/#comment-body-properties).

In addition, GitHub has [permissive CORS](https://developer.github.com/v3/#cross-origin-resource-sharing), which allows `XMLHttpRequest` to make GitHub API calls in modern browsers without any additional configuration.

### <a id="git"></a>git

Since both the blog post and its repository issue must have the same title for the JavaScript to retrieve the comments, ghpages-ghcomments uses git hooks to automate the creation of issues when new posts are pushed to the repository.

All of the automation is installed and executed from a single **bash** script: **_tools/gpgcCreateCommentIssue.sh**. Placing the script in the system's _$PATH_ allows it to be executed by the blog author and by the git hooks.

When the script installs the hooks, it adds thin wrappers back to **gpgcCreateCommentIssue.sh**:

**pre-commit**

```
gpgcCreateCommentIssue="$(which gpgcCreateCommentIssue.sh)"

if test -x "${gpgcCreateCommentIssue}"; then
  "${gpgcCreateCommentIssue}" commit
fi
```

The **pre-commit** hook

* identifies the changed files in the **_posts** directory that are about to be committed
* stores their relative path in a file: **.git/gpgc_cache**

Continuing the example above, after committing __posts/2015-01-18-the-phrenic-shrine-reveals-itself.md_, the **gpgc_cache** file contains:

```
_posts/2015-01-18-the-phrenic-shrine-reveals-itself.md
```

**pre-push**

```
gpgcCreateCommentIssue="$(which gpgcCreateCommentIssue.sh)"

if test -x "${gpgcCreateCommentIssue}"; then
  "${gpgcCreateCommentIssue}" push 1234567890abcdef...78
fi
```

The **pre-push** hook does the majority of work. It uses **_config.yml**, **_data/gpgc.yml**, and **.git/gpgc_cache** to

* set the repository owner and name
* set the label name and color
* create the label if it doesn't already exist
* create an issue for each post in **.git/gpgc_cache** if it doesn't already exist
  * the name of the issue is taken from the `title` front matter of the post
  * the issue's content is a link to its post
* reset **.git/gpgc_cache** if an issue was created

The **pre-push** hook queries for the existence of labels and issues using `curl` and the [GitHub API](https://developer.github.com/v3/issues/labels/#list-all-labels-for-this-repository).

Continuing the example above, the `curl` request to query for the label's existence looks like:

```
curl -s "https://api.github.com/repos/wireddown/ghpages-ghcomments/labels"
```

And querying for the issue's existence looks like:

```
curl -s "https://api.github.com/search/issues?
  q=The%20Phrenic%20Shrine%20Reveals%20Itself
  +repo:wireddown/ghpages-ghcomments
  +type:issue
  +in:title"
```

When the **pre-push** hook creates a [label](https://developer.github.com/v3/issues/labels/#create-a-label) or an [issue](https://developer.github.com/v3/issues/#create-an-issue), it needs to authenticate with GitHub as the repository owner. GitHub recommends [creating an OAuth access token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/) for command line authentication, which is the 40-character string used in the hook.

`curl` passes the authentication to GitHub as an extra header using the **-H** flag:

```
-H "Authorization: token 1234567890abcdef...78"
```

`curl` passes the contents of the POST request as a string using the **-d** flag:

```
-d "{
  \"title\":\"The Phrenic Shrine Reveals Itself\",
  \"body\":\"This is the comment thread for [The Phrenic Shrine Reveals Itself](http://downtothewire.io/ghpages-ghcomments/2015/01/18/the-phrenic-shrine-reveals-itself).\",
  \"assignee\":\"wireddown\",
  \"labels\":[\"Example GitHub Pages Comments\"]
  }"
```

## <a id="html-structure"></a>HTML Structure

### <a id="on-load"></a>On load

When a post page loads, there are HTML container elements without any renderable content. To the reader, there is nothing to see.

![HTML structure on load]({{ site.baseurl }}/images/HtmlStructureOnLoad.png)

### <a id="no-comments"></a>When there are no comments

Once ghpages-ghcomments has queried GitHub for the post's comments and determines there are none, it

* places a `<p>` element in the **all-comments** `<div>`
* keeps the **load-comments-button** `<span>` empty
* places an `<a>` element in the **leave-comment-link** `<span>`

![HTML structure for no comments]({{ site.baseurl }}/images/HtmlStructureNoComments.png)

### <a id="comments"></a>When there are comments

Once ghpages-ghcomments has retrieved all of the comments for a post, it

* keeps the **all-comments** `<div>` empty
* places a `<button>` element in the **load-comments-button** `<span>`
* places an `<a>` element in the **leave-comment-link** `<span>`

![HTML structure with comments]({{ site.baseurl }}/images/HtmlStructureWithComments.png)

### <a id="presented"></a>When comments are presented

When the user clicks or taps the _"Show N Comments"_ button, it

* formats all the comments and places them in the **all-comments** `<div>`
* makes the **load-comments-button** `<span>` empty
* leaves the **leave-comment-link** `<span>` unchanged

![HTML structure showing comments]({{ site.baseurl }}/images/HtmlStructureShowingComments.png)

### <a id="comment-structure"></a>Comment structure

Each comment is placed in its own **gpgc-comment** `<div>` with the following structure:

![HTML structure for a comment]({{ site.baseurl }}/images/HtmlStructureForComment.png)

## <a id="look-and-feel"></a>Look and Feel with CSS

Class list:

* **.gpgc-actions**
  * `<div>` container that holds both the _'Show N Comments'_ and _'Leave a Comment'_ buttons
* **.gpgc-action**
  * `<span>` container that holds either the _'Show N Comments'_ or _'Leave a Comment'_ button
* **.gpgc-show**
  * `<button>` element for the _'Show N Comments'_ button
* **.gpgc-leave**
  * `<a>` element for the _'Leave a Comment'_ button
* **.gpgc-no-comments**
  * `<p>` element for _'No comments'_ message
* **.gpgc-all-comments**
  * `<div>` container that holds all of the comments
* **.gpgc-comment**
  * `<div>` container that holds a single comment's header and contents
* **.gpgc-avatar**
  * `<img>` element that presents a user's avatar
* **.gpgc-comment-contents**
  * `<div>` element that holds the GitHub comment contents

---

## Other advanced topics:

* [Verbose Usage](../verbose-usage)
* [Custom GitHub App](../custom-github-app)
* [Troubleshooting](../troubleshooting)
* Manual
* [Uninstall](../uninstall)
