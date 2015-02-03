---
layout: page
title: Verbose Usage
---

### Summary

This is the terminal log from creating the post [Issue 6 is fixed](http://downtothewire.io/ghpages-ghcomments/2015/02/02/issue-6-is-fixed/).

### Post name and contents

```
$ cat _posts/2015-02-02-issue-6-is-fixed.md
```

> ```
> ---
> layout: post
> title: "Issue 6 is fixed" # This line shows issue #6 is fixed
> ---
> 
> This is a post that demonstrates [wireddown/ghpages-ghcomments#6](https://github.com/wireddown/ghpages-ghcomments/issues/6) is fixed.
> 
> Look at the raw view, these contents are ignored:
> 
> * in-line comment in the front matter
> * bookend double quotes in the value
> 
> '''
> ---
> layout: post
> title: "Issue 6 is fixed" # This line shows issue #6 is fixed
> ---
> '''

### Add the post

```
$ git add _posts/2015-02-02-issue-6-is-fixed.md
```

### Commit the post

```
$ git commit -m "Add post showing issue #6 is fixed"
```

> ```
[gh-pages 07da9e7] Add post showing issue #6 is fixed
 1 file changed, 18 insertions(+)
 create mode 100644 _posts/2015-02-02-issue-6-is-fixed.md
```

### Push the post

```
$ git push origin gh-pages
```

> ```
Created issue "Issue 6 is fixed" for "wireddown/ghpages-ghcomments"
Counting objects: 8, done.
Delta compression using up to 2 threads.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 619 bytes | 0 bytes/s, done.
Total 4 (delta 2), reused 0 (delta 0)
To https://github.com/wireddown/ghpages-ghcomments.git
   6751063..07da9e7  gh-pages -> gh-pages
```

---

## Other advanced topics:

* Verbose Usage
* [Manual](../manual)
* [Uninstall](../uninstall)
