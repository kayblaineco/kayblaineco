library(readr)
library(dplyr)
library(glue)
library(tidyverse)

google_analytics <- '
<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-NKXSVNYYKG"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag("js", new Date());

  gtag("config", "G-NKXSVNYYKG");
</script>
'

head_template <- function(title, css_path, favicon_path) {
  
  glue('
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>{title}</title>

<link rel="stylesheet" href="https://use.typekit.net/kyg1uun.css">
<link rel="stylesheet" href="{css_path}">
<link rel="icon" type="image/png" href="{favicon_path}">

</head>
')
}

header <- '
<header class="site-header">
  <img src="../images/logo.jpg" class="logo">

  <nav class="main-nav">
    <a href="../index.html">Home</a>
    <a href="../gallery.html">Gallery</a>
    <a href="../process.html">The Process</a>
    <a href="../artist.html">The Artist</a>
    <a href="../contact.html">Contact</a>
    <a href="../instores.html">In Stores</a>
  </nav>
</header>
'

footer <- '
<footer class="site-footer">

  <div class="footer-email">
    <a href="mailto:kayblaineco@gmail.com">
      kayblaineco@gmail.com
    </a>
  </div>

  <div class="footer-links">
    <a href="../index.html">Home</a>
    <a href="../gallery.html">Gallery</a>
    <a href="../process.html">The Process</a>
    <a href="../artist.html">The Artist</a>
    <a href="../contact.html">Contact</a>
    <a href="../instores.html">In Stores</a>
  </div>

  <div class="footer-bottom">
    <div><div>© 2026, Kay Blaine Co, LLC. All rights reserved.</div> <div class="footer-location">Boston, Massachusetts</div></div>
  </div>

  <div class="footer-social">
    <a href="https://www.instagram.com/kayblaineco" target="_blank">
      <img src="https://cdn.simpleicons.org/instagram/EC5800"
           class="footer-icon">
    </a>
  </div>

</footer>
'

# ----------------------------
# LOAD DATA
# ----------------------------

data <- read_csv("gallery.csv")
names(data) <- tolower(names(data))

# Convert numeric safely
data <- data %>%
  mutate(
    cost = as.numeric(cost),
    
    profit = price - cost,
    margin = ifelse(price > 0, profit / price, 0)
  )

# ----------------------------
# BUILD GALLERY GRID PAGE
# ----------------------------

cards <- paste0(
  '<div class="gallery-item">',
  
  '<img src="images/', data$image, '" alt="', data$name, '">',
  
  '<div class="gallery-hover-card">',
  
  '<div class="gallery-name">',
  data$name,
  '</div>',
  
  '<div class="gallery-description">',
  data$description,
  '</div>',
  
  '<div class="gallery-material">',
  data$material,
  '</div>',
  
  ifelse(
    is.na(data$size) | data$size == "",
    "",
    paste0(
      '<div class="gallery-size">',
      data$size,
      '</div>'
    )
  ),
  
  '<div class="gallery-price">',
  ifelse(
    is.na(data$price),
    "",
    paste0("$", format(data$price, nsmall = 2))
  ),
  '</div>',
  
  '</div>',
  
  '</div>',
  collapse = "\n"
)

gallery_page <- glue('
<!DOCTYPE html>
<html lang="en">

{head_template(
    title = "Gallery | Kay Blaine",
    css_path = "styles.css",
    favicon_path = "favicon.png"
)}

<body>

{header}

<section class="gallery-page">

  <h1 class="page-title">Gallery</h1>

  <div class="gallery-grid">
    {cards}
  </div>

</section>

{footer}

</body>
</html>
')

writeLines(gallery_page, "gallery.html")
