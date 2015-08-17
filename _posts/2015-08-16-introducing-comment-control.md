---
layout: post
title: Introducing Comment Control
---

This new feature gives you more control over comments on your pages if the web ever becomes unruly.

## You can now:

1. Prevent new comments from being added to a page
1. Hide all comments and prevent new comments on a page
1. Prevent new comments from being added site-wide

### 1. Preventing new comments from being added to a page

Add `gpgc_disabled: true` to your page's Front Matter:

```
---
layout: post
title: Creative Business-to-Business Churn
gpgc_disabled: true
---
```

*Example:* [this post]({{ site.baseurl }}/2015/01/09/creative-business-to-business-churn/) has comments disabled.

You might choose to do this if you want to stop a flame war or other harassment on the page but you don't want to hide the helpful comments that are already there. Later, you can remove the `gpgc_disabled` line and readers will be able to comment again.

### 2. Hiding all comments and preventing new comments on a page

Add the label **GPGC Muted** to the post's issue in your site's ghpages repository.

*Example:* [this post]({{ site.baseurl }}/2015/01/01/collaboratively-administrate-empowered-markets/) has had its comments hidden because [its issue](https://github.com/wireddown/ghpages-ghcomments/issues/1) has the *GPGC Muted* label.

You might choose to do this if private or confidential information has been written in one or more comments. By muting the comment issue, you can immediately hide every comment on the page while you, as the site's owner, moderate and edit the comments on the issue page. Once you've finished tidying the thread, you can remove the label and the updated comments will appear on the page.

### 3. Preventing new comments from being added site-wide

Add this line to your site's `_data/gpgc.yml` file:

```
disabled: true
```

Short of removing ghpages-ghcomments altogether, you might choose to do this if your site is experiencing malicious attacks from several commenters or a group of trolls but you don't want to hide the helpful comments that are already on your pages. Like the other options, this site-wide effect can also be reversed by removing the `disabled` line.
