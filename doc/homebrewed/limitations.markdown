Nokogiri document parsing
------
- No nesting tags that aren't intended to be nested. They won't be parsed properly. (e.g. spans within spans, or other typically inline text elements within one another)
- Non-HTML spec tags will nest and parse properly, but don't do it, because email clients properly won't render it properly.
- Multiple IDs on one element are not allowed. HTML rendering engines treat this markup differently.


HAML
------
- http://nex-3.com/posts/74-haml-errors-suck#comments

File naming conventions
-----------------------
- california.html will automatically look for california.css
- if multiple stylesheets are needed, use california2.css, california3.css, etc.
- for styles that apply to a whole campaign, title it global.css
- for resets, use reset.css. These will go in the body, but will always load first, before global.css
- for head styles (for example, media queries), title it california_head.css or global_head.css


ORDER OF COMPILATION/SPECIFICITY
  BODY:
    reset.css
    reset_1.css
    global.css
    global_1.css
    california.css
    california_1.css
  HEAD:
    global_head.css
    california_head.css
    california_head_1.css