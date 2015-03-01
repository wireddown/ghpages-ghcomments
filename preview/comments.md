---
layout: default
title: Comments Preview
date: 2015-03-01 12:00:00
---

<div class="post">
  <h1 class="post-title">{{ page.title }}</h1>
  <span class="post-date">{{ page.date | date_to_string }}</span>

  <p>This is a preview page for <a href="https://github.com/wireddown/ghpages-ghcomments/issues/11">Issue 11</a>: <em>Comment on blog page</em></p>

</div>

<div class="pagination">
  {% if page.previous %}
    <a class="pagination-item older" href="{{ site.baseurl }}{{ page.previous.url }}">Older</a>
  {% else %}
    <span class="pagination-item older">Older</span>
  {% endif %}
  {% if page.next %}
    <a class="pagination-item newer" href="{{ site.baseurl }}{{ page.next.url }}">Newer</a>
  {% else %}
    <span class="pagination-item newer">Newer</span>
  {% endif %}
</div>

<div class="gpgc-new-section gpgc-comments-font gpgc-hidden" id="gpgc_all_comments">
</div>

<div class="gpgc-new-section gpgc-comments-font gpgc-hidden" id="gpgc_no_comments">
  <p class="gpgc-no-comments">No comments</p>
</div>

<div class="gpgc-actions gpgc-hidden" id="gpgc_actions">
  <span class="gpgc-action">
    <button class="gpgc-show" id="show_comments_button" onclick="showAllComments(CommentsArray)"></button>
  </span>
</div>

<div class="gpgc-comment gpgc-comments-font" id="gpgc_new_comment">
  <div>
    <div class="gpgc-comment-header">
      <a id="gpgc_reader_url" href="#"><img class="gpgc-avatar" id="gpgc_reader_avatar" src="{{ site.baseurl }}/public/apple-touch-icon-precomposed.png" height="42" /><span id="gpgc_reader_login">You</span></a>
      <small>today</small>
      <div class="gpgc-tabs">
        <button class="gpgc-tab" id="write_button">Write</button>
        <button class="gpgc-tab" id="preview_button">Preview</button>
      </div>
    </div>
    <div class="gpgc-new-comment" id="write_div">
      <div class="gpgc-comment-form">
        <textarea class="gpgc-comment-form-textarea" id="new_comment_field" placeholder="Write a comment"></textarea>
      </div>
    </div>
    <div class="gpgc-new-comment gpgc-comment-contents gpgc-hidden" id="preview_div">
    </div>
    <div class="gpgc-comment-help">
      <div class="gpgc-hidden" id="help_message">
      </div>
      <div class="gpgc-token-actions gpgc-hidden" id="token_actions">
        <span>Comment token:</span>
        <input class="gpgc-oauth-token gpgc-hidden" id="oauth_token_input" type="text" name="oauth_token" oninput="authenticateUser()" onchange="authenticateUser()"></input>
        <span class="gpgc-hidden" id="oauth_token_validated"><strong>&#x2713;</strong></span>
        <button class="gpgc-hidden gpgc-clear-token" id="oauth_clear_token" onclick="clearToken()">Reset</button>
      </div>
    </div>
    <div class="gpgc-new-comment-bottom-actions">
      <button class="gpgc-submit" id="submit_button" onclick="postComment()"><strong>Submit</strong></button>
    </div>
  </div>
</div>

<div class="gpgc-new-section gpgc-comments-font gpgc-help-error gpgc-hidden" id="gpgc_reader_error">
</div>

<div class="gpgc_last_div">
</div>

