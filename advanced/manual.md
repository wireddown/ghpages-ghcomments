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
  * [Theme](#theme)
  * [Class list](#class-list)

## <a id="theory-of-operation"></a>Theory of Operation

ghpages-ghcomments uses GitHub issues to store comments by associating a specific page with a specific GitHub issue using the page's **title** front matter.

For example, using this title in a post

```
---
layout: post
title: The Phrenic Shrine Reveals Itself
---
```

causes ghpages-ghcomments to look for an issue titled _The Phrenic Shrine Reveals Itself_ in the GitHub repository specified by **\_data/gpgc.yml**.

### <a id="jekyll"></a>Jekyll

There are four files that implement ghpages-ghcomments:

* Structure:
  * **includes/gpgc\_comments.html**
* Behavior:
  * **public/js/gpgc_core.js**
  * **public/html/gpgc_redirect.html**
* Data:
  * **_data/gpgc.yml**

Including gpgc\_comments.html requires one [Jekyll tag parameter](http://jekyllrb.com/docs/templates/#includes): **post_title**.

For example, adding this line to **_layouts/post.html**

{% raw %}
<pre>
{% include gpgc_comments.html post_title=page.title %}
</pre>
{% endraw %}

yields this input to **\_includes/gpgc_comments.html**

{% raw %}
<pre>
  var gpgc = {
    site_url: "{{ site.url }}",
    page_path: "{{ page.path }}",
    issue_title: "{{ include.post_title }}",
    repo_id: "{{ site.data.gpgc.repo_owner }}/{{ site.data.gpgc.repo_name }}",
    use_show_action: {{ site.data.gpgc.use_show_action }},
    github_application_client_id: "{{ site.data.gpgc.github_application.client_id }}",
    github_application_code_authenticator_url: "{{ site.data.gpgc.github_application.code_authenticator }}",
    github_application_login_redirect_url: "{{ site.data.gpgc.github_application.callback_url }}",
    enable_diagnostics: {{ site.data.gpgc.enable_diagnostics }},
  };
</pre>
{% endraw %}

and is rendered to HTML by Jekyll like this:

``` js
  var gpgc = {
    site_url: "http://downtothewire.io",
    page_path: "_posts/2015-01-18-the-phrenic-shrine-reveals-itself.md",
    issue_title: "The Phrenic Shrine Reveals Itself",
    repo_id: "wireddown/ghpages-ghcomments",
    use_show_action: true,
    github_application_client_id: "0ef5ca17b24db4e46807",
    github_application_code_authenticator_url: "https://ghpages-ghcomments.herokuapp.com/authenticate/",
    github_application_login_redirect_url: "http://downtothewire.io/ghpages-ghcomments/public/html/gpgc_redirect/index.html",
    enable_diagnostics: false,
  };
```

### <a id="javascript"></a>JavaScript

ghpages-ghcomments has two fundamental capabilities:

1. Finding and showing comments, accessible to every site visitor
2. Drafting and posting a new comment, accessible to visitors that login to GitHub

#### **Finding and showing comments**

When a visitor views a page, ghpages-ghcomments uses the GitHub web API to find and show the comments for the page, which happens in three steps:

1. Use the page's title to find the associated issue in the owner's repository.
2. Retrieve the comments from the issue as HTML.
3. Place the comments in the page's DOM.

The process begins at the single entry point to **public/js/gpgc_core.js**:

```
gpgc_main();
```

After initializing the page, `gpgc_main()` calls `findAndCollectComments()`, which uses the global variable **gpgc** to build a [GitHub query](https://developer.github.com/v3/search/#search-issues) to search a repository's issues. Continuing the example above, the request looks like:

```
https://api.github.com/search/issues?
  q=The%20Phrenic%20Shrine%20Reveals%20Itself
  +repo:wireddown/ghpages-ghcomments
  +type:issue
  +in:title
```

When the request returns, `onSearchComplete()` parses the JSON sent by GitHub and

* stores the issue's browser URL in the global variable `IssueUrl`
* sends a request to [retrieve the issue's comments](https://developer.github.com/v3/issues/comments/#list-comments-on-an-issue)

Continuing the example above, the request looks like:

```
https://api.github.com/repos/wireddown/ghpages-ghcomments/issues/4/comments
```

When the request returns, `onCommentsUpdated()` parses the JSON sent by GitHub and

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

Once the last page has been collected, `updateCommentsAndActions()` adjusts the contents of the HTML structural elements (discussed below) to show the reader an action:

* _Show *N* Comments_, which uses `showAllComments()` and `CommentsArray` to format and insert the comments in the document

All of the web requests for searches and comments are sent using `XMLHttpRequest` with a custom request header:

```
Accept:	application/vnd.github.v3.html+json
```

This asks GitHub to return everything in JSON but to [render the markdown content to HTML](https://developer.github.com/v3/media/#comment-body-properties).

In addition, GitHub has [permissive CORS](https://developer.github.com/v3/#cross-origin-resource-sharing), which allows `XMLHttpRequest` to make GitHub API calls in modern browsers without any additional configuration.

#### **Drafting and posting a new comment**

When a visitor wants to leave a comment, they must login to GitHub since the comments are stored in an issue for a GitHub repository.

ghpages-ghcomments uses the [Web Application Flow](https://developer.github.com/v3/oauth/#web-application-flow) to authenticate a visitor with GitHub, which happens in three steps:

1. Open a new browser window to redirect the visitor to login to GitHub.
2. Upon login, close the newly opened window and exchange GitHub's temporary code with the visitor's OAuth token.
3. Persist the visitor's token in the browser's local storage for the site so the visitor doesn't need to login every time.

The process starts when the visitor clicks or taps the _Login_ button, which calls `loginToGitHub()` to build a **secure** [GitHub authentication request](https://developer.github.com/v3/oauth/#redirect-users-to-request-github-access) with URL-encoded data:

``` js
  var data = {
    "client_id": gpgc.github_application_client_id,
    "scope": "public_repo",
    "state": StateChallenge,
    "redirect_uri": gpgc.github_application_login_redirect_url
  };
```

This request is opened in a new browser window so that it can handle GitHub's redirect and send the original window a message event. When the visitor logs in using the new window, GitHub redirects back to the `redirect_uri` with a temporary `code` and the `state` provided in the request. The `redirect_uri` is a simple JavaScript-only Jekyll page (**public/html/gpgc_redirect.html**) that uses the data from GitHub's response to send a message event to the original window before closing itself.

The original window handles the event in `onMessage()`, and inspects the event data to confirm the security of the transaction. Once the message has been verified, ghpages-ghcomments uses a simple GitHub application to exchange the temporary code with a revocable OAuth token. For more details about this step, see [Custom GitHub App](../custom-github-app/).

The last login step is saving the OAuth token in the site's local storage. The next time the visitor returns, ghpages-ghcomments automatically authenticates them with GitHub with the [User API](https://developer.github.com/v3/users/#get-the-authenticated-user).

Once logged in, the visitor can post their draft as a new comment. ghpages-ghcomments uses the [GitHub Markdown API](https://developer.github.com/v3/markdown/#render-an-arbitrary-markdown-document) to render a markdown draft in HTML when the visitor clicks or taps the _Preview_ button, and uses the [GitHub Issue API](https://developer.github.com/v3/issues/comments/#create-a-comment) to add comment to the page's associated issue when the visitor clicks or taps the _Submit_ button.

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

The source is the authority on the HTML structure (**[includes/gpgc\_comments.html](https://raw.githubusercontent.com/wireddown/ghpages-ghcomments/release/_includes/gpgc_comments.html)**) but here is an [image illustrating the layout]({{ site.baseurl }}/images/HtmlStructureComplete.png). It will be helpful to keep one of these open while reading this section.

### <a id="on-load"></a>On load

When a ghcomments-ghpages page loads, several `<div>` elements begin hidden:

* **gpgc\_all\_comments**, which holds all of the comments
* **gpgc\_no\_comments**, which holds a message saying there are no comments
* **gpgc\_actions**, which allows the visitor to show comments
* **gpgc\_reader\_error**, which shows any error or diagnostic messages

At the same time, ghpages-ghcomments searches for the page's associated issue and its comments. Depending on whether there are comments, the layout updates. Regardless, the new comment form is initialized to allow the visitor to draft a comment.

### <a id="no-comments"></a>When there are no comments

Once ghpages-ghcomments has queried GitHub for the post's comments and determines there are none, it shows the **gpgc\_no\_comments** `<div>`.

### <a id="comments"></a>When there are comments

Once ghpages-ghcomments has retrieved all of the comments for a post, it

* formats all the comments via `formatAllComments()` and places them in the still-hidden **gpgc\_all\_comments** `<div>`
* updates the **show\_comments\_button** `<button>` with a "Show *N* comments" message

If **data/gpgc.yml** specifies **true** for `use_show_action`, then ghpages-ghcomments shows the **show\_comments\_button** `<button>`; otherwise, it shows the **gpgc\_all\_comments** `<div>`.

### <a id="presented"></a>When comments are presented

When the user clicks or taps the **show\_comments\_button** `<button>`, ghpages-ghcomments hides the button and shows the **gpgc\_all\_comments** `<div>`.

### <a id="comment-structure"></a>Comment structure

Each comment is placed in its own `<div>` with the following structure:

![HTML structure for a comment]({{ site.baseurl }}/images/HtmlStructureForComment.png)

## <a id="look-and-feel"></a>Look and Feel with CSS

### <a id="theme"></a>Theme

The color theme is specified at the top of **public/css/gpgc_styles.css**.

### <a id="class-list"></a>Class list

* Comments
  * **.gpgc-comment**
    <br /> `<div>` container that holds a single comment's header and contents
  * **.gpgc-comment-header**
    <br /> `<div>` container that holds a single comment's header
  * **.gpgc-avatar**
    <br /> `<img>` element that presents a user's avatar
  * **.gpgc-comment-contents**
    <br /> `<div>` container that holds the GitHub comment contents
* New comment
  * **.gpgc-new-comment**
    <br /> `<div>` container that holds the comment draft elements
  * **.gpgc-new-comment-form**
    <br /> `<div>` container that holds the comment form
  * **gpgc-new-comment-form-textarea**
    <br /> `<textarea>` element for entering a new comment
  * **.gpgc-tabs**
    <br /> `<div>` container that holds the _Write_ and _Preview_ buttons
  * **.gpgc-tab**
    <br /> `<button>` element that behaves like tab
  * **.gpgc-new-comment-actions**
    <br /> `<div>` container that holds the _Login_ and _Submit_ buttons
  * **.gpgc-comment-help**
    <br /> `<div>` container that holds just-in-time help messages
* _'Show N Comments'_ button
  * **.gpgc-actions**
    <br /> `<div>` container that holds the _'Show N Comments'_ `<span>`
  * **.gpgc-action**
    <br /> `<span>` container that holds the _'Show N Comments'_ `<button>`
* Mixins
  * **.gpgc-hidden**
    <br /> Hides an element
  * **.gpgc-centered-text**
    <br /> Centers the text in the element
  * **.gpgc-comments-font**
    <br /> Sets the font traits for the element
  * **.gpgc-new-section**
    <br /> Sets the top margin for the element
  * **.gpgc-normal-primary-button**
    <br /> `<button>` element that has an emphasized look and feel
  * **.gpgc-large-secondary-button**
    <br /> `<button>` element that has a diminished look and feel
  * **.gpgc-text-button**
    <br /> `<button>` element that has a text look and feel
  * **.gpgc-help-message**
    <br /> `<div>` container for showing a help message
  * **.gpgc-help-error**
    <br /> `<div>` container for showing an error message
* Misc
  * **.gpgc\_last\_div**
    <br /> `<div>` container for the last div, adds a bottom margin

---

## Other advanced topics:

* [Verbose Usage](../verbose-usage)
* [Custom GitHub App](../custom-github-app)
* [Troubleshooting](../troubleshooting)
* Manual
* [Uninstall](../uninstall)
