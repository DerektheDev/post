$(function(){
  $('#compiled_source_preview').html("<%= escape_javascript(raw @shl_rendered_html) %>");
  $('#compiled_browser_preview').html("<%= escape_javascript(raw @rendered_html) %>");
})