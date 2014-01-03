$(function(){
  $('#compiled-source-preview').html("<%= escape_javascript(raw @shl_rendered_html) %>");
  $('#compiled-browser-preview').html("<%= escape_javascript(raw @rendered_html_app_imgs) %>");
})