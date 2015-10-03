# GitHub Comments for your GitHub Pages

With **ghpages-ghcomments**, your Jekyll site can use GitHub to provide reader comments. 

Set up is straightforward, and everything has been automated to hook into your git workflow.

[Read more](http://wireddown.github.io/ghpages-ghcomments/usage)

# Advantages

### It's good for your readers
 1. **Your readers' web habits are not tracked** by services like [Disqus](http://en.wikipedia.org/wiki/Disqus).
 1. **Your readers have full control** over their comments -- they can edit and delete them.
 1. **Page presentation is still Jekyll-fast** from lean built-in JavaScript -- no jQuery or other *"frameworks"*.
 1. **Customize the look and feel** with a small collection of CSS classes.

### It's good for you
 1. **You don't need your own dedicated server** to host a [Discourse](http://en.wikipedia.org/wiki/Discourse_%28software%29) instance.
 1. **Comment threads are automatically created** with every `git push` to your site.
 1. **Set up takes 5 minutes** and the rest is triggered -- set and forget.
 1. **Aggregate *all* of your sites' comments together** in one place -- a GitHub repository.

# Examples

The blog posts on this site show how [**ghpages-ghcomments**](https://github.com/wireddown/ghpages-ghcomments/tree/release) works.

* [Comments with markdown](http://downtothewire.io/ghpages-ghcomments/2015/01/18/the-phrenic-shrine-reveals-itself)
* [Several comments](http://downtothewire.io/ghpages-ghcomments/2015/01/12/not-a-sunrise-but-a-galaxyrise)
* [One comment](http://downtothewire.io/ghpages-ghcomments/2015/01/09/creative-business-to-business-churn)
* [No comments](http://downtothewire.io/ghpages-ghcomments/2015/01/08/mumblecore-flexitarian-thundercats)

[Browse](https://github.com/wireddown/ghpages-ghcomments/issues?q=is%3Aopen+is%3Aissue+label%3A%22Example+GitHub+Pages+Comments%22) the GitHub storage for their comments.

# Setup

These commits show just how easy it is:

* [Add new files](https://github.com/pixated/pixated.github.io/commit/09a909b642fcaa3d2fff7b23857b09def64cd339?diff=unified)
* [Configure](https://github.com/pixated/pixated.github.io/commit/1f4e26e0a9f3ac5fb02c21cc8e2789ec3e1369d0?diff=split)
* [Link to CSS](https://github.com/pixated/pixated.github.io/commit/1e799e7fd73b87c52d513e0ec63d45f88775b101?diff=split)
* [Include in posts](https://github.com/pixated/pixated.github.io/commit/1ff031d14b36c93ca3afcdac668a5736ea6bac03?diff=split)

Follow these [instructions](http://downtothewire.io/ghpages-ghcomments/setup/).

# Post index

* 02 Feb 2015: [Issue 6 is fixed](http://downtothewire.io/ghpages-ghcomments/2015/02/02/issue-6-is-fixed/)
* 07 Feb 2015: [Use Diagnostics to Troubleshoot](http://downtothewire.io/ghpages-ghcomments/2015/02/07/use-diagnostics-to-troubleshoot/)
* 08 Feb 2015: [Use the Browser Console to Troubleshoot](http://downtothewire.io/ghpages-ghcomments/2015/02/08/use-the-browser-console-to-troubleshoot/)
* 16 Aug 2015: [Introducing Comment Control](http://downtothewire.io/ghpages-ghcomments/2015/08/16/introducing-comment-control/)
* 03 Oct 2015: [Using ghpages-ghcomments with Private GitHub Repositories](http://downtothewire.io/ghpages-ghcomments/2015/10/03/using-ghpages-ghcomments-with-private-github-repositories/)

# Change log

* 20 Jan 2015: _First release_
* 02 Feb 2015: _Fix issues [#6](https://github.com/wireddown/ghpages-ghcomments/issues/6) and [#7](https://github.com/wireddown/ghpages-ghcomments/issues/7)_
* 08 Feb 2015: _Add diagnostics (issue [#10](https://github.com/wireddown/ghpages-ghcomments/issues/10))_
* 15 Mar 2015: _Add on-page comments (issue [#11](https://github.com/wireddown/ghpages-ghcomments/issues/11))_
* 21 May 2015: _Fix diagnostics; fix hooks for the Mac (issue [#17](https://github.com/wireddown/ghpages-ghcomments/issues/17))_
* 16 Aug 2015: _Add comment controls_
* 29 Sep 2015: _Add 'bootstrap' command for creating comment threads for already-published posts_

Full history: [`release` branch commit log](https://github.com/wireddown/ghpages-ghcomments/commits/release)