<script>
  var ShortMonthForIndex = { 0: "Jan", 1: "Feb", 2: "Mar", 3: "Apr", 4: "May", 5: "Jun", 6: "Jul", 7: "Aug", 8: "Sep", 9: "Oct", 10: "Nov", 11: "Dec" };
  var AccessToken = "";
  var IssueUrl = "";
  var CommentsUrl = "";
  var CommentsArray = [];

  var AllCommentsDiv = document.getElementById("gpgc_all_comments");
  var NoCommentsDiv = document.getElementById("gpgc_no_comments");
  var ActionsDiv = document.getElementById("gpgc_actions");
  var ShowCommentsButton = document.getElementById("show_comments_button");

  var NewCommentDiv = document.getElementById("gpgc_new_comment");
  var WriteButton = document.getElementById("write_button");
  var WriteDiv = document.getElementById("write_div");
  var CommentMarkdown = document.getElementById("new_comment_field");
  var PreviewButton = document.getElementById("preview_button");
  var PreviewDiv = document.getElementById("preview_div");

  var TokenActions = document.getElementById("token_actions");
  var OAuthTokenInput = document.getElementById("oauth_token_input");
  var ReaderGitHubUrl = document.getElementById("gpgc_reader_url");
  var ReaderAvatarUrl = document.getElementById("gpgc_reader_avatar");
  var ReaderLogin = document.getElementById("gpgc_reader_login");
  var TokenValidatedMark = document.getElementById("oauth_token_validated");
  var ClearTokenButton = document.getElementById("oauth_clear_token");
  var SubmitButton = document.getElementById("submit_button");

  var HelpMessageDiv = document.getElementById("help_message");
  var ErrorDiv = document.getElementById("gpgc_reader_error");

  function initializeData() {
    retrieveToken();
    OAuthTokenInput.value = AccessToken;
  }

  function retrieveToken() {
    AccessToken = localStorage.getItem("AccessToken");
  }

  function persistToken() {
    localStorage.setItem("AccessToken", AccessToken);
  }

  function clearToken() {
    OAuthTokenInput.value = "";
    authenticateUser();
    persistToken();
  }

  function showCommentHelpMessage(message) {
    showCommentHelp(message, /* isRawHtml: */ false, "gpgc-help-message", "gpgc-help-error");
  }

  function showCommentHelpError(error, isRawHtml) {
    showCommentHelp(error, isRawHtml, "gpgc-help-error", "gpgc-help-message");
  }

  function showCommentHelp(message, isRawHtml, cssClassToAdd, cssClassToRemove) {
    if (isRawHtml) {
      HelpMessageDiv.innerHTML = message;
    } else {
      HelpMessageDiv.innerHTML = "<p>" + message + "</p>";
    }
    HelpMessageDiv.classList.add(cssClassToAdd);
    HelpMessageDiv.classList.remove(cssClassToRemove);
    showElement(HelpMessageDiv);
  }

  function clearCommentHelp() {
    HelpMessageDiv.innerHTML = "";
    HelpMessageDiv.classList.remove("gpgc-help-message");
    HelpMessageDiv.classList.remove("gpgc-help-error");
    hideElement(HelpMessageDiv);
  }

  function showFatalError(internalMessage) {
    {% if site.data.gpgc.enable_diagnostics %}
      var nextStepMessage = "<p>If you're the site owner, please contact <strong><a href='https://github.com/wireddown/ghpages-ghcomments/issues'>ghpages-ghcomments</a></strong> for help.</p><p><strong>Internal message</strong></p><pre>" + internalMessage + "</pre>";
    {% else %}
      var nextStepMessage = "<p>If you're the site owner, please set <code>enable_diagnostics</code> to <code>true</code> in <code>_data/gpgc.yml</code> to see more details.</p>";
    {% endif %}
    ErrorDiv.innerHTML += "<h2>Oops!</h2><p>Something surprising happened.</p>" + nextStepMessage;
    showElement(ErrorDiv);
  }

  function updateCommenterInformation(userJson) {
    ReaderGitHubUrl.href = userJson.html_url;
    ReaderAvatarUrl.src = userJson.avatar_url;
    ReaderLogin.innerHTML = userJson.login;
  }

  function onUserAuthenticated(checkAuthenticationRequest) {
    {% if site.data.gpgc.enable_diagnostics %}
      var elementsToShow = [ TokenValidatedMark, ClearTokenButton ];
      var elementsToHide = [ OAuthTokenInput ];
    {% else %}
      var elementsToShow = [  ];
      var elementsToHide = [ TokenActions ];
    {% endif %}
    var elementsToEnable = [ ClearTokenButton, SubmitButton ];
    var elementsToDisable = [  ];
    persistToken();
    updateCommenterInformation(JSON.parse(checkAuthenticationRequest.responseText));
    clearCommentHelp();
    updateElements(elementsToShow, elementsToHide, elementsToEnable, elementsToDisable);
  }

  function onUserAuthenticationError(checkAuthenticationRequest) {
    AccessToken = "";
    var helpErrorMessage = "Sorry, it looks like the token isn't valid. Please try again.";
    var isRawHtml = false;
{% if site.data.gpgc.enable_diagnostics %}
    helpErrorMessage = "<h3><strong>gpgc</strong> Error: Authentication Failed</h3><p>Could not authenticate OAuth token</p><p>GitHub response:</p><p><pre>" + checkAuthenticationRequest.responseText + "</pre></p>";
    isRawHtml = true;
{% endif %}
    showCommentHelpError(helpErrorMessage, isRawHtml);
    onAuthenticateUserFailed();
    return;
  }

  function onAuthenticateUserFailed() {
    var elementsToShow = [ OAuthTokenInput, TokenActions ];
    var elementsToHide = [ TokenValidatedMark, ClearTokenButton ];
    var elementsToEnable = [  ];
    var elementsToDisable = [ ClearTokenButton, SubmitButton ];
    updateElements(elementsToShow, elementsToHide, elementsToEnable, elementsToDisable);
  }

  function authenticateUser() {
    AccessToken = OAuthTokenInput.value;
    if (AccessToken.length == 40) {
      var userIdUrl = "https://api.github.com/user";
      getGitHubApiRequestWithCompletion(userIdUrl, AccessToken, onUserAuthenticated, onUserAuthenticationError);
    } else {
      onAuthenticateUserFailed();
      updateCommenterInformation({ login: "You", html_url: "#", avatar_url: "{{ site.baseurl }}/public/apple-touch-icon-precomposed.png" });
      showCommentHelpMessage("To leave a comment, please provide a <a href='https://help.github.com/articles/creating-an-access-token-for-command-line-use/#creating-a-token'>GitHub OAuth token</a>.");
    }
  }

  function onCommentPosted(postCommentRequest) {
    var commentInformation = JSON.parse(postCommentRequest.responseText);
    var newComment = formatComment(commentInformation.user.avatar_url, commentInformation.user.html_url, commentInformation.user.login, commentInformation.body_html, commentInformation.updated_at);
    AllCommentsDiv.innerHTML += newComment;
    showAllComments();
    updateCommentFormMode("write", /* reset: */ true);
    clearCommentHelp();
  }

  function onPostCommentError(postCommentRequest) {
    var helpErrorMessage = "Sorry, something surprising happened. Please try again.";
    var isRawHtml = false;
{% if site.data.gpgc.enable_diagnostics %}
    helpErrorMessage = "<h3><strong>gpgc</strong> Error: Comment Failed</h3><p>Could not create a new comment</p><p>GitHub response:</p><p><pre>" + postCommentRequest.responseText + "</pre></p>";
    isRawHtml = true;
{% endif %}
    showCommentHelpError(helpErrorMessage, isRawHtml);
  }

  function postComment() {
    if (CommentMarkdown.value.length == 0) {
      showCommentHelpError("Sorry, but your comment is empty. Please try again.");
      return;
    } else {
      clearCommentHelp();
    }

    var createCommentJson = { body: CommentMarkdown.value };
    postGitHubApiRequestWithCompletion(CommentsUrl, JSON.stringify(createCommentJson), AccessToken, onCommentPosted, onPostCommentError);
  }

  function onMarkdownRendered(renderRequest) {
    var renderedHtml = renderRequest.responseText;
    PreviewDiv.innerHTML = renderedHtml;
  }

  function onMarkdownRenderError(renderRequest) {
    var helpErrorMessage = "Sorry, something surprising happened. Please try again.";
    var isRawHtml = false;
{% if site.data.gpgc.enable_diagnostics %}
    helpErrorMessage = "<h3><strong>gpgc</strong> Error: Render Failed</h3><p>Could not render comment markdown</p><p>GitHub response:</p><p><pre>" + renderRequest.responseText + "</pre></p>";
    isRawHtml = true;
{% endif %}
    showCommentHelpError(helpErrorMessage, isRawHtml);
    return;
  }

  function renderMarkdown(markdown) {
    renderUrl = "https://api.github.com/markdown";
    markdownBundle = {text: markdown, mode: "gfm", context: "{{ site.data.gpgc.repo_owner }}/{{ site.data.gpgc.repo_name }}"};
    postGitHubApiRequestWithCompletion(renderUrl, JSON.stringify(markdownBundle), AccessToken, onMarkdownRendered, onMarkdownRenderError);
  }

  function updateCommentFormMode(newMode, reset) {
    var elementsToShow = [];
    var elementsToHide = [];

    if (newMode === "preview") {
      WriteButton.onclick = function() { updateCommentFormMode("write", /* reset: */ false) };
      WriteButton.className = "gpgc-tab";
      PreviewButton.onclick = null;
      PreviewButton.classList.add("preview");
      elementsToHide.push(WriteDiv);
      elementsToShow.push(PreviewDiv);
      PreviewDiv.innerHTML = "";
      renderMarkdown(CommentMarkdown.value);
    } else if (newMode === "write") {
      WriteButton.onclick = null;
      WriteButton.classList.add("write");
      PreviewButton.onclick = function() { updateCommentFormMode("preview", /* reset: */ false) };
      PreviewButton.className = "gpgc-tab";
      elementsToShow.push(WriteDiv);
      elementsToHide.push(PreviewDiv);
    }

    updateElements(elementsToShow, elementsToHide, /* elementsToEnable: */ null, /* elementsToDisable: */ null);

    if (reset) {
      CommentMarkdown.value = "";
      PreviewDiv.innerHTML = "";
    }
  }

  function initializeNewCommentForm() {
    authenticateUser();
    updateCommentFormMode("write", /* reset: */ false);
  }

  function findAndCollectComments(userName, repositoryName, issueTitle) {
    var safeQuery = encodeURI(issueTitle);
    var seachQueryUrl = "https://api.github.com/search/issues?q=" + safeQuery + "+repo:" + userName + "/" + repositoryName + "+type:issue+in:title";
    getGitHubApiRequestWithCompletion(seachQueryUrl, AccessToken, onSearchComplete, onSearchError);
  }

  function onSearchComplete(searchRequest) {
    var searchResults = JSON.parse(searchRequest.responseText);
    if (searchResults.total_count === 1) {
      IssueUrl = searchResults.items[0].html_url;
      CommentsUrl = searchResults.items[0].comments_url
      getGitHubApiRequestWithCompletion(CommentsUrl, AccessToken, onQueryComments, onQueryCommentsError);
    }
    else {
      onSearchError(searchRequest);
    }
  }

  function onSearchError(searchRequest) {
{% if site.data.gpgc.enable_diagnostics %}
    var searchErrorMessage = ""
    if (searchRequest.status != 200) {
      searchErrorMessage = "<h3><strong>gpgc</strong> Error: Search Failed</h3><p>Could not search GitHub repository <strong><a href='https://www.github.com/{{ site.data.gpgc.repo_owner }}/{{ site.data.gpgc.repo_name }}'>{{ site.data.gpgc.repo_owner }}/{{ site.data.gpgc.repo_name }}</a></strong>.</p><p>GitHub response:</p><p><pre>" + searchRequest.responseText + "</pre></p><p>Check:<ul><li><code>repo_owner</code> in <code>_data/gpgc.yml</code> for typos.</li><li><code>repo_name</code> in <code>_data/gpgc.yml</code> for typos.</li></ul></p>";
    }

    var missingIssueMessage = "";
    var searchResults = JSON.parse(searchRequest.responseText);
    if (searchResults.total_count !== undefined && searchResults.total_count === 0) {
      missingIssueMessage = "<h3><strong>gpgc</strong> Error: Missing Issue</h3><p>Could not find comment issue with the title <em>{{ include.post_title }}</em> in the repository <strong><a href='https://www.github.com/{{ site.data.gpgc.repo_owner }}/{{ site.data.gpgc.repo_name }}'>{{ site.data.gpgc.repo_owner }}/{{ site.data.gpgc.repo_name }}</a></strong>.</p><p>Check:<ul><li>for typos in the Jekyll <code>title</code> front matter for this post: <code>{{ page.path }}</code>.</li><li>that the <code>repo_name</code> in <code>_data/gpgc.yml</code> matches the repository for this site.</li><li>the terminal output from <code>git push</code> for other error messages if the git hooks are installed.</li></ul></p>";
    }

    var allMessagesHtml = searchErrorMessage + missingIssueMessage;
    if (allMessagesHtml.length > 0) {
      allMessagesHtml += "<h3>Search Help</h3><p>Verify your site's configuration with the <a href='downtothewire.io/ghpages-ghcomments/setup/'>setup instructions</a> and refer to the <a href='http://downtothewire.io/ghpages-ghcomments/advanced/verbose-usage/'>verbose usage</a> for step-by-step details.</p><p>Contact <strong><a href='https://github.com/wireddown/ghpages-ghcomments/issues'>ghpages-ghcomments</a></strong> for more help.</p>";

      ErrorDiv.innerHTML += allMessagesHtml;
      showElement(ErrorDiv);
    }
{% else %}
    if (searchRequest.status == 401) {
      AccessToken = "";
      findAndCollectComments("{{ site.data.gpgc.repo_owner }}", "{{ site.data.gpgc.repo_name }}", "{{ include.post_title }}");
    }
    else {
      showFatalError("onSearchError: \n\n" + searchRequest.responseText);
    }
{% endif %}
    return;
  }

  function onQueryComments(commentRequest) {
    CommentsArray = CommentsArray.concat(JSON.parse(commentRequest.responseText));
    var commentsPages = commentRequest.getResponseHeader("Link");
    if (commentsPages) {
      var commentsLinks = commentsPages.split(",");
      for (var i = 0; i < commentsLinks.length; i++) {
        if (commentsLinks[i].search('rel="next"') > 0) {
          var linkStart = commentsLinks[i].search("<");
          var linkStop = commentsLinks[i].search(">");
          var nextLink = commentsLinks[i].substring(linkStart + 1, linkStop);
          getGitHubApiRequestWithCompletion(nextLink, /* accessToken: */ null, onQueryComments, onQueryCommentsError);
          return;
        }
      }
      updateCommentsAndActions(CommentsArray);
    }
    else {
      updateCommentsAndActions(CommentsArray);
    }
  }

  function onQueryCommentsError(commentRequest) {
    showFatalError("onQueryCommentsError: \n\n" + commentRequest.responseText);
  }

  function updateCommentsAndActions(allComments) {
    var elementsToShow = [];
    var elementsToHide = [];

    if (allComments.length === 0) {
      elementsToShow.push(NoCommentsDiv);
    } else {
      var allCommentsHtml = formatAllComments(CommentsArray);
      AllCommentsDiv.innerHTML = allCommentsHtml + AllCommentsDiv.innerHTML;

      var commentOrComments = allComments.length == 1 ? "Comment" : "Comments";
      ShowCommentsButton.innerHTML = "Show " + allComments.length + " " + commentOrComments;

      if (typeof {{ site.data.gpgc.use_show_action }} === "boolean" && {{ site.data.gpgc.use_show_action }}) {
        elementsToShow.push(ActionsDiv);
        elementsToHide.push(AllCommentsDiv);
      }
      else {
        elementsToHide.push(ActionsDiv);
        elementsToShow.push(AllCommentsDiv);
      }
    }

    updateElements(elementsToShow, elementsToHide, /* elementsToEnable: */ null, /* elementsToDisable: */ null);
  }

  function showAllComments(allComments) {
    var elementsToShow = [ AllCommentsDiv ];
    var elementsToHide = [ ActionsDiv, NoCommentsDiv ];
    updateElements(elementsToShow, elementsToHide, /* elementsToEnable: */ null, /* elementsToDisable: */ null);
  }

  function formatAllComments(allComments) {
    var allCommentsHtml = "";
    for (var i = 0; i < allComments.length; i++) {
      var user = allComments[i].user;
      allCommentsHtml += formatComment(user.avatar_url, user.html_url, user.login, allComments[i].body_html, allComments[i].updated_at);
    }

    return allCommentsHtml;
  }

  function formatComment(userAvatarUrl, userHtmlUrl, userLogin, commentBodyHtml, commentTimeStamp) {
    var commentDate = new Date(commentTimeStamp);
    var shortMonth = ShortMonthForIndex[commentDate.getMonth()];
    var commentHtml = "<div class='gpgc-comment'>";
    commentHtml += "<div class='gpgc-comment-header'>";
    commentHtml += "<a href='" + userHtmlUrl + "'><img class='gpgc-avatar' src='" + userAvatarUrl + "' height='42' />" + userLogin + "</a> ";
    commentHtml += "<small>on " + commentDate.getDate() + " " + shortMonth + " " + commentDate.getFullYear() + "</small>";
    commentHtml += "</div>";
    commentHtml += "<div class='gpgc-comment-contents'>" + commentBodyHtml + "</div>";
    commentHtml += "</div>";
    return commentHtml;
  }

  function getGitHubApiRequestWithCompletion(url, accessToken, onSuccess, onError) {
    doGitHubApiRequestWithCompletion("GET", url, null, accessToken, onSuccess, onError);
  }

  function postGitHubApiRequestWithCompletion(url, data, accessToken, onSuccess, onError) {
    doGitHubApiRequestWithCompletion("POST", url, data, accessToken, onSuccess, onError);
  }

  function doGitHubApiRequestWithCompletion(method, url, data, accessToken, onSuccess, onError) {
    var gitHubRequest = new XMLHttpRequest();
    gitHubRequest.open(method, url, /* async: */ true);

    if (accessToken != null && accessToken != "") {
      gitHubRequest.setRequestHeader("Authorization", "token " + accessToken);
    }

    gitHubRequest.setRequestHeader("Accept", "application/vnd.github.v3.html+json");
    gitHubRequest.onreadystatechange = function() { onRequestReadyStateChange(gitHubRequest, onSuccess, onError) };

    gitHubRequest.send(data);
  }

  function onRequestReadyStateChange(httpRequest, onSuccess, onError) {
    if (httpRequest.readyState != 4) { return; }
    if (httpRequest.status == 200 || httpRequest.status == 201) {
      onSuccess(httpRequest);
    } else {
      onError(httpRequest);
    }
  }

  function updateElements(elementsToShow, elementsToHide, elementsToEnable, elementsToDisable) {
    if (elementsToShow != null) showElements(elementsToShow);
    if (elementsToHide != null) hideElements(elementsToHide);
    if (elementsToEnable != null) enableElements(elementsToEnable);
    if (elementsToDisable != null) disableElements(elementsToDisable);
  }

  function updateElementVisibility(element, makeVisible) {
    if (makeVisible) {
      element.classList.remove("gpgc-hidden");
    } else {
      element.classList.add("gpgc-hidden");
    }
  }

  function showElement(element) {
    updateElementVisibility(element, /* makeVisible: */ true);
  }

  function showElements(elementList) {
    for (var i = 0; i < elementList.length; i++) {
      showElement(elementList[i]);
    }
  }

  function hideElement(element) {
    updateElementVisibility(element, /* makeVisible: */ false);
  }

  function hideElements(elementList) {
    for (var i = 0; i < elementList.length; i++) {
      hideElement(elementList[i]);
    }
  }

  function updateElementInteractivity(element, makeInteractive) {
    if (makeInteractive) {
      element.disabled = false;
    } else {
      element.disabled = true;
    }
  }

  function enableElement(elementToEnable) {
    updateElementInteractivity(elementToEnable, /* makeInteractive: */ true);
  }

  function enableElements(elementList) {
    for (var i = 0; i < elementList.length; i++) {
      enableElement(elementList[i]);
    }
  }

  function disableElement(elementToDisable) {
    updateElementInteractivity(elementToDisable, /* makeInteractive: */ false);
  }

  function disableElements(elementList) {
    for (var i = 0; i < elementList.length; i++) {
      disableElement(elementList[i]);
    }
  }

