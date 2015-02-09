---
layout: page
title: Troubleshooting
---

The [setup]({{ site.baseurl }}/setup) instructions cover the majority of Jekyll sites and configurations. However, it likely has unknown gaps. If **ghpages-ghcomments** are not present on your posts or behave incorrectly, there are two ways you can get more information.

## Diagnostics

In your `_data/gpgc.yml` file, update this line:

```
enable_diagnostics: true
```

With this setting, both the terminal output from the git hooks (in `commit` and `push`) and the blog pages will give diagnostic information. For a full-length terminal session and example blog page messages, see [Use Diagnostics to Troubleshoot]({{ site.baseurl }}{% post_url 2015-02-07-use-diagnostics-to-troubleshoot %}).

## Browser Console

When you're at a laptop or desktop, you can use the developer console in Firefox or Chrome to see which requests your pages are making. For more details, see [Use the Browser Console to Troubleshoot]({{ site.baseurl }}{% post_url 2015-02-08-use-the-browser-console-to-troubleshoot %})

---

## Other advanced topics:

* [Verbose Usage](../verbose-usage)
* Troubleshooting
* [Manual](../manual)
* [Uninstall](../uninstall)
