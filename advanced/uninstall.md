---
layout: page
title: Uninstall
---

For each repository with ghpages-ghcomments:

 1. Remove the hooks from:
  * **.git/hooks/pre-commit**
  * **.git/hooks/pre-push**
 1. Remove the ghpages-ghcomments files:
  * **_data/gpgc.yml**
  * **\_includes/gpgc_comments.html**
  * **public/css/ghpages-ghcomments.css**
 1. Remove the lines you added from:
  * **_includes/head.html**
  * **_layouts/post.html**