{% if site.data.gpgc.enable_diagnostics %}
  function verifyCss() {
    var css = document.styleSheets;
    var foundCssInHead = false;
    var fetchedCss = false;
    for (var i = 0; i < css.length; i++) {
      if (css[i].href.match("ghpages-ghcomments.css")) {
        foundCssInHead = true;
        if (css[i].cssRules.length > 0) {
          fetchedCss = true;
        }
        break;
      }
    }

    var missingCssMessage = "";
    if (! foundCssInHead) {
      missingCssMessage = "<h3><strong>gpgc</strong> Error: Missing CSS</h3><p><code>ghpages-ghcomments.css</code> is not in the &lt;head&gt; element.</p><p>Add a <code>&lt;link&gt;</code> element to <code>_includes/head.hml</code>.</p>";
    }

    var css404Message = "";
    if (! fetchedCss && foundCssInHead) {
      css404Message = "<h3><strong>gpgc</strong> Error: CSS 404</h3><p>Could not retrieve <code>ghpages-ghcomments.css</code> from your site.</p><p>Check <code>_includes/head.hml</code> for typos.</p>";
    }

    var allMessagesHtml = missingCssMessage + css404Message;
    if (allMessagesHtml.length > 0) {
      allMessagesHtml += "<h3>CSS Help</h3><p>Verify your site's configuration with the <a href='downtothewire.io/ghpages-ghcomments/setup/'>setup instructions</a> and refer to the <a href='http://downtothewire.io/ghpages-ghcomments/advanced/verbose-usage/'>verbose usage</a> for step-by-step details.</p><p>Contact <strong><a href='https://github.com/wireddown/ghpages-ghcomments/issues'>ghpages-ghcomments</a></strong> for more help.</p>";

      ErrorDiv.innerHTML += allMessagesHtml;
      showElement(ErrorDiv);
    }
  }

  verifyCss();
{% endif %}

  initializeData();
  initializeNewCommentForm();
  findAndCollectComments("{{ site.data.gpgc.repo_owner }}", "{{ site.data.gpgc.repo_name }}", "{{ page.title }}");
