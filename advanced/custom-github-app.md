---
layout: page
title: Custom GitHub App
---

In order for your readers to comment on your pages, they must be logged in to GitHub, except a third party, like a gh-pages site, does not have the authority to authenticate GitHub users. Only GitHub knows your readers' GitHub credentials, and it should stay that way. Fortunately, GitHub provides a way for other sites to securely authenticate its users, even if they use two-factor authentication (2FA).

## Motivation

**ghpages-ghcomments** uses GitHub issues as the commenting system for gh-pages sites. For a reader to create a comment on an issue, GitHub **requires** that the commenter be logged in with the `public_repo` [scope](https://developer.github.com/v3/oauth/#scopes). GitHub allows third parties, like Jekyll gh-pages sites, to let their end users to securely login to GitHub via [**OAuth**](https://developer.github.com/v3/oauth/).

## GitHub Applications

**ghpages-ghcomments** is a GitHub web application, which means it has a `client_id` and `client_secret` pair for using the GitHub API on users' behalf. GitHub web applications authenticate GitHub users in [three steps](https://developer.github.com/v3/oauth/#web-application-flow):

1. The gh-pages site redirects users to GitHub for access.
1. Once the user logs in, GitHub redirects back to the gh-pages site with a login `code`.
1. The gh-pages site exchanges the `code` for the user's OAuth `token`.

The first step requires the gh-pages site to send GitHub its `client_id` and requested access scopes. The last step requires the gh-pages site to also send the `client_secret`. This is a problem for static and fully public gh-pages sites -- if the gh-pages site kept the `client_secret` in the site's yml data, then any user could impersonate **ghpages-ghcomments**.

The only way to keep the `client_secret` fully secret is to keep it on a separate server where only **ghpages-ghcomments** has access. Another project, [Gatekeeper](https://github.com/prose/gatekeeper), has implemented a fast and simple way for GitHub web applications to keep their secrets.

**ghpages-ghcomments** uses its own Heroku instance of Gatekeeper to complete the GitHub web application authentication flow. This means there are two segments in the trust chain:

1. The ghpages-ghcomments web application
1. Heroku's cloud server

Depending on how much you trust **ghpages-ghcomments** or Heroku, you might want to eliminate or replace these segments by:

* 0. **Creating** your own GitHub web application and then
 * A. **Using** your own Heroku Gatekeeper instance, *or*
 * B. **Hosting** your own server-side authenticator.

# 0. Custom web application

Creating a GitHub application is painless:

1. Go to your [settings](https://github.com/settings/applications) page
1. **Select** the *Applications* item
1. In the *Developer applications* panel, **select** *Register new application*
1. **Fill** in the form:
 * *Application name*
 * *Homepage URL*
 * *Application description*
 * *Authorization callback URL* -- full URL to `gpgc_redirect.html` (by default, it's placed in `/public/html`)
 * Add an application image
1. Once created, you'll see your *Client ID* and *Client Secret*

# A. Heroku

If you don't trust the **ghpages-ghcomments** web application, then you can remove it from the authentication sequence by creating your own web application and Gatekeeper instance.

### Gatekeeper

Gatekeeper has a Node.js implementation, which Heroku can directly serve in a web dyno. Creating a Heroku instance of Gatekeeper is a little more involved:

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

For more details about Heroku, see their [Getting Started](https://devcenter.heroku.com/articles/getting-started-with-nodejs#introduction) and [How Heroku Works](https://devcenter.heroku.com/articles/how-heroku-works) pages.

### ghpages-ghcomments

Now that you have your own Gatekeeper instance, you can switch your site's authentication from the ghpages-ghcomments GitHub application to your own by updating `_data/gpgc.yml`:

```
github_application:
  client_id: __YOUR_CLIENT_ID__
  code_authenticator: https://__YOUR_HEROKU_APP__.herokuapp.com/authenticate/
  callback_url: http://__YOUR_CLIENT_CALLBACK_URL__
```

### Summary

1. Create your own GitHub application
1. Clone and deploy Gatekeeper to your own Heroku dyno
1. Update `_data\gpgc.yml` to match

# B. Interface

If you don't trust a Heroku web application, then you can also remove it from the authentication sequence by creating your own GitHub authenticator. At this point, you are using your own GitHub application and your own server-side process to allow your readers to log in to GitHub.

You will still be using the **ghpages-ghcomments** JavaScript, which expects a specific web interface. Your server-side authenticator must:

1. Accept a GitHub OAuth temporary `code` in the URL.
1. Use the GitHub `https://github.com/login/oauth/access_token` [API to exchange](https://developer.github.com/v3/oauth/#web-application-flow) the `code` for a `token`.
1. Respond with JSON: `{ "token": token }`

For a reference implementation, see the Gatekeeper [server.js](https://github.com/prose/gatekeeper/blob/master/server.js#L62) method ` app.get('/authenticate/:code', function(req, res))`.

### ghpages-ghcomments

Now that you have your own server-side authenticator, you can switch your site's authentication from the ghpages-ghcomments GitHub application to your own by updating `_data/gpgc.yml`:

```
github_application:
  client_id: __YOUR_CLIENT_ID__
  code_authenticator: https://__YOUR_DOMAIN__/__YOUR_SERVICE__/
  callback_url: http://__YOUR_CLIENT_CALLBACK_URL__
```

### Summary

1. Create your own GitHub application
1. Create and deploy your own GitHub web authenticator
1. Update `_data\gpgc.yml` to match

---

## Other advanced topics:

* [Verbose Usage](../verbose-usage)
* Custom GitHub App
* [Troubleshooting](../troubleshooting)
* [Manual](../manual)
* [Uninstall](../uninstall)
