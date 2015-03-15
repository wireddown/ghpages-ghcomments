---
layout: page
title: Options
tags: [sidebar]
---

### Show or cloak comments on page load

When you set up [**ghpages-ghcomments**](https://github.com/wireddown/ghpages-ghcomments/tree/release), you can specify when your readers see comments:

 * By default, comments are loaded and presented immediately.
 * Or, you make make comments **loaded and cloaked**, and then presented when *"Show Comments"* is clicked or tapped.

### Customize the look and feel to match your Jekyll theme

All of the HTML elements have CSS classes assigned to them, making it easy to control how you present the comments.

By default, the elements have been tuned for [poole/lanyon](https://github.com/poole/lanyon). If you chose a different color theme than this one, you can change the color of the comments buttons to match yours by updating the `.gpgc-color-theme` classes in the CSS.

### Use your own GitHub API application

[**ghpages-ghcomments**](https://github.com/wireddown/ghpages-ghcomments/tree/release) allows your readers to login and post comments on your post pages because it is small [GitHub API web application](https://developer.github.com/v3/oauth/#web-application-flow). As such, **ghpages-ghcomments** uses its own GitHub client application: [https://ghpages-ghcomments.herokuapp.com/authenticate/:code](https://ghpages-ghcomments.herokuapp.com/authenticate/:code), which has two notable impacts:

1. a 1-2 second delay the *first* time your reader logs in
1. an intermediate actor in the authentication chain

For more details, see [Custom GitHub Application]({{ site.baseurl }}/advanced/custom-github-app/).

### Use a custom label name and color

Since GitHub hosts your comment threads in your repository's Issues, you can use a custom label name and color for your site's comments threads.

If you have many Jekyll sites, you can **use one repository to host *all* of the comments** but group them by label and color for easy inspection.

---

## Read more
 1. [Advantages]({{ site.baseurl }}/about)
 1. [Examples]({{ site.baseurl }}/examples)
 1. [Usage]({{ site.baseurl }}/usage)
 1. Options
 1. [**Setup**]({{ site.baseurl }}/setup)
