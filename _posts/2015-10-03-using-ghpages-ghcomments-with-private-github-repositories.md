---
layout: post
title: Using ghpages-ghcomments with Private GitHub Repositories
---

If you use a private repository for your site, then only you and the GitHub users authorized by you can contribute to that repository. Since ghpages-ghcomments uses GitHub Issues to store comments, your readers will not be able to comment unless you've granted them permission. Authorizing *every* reader doesn't scale and circumvents many of the benefits of using a private repository.

Luckily, ghpages-ghcomments doesn't need to use the *same* repository as your site to provide comments. By creating a public repository for just comments, you can continue to use your private repository for your site:

1. Create a public repository
1. Update `_data/gpgc.yml` to use it:

```
repo_owner: __YOUR_GITHUB_USERNAME__
repo_name: __YOUR_PUBLIC_REPOSITORY__
```