</script>

<style media="screen" type="text/css">

.gpgc-hidden {
  display: none !important;
}

.gpgc-actions  {
  overflow: hidden; /* clearfix */
  margin-left: -1rem;
  margin-right: -1rem;
}

.gpgc-action {
  display: block;
  padding: 1rem;
  text-align: center;
}

.gpgc-show {
  display: inline-block;
  padding-top: 1rem;
  padding-bottom: 1rem;
  width: 14rem;
  font-family: "PT Sans", Helvetica, Arial, sans-serif;
  font-size: 1rem;
  border: solid 1px #90a959; /* THEME: use `a` color */
  color: #90a959; /* THEME: use `a` color */
  background-color: #fff;
  cursor: pointer;
}

.gpgc-show:hover {
  background-color: #f5f5f5;
}

.gpgc-comments-font {
  font-size: .8rem;
}

@media (min-width: 410px) {
  .gpgc-submit {
    float: right;
    display: inline;
  }

  .gpgc-oauth-token {
    width: 24em;
  }

  .gpgc-tabs {
    float: right;
    padding-left: 0px;
  }
  
  .gpgc-token-actions {
    width: 320px !important;
  }

  .gpgc-new-comment-bottom-actions {
    padding: .4rem .4rem 3.2rem !important;
  }
}

