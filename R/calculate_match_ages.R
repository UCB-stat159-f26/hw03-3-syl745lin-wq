age_in_years <- function(match_date, birth_date) {
  as.numeric(match_date - birth_date) / 365.2425
}

parse_opponent_age <- function(field, match_date) {
  is_birth_date <- !is.na(field) & grepl("^[0-9]{8}$", field)
  age <- suppressWarnings(as.numeric(field))
  birth_date <- as.Date(field[is_birth_date], format = "%Y%m%d")
  age[is_birth_date] <- age_in_years(match_date[is_birth_date], birth_date)
  age
}

calculate_match_ages <- function(matches, player_birth) {
  matches$player_age <- age_in_years(matches$match_date, player_birth)
  matches$opponent_age <- parse_opponent_age(
    matches$opponent_age_field, matches$match_date
  )
  matches$age_difference <- matches$player_age - matches$opponent_age
  matches
}
