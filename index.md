---
layout: default
title: Home
---

With [**ghpages-ghcomments**](https://github.com/wireddown/ghpages-ghcomments/tree/release), your Jekyll site can use GitHub to provide reader comments. 

Set up is quick, and everything has been automated to hook into your git workflow.

[Read more]({{ site.baseurl }}/about)

# Example Posts and Comments

<div>
  <ul class="related-posts">
    {% capture example_offset %}{{ site.posts | size | minus: 5 }}{% endcapture %}
    {% for post in site.posts limit:5 offset:example_offset %}
      {% assign post_date = post.date | date_to_string %}
      <li>
        <h3>
          <small>{{ post_date }}</small><br>
          <a href="{{ site.baseurl }}{{ post.url }}">{{ post.title }}</a>
        </h3>
      </li>
    {% endfor %}
  </ul>
</div>
