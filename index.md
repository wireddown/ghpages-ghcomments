---
layout: default
title: Home
---

With [**ghpages-ghcomments**](https://github.com/wireddown/ghpages-ghcomments/tree/release), your Jekyll site can use GitHub to provide reader comments. 

Set up is quick, and everything has been automated to hook into your git workflow.

[Read more]({{ site.baseurl }}about)

# Example Posts and Comments

<div>
  <ul class="related-posts">
    {% for post in site.posts %}
      {% assign post_date = post.date | date_to_string %}
      <li>
        <h3>
          <small>{{ post_date }}</small><br>
          <a href="{{ post.url }}">{{ post.title }}</a>
        </h3>
      </li>
    {% endfor %}
  </ul>
</div>
