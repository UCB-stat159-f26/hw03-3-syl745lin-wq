player_id <- function(player) {
  if (!is.character(player) || length(player) != 1L || is.na(player)) {
    stop("Supply one player name, such as 'Serena Williams'.", call. = FALSE)
  }
  words <- gsub("([a-z])([A-Z])", "\\1 \\2", trimws(player))
  words <- gsub("[^A-Za-z]+", " ", iconv(words, to = "ASCII//TRANSLIT", sub = ""))
  words <- strsplit(trimws(tolower(words)), " +")[[1L]]
  if (!length(words)) {
    stop("Supply a nonempty player name.", call. = FALSE)
  }
  paste0(toupper(substr(words, 1L, 1L)), substring(words, 2L), collapse = "")
}

read_tennis_abstract <- function(address) {
  con <- url(address, method = "libcurl", headers = c("User-Agent" = "Mozilla/5.0"))
  on.exit(close(con), add = TRUE)
  tryCatch(
    suppressWarnings(readLines(con, encoding = "UTF-8", warn = FALSE)),
    error = function(e) character()
  )
}

extract_player_birth <- function(html) {
  pattern <- "\\bvar\\s+dob\\s*=\\s*([0-9]{8})\\s*;"
  text <- paste(html, collapse = "\n")
  parts <- regmatches(text, regexec(pattern, text, perl = TRUE))[[1L]]
  as.Date(parts[2L], format = "%Y%m%d")
}

get_player_birth <- function(id) {
  base <- "https://www.tennisabstract.com/cgi-bin/"
  for (page in c("wplayer.cgi?p=", "player.cgi?p=")) {
    birth <- extract_player_birth(read_tennis_abstract(paste0(base, page, id)))
    if (!is.na(birth)) return(birth)
  }
  stop("Could not find a birth date for ", id,
       ". Check the player name or Tennis Abstract availability.", call. = FALSE)
}

#' Download match data from Tennis Abstract
#' @param player: A single player name, such as `"Serena Williams"`.
#' @return A data frame with match dates, opponents, results,inclusing the age differences, and ages in years.
#' The age difference is player age minus opponent age.
#' @export
get_career_matches <- function(player) {
  id <- player_id(player)
  address <- paste0("https://www.tennisabstract.com/jsmatches/", id, "Career.js")
  js <- read_tennis_abstract(address)
  if (!any(grepl("var\\s+morematchmx\\s*=", js, perl = TRUE))) {
    stop("Could not retrieve career matches for '", player,
         "'. Check the spelling or Tennis Abstract availability.", call. = FALSE)
  }
  matches <- calculate_match_ages(parse_career_matches(js), get_player_birth(id))
  matches[order(matches$match_date), ]
}
