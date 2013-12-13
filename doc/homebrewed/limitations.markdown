Nokogiri document parsing
------
- No nesting tags that aren't intended to be nested. They won't be parsed properly. (e.g. spans within spans, or other typically inline text elements within one another)
- Non-HTML spec tags will nest and parse properly, but don't do it, because email clients properly won't render it properly.
- Multiple IDs on one element are not allowed. HTML rendering engines treat this markup differently.