.gpgc-token-actions {
  margin-bottom: .8rem;
  display: inline-block;
  width: 100%;
}

.gpgc-comment-header {
  padding-top: .4rem;
  padding-right: .4rem;
  padding-left: .4rem;
  margin-bottom: .2rem;
}

.gpgc-comment-form {
  padding-left: .4rem;
  padding-right: .4rem;
}

.gpgc-comment-form-textarea {
  font-family: inherit;
  display: block;
  width: 100%;
  min-height: 8rem;
  margin-left: auto;
  margin-right: auto;
  padding: .4rem;
  resize: vertical;
  border: solid 1px #90a959; /* THEME: use `a` color */
}

.gpgc-tabs {
  margin-top: .4rem;
  padding-left: 5px;
}

.gpgc-tab {
  padding-left: 1.4rem;
  padding-right: 1.4rem;
  padding-top: .4rem;
  padding-bottom: .4rem;
  margin-left: -5px;
  border: solid 1px #90a959; /* THEME: use `a` color */
  background-color: #90a959; /* THEME: use `a` color */
  color: #FFFFFF;
  cursor: pointer;
}

.gpgc-tab.write {
  border: solid 1px;
  border-color: #90a959; /* THEME: use `a` color */
  background-color: #FFFFFF;
  color: inherit;
  cursor: auto;
}

