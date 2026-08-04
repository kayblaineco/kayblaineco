library(readr)
library(dplyr)
library(glue)

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
    <a href="../jewelry.html">Jewelry</a>
    <a href="../process.html">The Process</a>
    <a href="../custom.html">Custom Orders</a>
    <a href="../about.html">About</a>
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
    <a href="../jewelry.html">Jewelry</a>
    <a href="../process.html">The Process</a>
    <a href="../custom.html">Custom Orders</a>
    <a href="../about.html">About</a>
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

data <- read_csv("jewelry.csv")
names(data) <- tolower(names(data))

# Convert numeric safely
data <- data %>%
  mutate(
    price = as.numeric(price),
    cost = as.numeric(cost),
    
    profit = price - cost,
    margin = ifelse(price > 0, profit / price, 0)
  )

# ----------------------------
# BUILD JEWELRY GRID PAGE
# ----------------------------

cards <- paste0(
  '<a class="card-link" href="jewelry/', data$page, '">',
  '<div class="card">',
  '<img src="images/', data$image, '">',
  '<p class="card-title">', data$name, '</p>',
  '<p class="card-price">$',
  data$price,
  '</p>',
  '</div></a>',
  collapse = "\n"
)

jewelry_page <- glue('
<!DOCTYPE html>
<html lang="en">
{head_template(
    title = "Jewelry | Kay Blaine",
    css_path = "styles.css",
    favicon_path = "favicon.png"
)}

<body>

{header}

<section class="section">
  <h1 class="page-title">Jewelry</h1>

  <div class="grid">
    {cards}
  </div>

</section>

{footer}

</body>
</html>
')

writeLines(jewelry_page, "jewelry.html")

# ----------------------------
# BUILD PRODUCT PAGES
# ----------------------------

dir.create("jewelry", showWarnings = FALSE)

for(i in 1:nrow(data)) {
  
  page_content <- glue('
<!DOCTYPE html>
<html lang="en">
{head_template(
    title = paste0(data$name[i], " | Kay Blaine"),
    css_path = "../styles.css",
    favicon_path = "../favicon.png"
)}

<body>

{header}

<section class="section product-page">

  <div class="product-grid">

    <div>
      <img src="../images/{data$image[i]}" style="width:100%;">
    </div>

    <div>
      <h1 class="page-title">{data$name[i]}</h1>
      <p class="price">${data$price[i]}</p>
      <p>{data$description[i]}</p>
    </div>

  </div>

</section>

{footer}

</body>
</html>
')
  
  writeLines(page_content, paste0("jewelry/", data$page[i]))
}
