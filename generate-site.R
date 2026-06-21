library(readr)
library(dplyr)
library(glue)

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
    © 2026, Kay Blaine Co, LLC. All rights reserved.
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
  '<p class="title">', data$name, '</p>',
  '<p class="price">$',
  data$price,
  '</p>',
  '</div></a>',
  collapse = "\n"
)

jewelry_page <- glue('
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Jewelry</title>
<link rel="stylesheet" href="styles.css">
</head>

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
<head>
<meta charset="UTF-8">
<title>{data$name[i]}</title>
<link rel="stylesheet" href="../styles.css">
</head>

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