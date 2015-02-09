---
layout: post
title: Use the Browser Console to Troubleshoot
---

When you're at a laptop or desktop, you can use Firefox or Chrome to see which requests your pages are making.

### Firefox

Show the console from the **Tools** menu and selecting **Web Developer » Web Console**. By default, Firefox will only show HTTP and JavaScript warnings and errors. To see all HTTP traffic, enable the **Log** setting from the **Net** menu:

![Enable "Net" logging]({{ site.baseurl }}/images/DiagnosticsConsoleNetEnableLog.png)

From there, use `Ctrl-Shift-R` on Windows and Linux, and `Command-Shift-R` on Mac to force a full refresh and see your post's web activity. For example, here is the traffic when browsing to [Not a Sunrise but a Galaxyrise]({{ site.baseurl }}{% post_url 2015-01-12-not-a-sunrise-but-a-galaxyrise %}):

![Web activity for "Not a Sunrise but a Galaxyrise"]({{ site.baseurl }}/images/DiagnosticsConsoleWithNetLog.png)

I chose this page because it demonstrates how **ghpages-ghcomments** follows GitHub's pagination. Look at the last two GET requests. The first request retrieves the first 30 comments, and the second uses the pagination information in the header to retrieve the next and final group of comments.

### Chrome

In Chrome, the workflow is very similar although the presentation is different. Show the console from **Menu Button** and selecting **More tools » Developer Tools**. You'll see your post's web activity under the **Network** tab. The keyboard shortcut for a full refresh is the same: `Ctrl-Shift-R` on Windows and Linux, and `Command-Shift-R` on Mac.
