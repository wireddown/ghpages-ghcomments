---
layout: page
title: Options
tags: [sidebar]
---

## Control comments by-page or site-wide

Sometimes a thread of comments descends into the worst of the web. If this happens to one of your pages, you can disable new comments on that page (here is an [example]({{ site.baseurl }}/2015/01/09/creative-business-to-business-churn/)). If you need to go further and hide the existing comments, you can do that, too.

Or, if you wish to disable new comments for your whole site, there's a one-line setting for that as well.

Learn more [here]({{ site.baseurl }}/2015/08/16/introducing-comment-control/).

### Show or cloak comments on page load

When you set up [**ghpages-ghcomments**](https://github.com/wireddown/ghpages-ghcomments/tree/release), you can specify when your readers see comments:

 * By default, comments are loaded and presented immediately.
 * Or, you make make comments **loaded and cloaked**, and then presented when *"Show Comments"* is clicked or tapped.

### Customize the look and feel to match your Jekyll theme

All of the HTML elements have CSS classes assigned to them, making it easy to control how you present the comments.

By default, the elements have been tuned for [poole/lanyon](https://github.com/poole/lanyon). If you chose a different color theme than this one, you can change the color of the comments buttons to match yours by [updating the `.gpgc-color-theme` classes](https://github.com/wireddown/gpgc-test/commit/6c9bb1b880c59211afdeccdab0011be19de4b9f7?diff=split) in the CSS.

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
