---
layout: page
title: Setup
tags: [sidebar]
---

## Quick start

Setup is straightforward -- these commits show just how easy it is:

 1. Create a GitHub developer application, so readers trust your site.
 1. Create an instance of Gatekeeper, so readers can login to leave comments.
 1. [Add](https://github.com/pixated/pixated.github.io/commit/09a909b642fcaa3d2fff7b23857b09def64cd339?diff=unified) the ghpages-ghcomments files.
 1. [Configure](https://github.com/pixated/pixated.github.io/commit/1f4e26e0a9f3ac5fb02c21cc8e2789ec3e1369d0?diff=split) comments for your blog.
 1. [Add the CSS](https://github.com/pixated/pixated.github.io/commit/1e799e7fd73b87c52d513e0ec63d45f88775b101?diff=split) to your \<head\>.
 1. [Add the comments tag](https://github.com/pixated/pixated.github.io/commit/1ff031d14b36c93ca3afcdac668a5736ea6bac03?diff=split) to your post.html layout.
 1. Install the git hooks (skip to [step 6](#step-6) below)

## Step-by-step

{% raw %}

#### 1. **Create** a GitHub developer application

1. Go to your GitHub [settings](https://github.com/settings/applications) page
1. **Select** the *Applications* item on the left
1. In the *Developer applications* panel, **select** *Register new application*
1. **Fill** in the form:
 * *Application name* -- anything is ok, consider using your site's title
 * *Homepage URL* -- use the URL to your site
 * *Application description* -- anything is ok, consider using *"Comments for [your site's title]"*
 * *Authorization callback URL* -- use the URL to your site
 * Add an application image -- consider using your site's favicon.ico
1. Once created, you'll see your *Client ID* and *Client Secret*

#### 2. **Create** an instance of [Gatekeeper](https://github.com/prose/gatekeeper)

These instructions use Heroku, but you can use a different provider (like Azure) or you can use your own server (see [Custom GitHub Application](../advanced/custom-github-app/) for more details).

1. **Prepare** Heroku
 * [**Create** a Heroku account](https://signup.heroku.com/) if you don't have one already
 * **Install** the [Toolbelt](https://toolbelt.heroku.com/)
1. **Clone** Gatekeeper:
 * `git clone https://github.com/prose/gatekeeper.git`
 * `cd gatekeeper`
1. **Login** to Heroku on the command line:
 * `heroku login`
1. **Create** your Heroku app, with your own `APP_NAME`
 * `heroku apps:create APP_NAME`
1. **Give** your Heroku environment your own `XXXX` and `YYYY` GitHub application credentials:
 * `heroku config:set OAUTH_CLIENT_ID=XXXX`
 * `heroku config:set OAUTH_CLIENT_SECRET=YYYY`
1. **Deploy** your Gatekeeper clone to Heroku:
 * `git push heroku master`
1. **Check** that it's working:
 * `curl https://APP_NAME.herokuapp.com/authenticate/1234`

> ```
> {
>   "error": "bad_code"
> }
> ```

#### 3. [**Download** the ZIP archive](https://github.com/wireddown/ghpages-ghcomments/archive/release.zip) and unpack it.

#### 4. **Copy** the file tree into your Jekyll repository.

#### 5. **Edit** three files:

> **_data/gpgc.yml**
>
> [Specify](https://github.com/pixated/pixated.github.io/commit/1f4e26e0a9f3ac5fb02c21cc8e2789ec3e1369d0?diff=split):
>
> * your GitHub username for `repo_owner`
> * your Jekyll repo for `repo_name`
> * your GitHub application Client ID for `client_id`
> * your Heroku (or other) application URL for `code_authenticator`
> * the full URL to gpgc\_redirect.html for `callback_url`
>
> ```
> repo_owner: __YOUR_GITHUB_USERNAME__
> repo_name: __YOUR_GITHUB_REPOSITORY__
> use_show_action: false
> label_name: Blog post comments
> label_color: 666666
> github_application:
>   client_id: __YOUR_GITHUB_APP_CLIENT_ID__
>   code_authenticator: https://__YOUR_HEROKU_APP__.herokuapp.com/authenticate/
>   callback_url: http://__URL_OF_GPGC_REDIRECT_PAGE__
> enable_diagnostics: false
> ```

##

> **_includes/head.html**
> 
> [Add a link](https://github.com/pixated/pixated.github.io/commit/1e799e7fd73b87c52d513e0ec63d45f88775b101?diff=split) to the `gpgc_styles.css` to the \<head\> element:
>
> ```
> <link
>   rel="stylesheet"
>   href="{{ site.baseurl }}/public/css/gpgc_styles.css">
> ```

##

> **_layouts/post.html**
>
> [Add an include tag](https://github.com/pixated/pixated.github.io/commit/1ff031d14b36c93ca3afcdac668a5736ea6bac03?diff=split) at the bottom (or wherever you want comments to appear):
>
> ```
> {% include gpgc_comments.html post_title=page.title %}
> ```

#### <a name="step-6"></a>6. **Move** `_tools/gpgcCreateCommentIssue.sh` to your system *$PATH*.

```
$ mv _tools/gpgcCreateCommentIssue.sh /usr/local/bin
$ sudo chmod +x /usr/local/bin/gpgcCreateCommentIssue.sh
$ if test -x "`which gpgcCreateCommentIssue.sh`"; then echo ok; fi
ok
```

#### 7. **Install** the git hooks. From your repository root:

```
$ gpgcCreateCommentIssue.sh install <personal_access_token>
```

Where **\<personal\_access\_token\>** is your [GitHub personal API access token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/). Your token must have the `public_repo` [scope](https://developer.github.com/v3/oauth/#scopes) so that the hooks can create labels and issues in your repository.

#### 8. **Push** to your Jekyll site:

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

#### 9. **Enable** comments for posts you have already published:

```
$ gpgcCreateCommentIssue.sh bootstrap
$ gpgcCreateCommentIssue.sh push <personal_access_token>
```

#### 10. New posts now have GitHub comments! See [Usage]({{ site.baseurl }}/usage) for a refresher or [Verbose Usage]({{ site.baseurl }}/advanced/verbose-usage) for more details. If you're having trouble, see [Troubleshooting]({{ site.baseurl }}/advanced/troubleshooting/).

---

## Review
 1. [Advantages]({{ site.baseurl }}/about)
 1. [Examples]({{ site.baseurl }}/examples)
 1. [Usage]({{ site.baseurl }}/usage)
 1. [Options]({{ site.baseurl }}/options)
 1. Setup