.gpgc-tab.preview {
  border: solid 1px #90a959;
  background-color: #FFFFFF;
  color: inherit;
  cursor: auto;
}

.gpgc-new-comment {
  min-height: 4rem;
}

.gpgc-new-comment-bottom-actions {
  padding: 0.4rem 0.4rem 1rem;
}

.gpgc-oauth-token {
  width: 100%;
  border: 1px solid #90A959;
  padding: .4rem;
}

.gpgc-submit {
  padding-left: 1.4rem;
  padding-right: 1.4rem;
  padding-top: .4rem;
  padding-bottom: .4rem;
  border: solid 1px #90a959; /* THEME: use `a` color */
  background-color: #90a959; /* THEME: use `a` color */
  cursor: pointer;
}

button:disabled {
  border: solid 1px #888888;
  background-color: #aaaaaa;
  cursor: auto;
}

.gpgc-submit strong {
 color: #FFFFFF;
 }

.gpgc-clear-token {
  padding-left: 1.4rem;
  padding-right: 1.4rem;
  padding-top: .4rem;
  padding-bottom: .4rem;
  border: solid 1px #90a959;
  background-color: #FFFFFF;
  color: inherit;
  cursor: pointer;
  color: #90a959; /* THEME: use `a` color */
}

.gpgc-clear-token:hover {
  background-color: #f5f5f5;
}

.gpgc-comment-help {
  padding: .4rem;
}

.gpgc-help-message {
}

.gpgc-help-error {
  padding: .4rem;
  margin: .4rem;
  border: solid 2px #ab4642;
  background-color: #ffeded;
}

.gpgc-no-comments {
  text-align: center;
}

.gpgc-new-section {
  margin-top: 3rem;
}

.gpgc-comment {
  margin-top: .8rem;
  background-color: #eee;
  border: solid 1px #eee;
          border-radius: 0px 0px 24px 24px;
     -moz-border-radius: 0px 0px 24px 24px;
  -webkit-border-radius: 0px 0px 24px 24px;
}

.gpgc-avatar {
  display: inline;
  margin-bottom: 0px;
  margin-right: .4rem;
  vertical-align: baseline;
}

.gpgc-comment-contents {
  padding: .4rem .4rem 0 .4rem;
}

.gpgc_last_div {
  padding-top: 12rem;
}

</style>
