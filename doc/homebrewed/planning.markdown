# Project intent
This application will allow users to write web-standards HTML and CSS,
and have it automatically compiled into inline-styles as needed by
email clients.


# Models - Database objects
Campaign: One marketing intent--a developed, budgeted project--containing multiple markups (each designated by a separate markup document). Will contain multiple markup/style docs, and images, each of which may be viewed independently, but are mentally grouped together. UI-wise, we will upload all files together, title each, then click a preview image to view it in the browser. They will all be exported together in a zip pre-flighted for Email on Acid.
          - Markup
Campaign< - Stylesheet
          - Image
          - Link?

# Controllers - Actions/Processing

# Views