extract_match_rows <- function(js_lines) {
  js <- paste(js_lines, collapse = "\n")
  pattern <- paste0(
    "(?ms)^\\h*var\\h+morematchmx\\s*=\\s*",
    "(\\[.*?\\])(?:\\h*;|\\s*\\z)"
  )
  parts <- regmatches(js, regexec(pattern, js, perl = TRUE))[[1L]]
  if (length(parts) != 2L) {
    stop("Could not find the morematchmx array in the career file.", call. = FALSE)
  }
  jsonlite::fromJSON(parts[2L], simplifyVector = FALSE)
}

match_field <- function(rows, position) {
  vapply(rows, function(row) {
    if (length(row) < position || is.null(row[[position]])) {
      return(NA_character_)
    }
    as.character(row[[position]])
  }, character(1))
}

parse_career_matches <- function(js_lines) {
  rows <- extract_match_rows(js_lines)
  data.frame(
    match_date = as.Date(match_field(rows, 1L), format = "%Y%m%d"),
    result = match_field(rows, 5L),
    opponent = match_field(rows, 12L),
    opponent_age_field = match_field(rows, 17L)
  )
}
