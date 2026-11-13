library(tenniscareer)

women_js <- paste0(
  'var morematchmx = [["19951030","Canadian Open","Carpet","W","L",',
  '"","","WC","Q1","6-1 6-1","3","Anne Miller","149","7","","R","19770119"]];'
)
men_js <- paste0(
  'var morematchmx = [["20010910","Spain F10","Hard","S","L",',
  '"","","WC","R32","2-6 7-5 6-2","3","Guillermo Platel","731","","","R","22.264202601"]];'
)

women <- tenniscareer:::parse_career_matches(women_js)
men <- tenniscareer:::parse_career_matches(men_js)
women <- tenniscareer:::calculate_match_ages(women, as.Date("1981-09-26"))
men <- tenniscareer:::calculate_match_ages(men, as.Date("1986-06-03"))

stopifnot(
  identical(women$match_date, as.Date("1995-10-30")),
  identical(women$opponent, "Anne Miller"),
  identical(women$result, "L"),
  abs(women$opponent_age - 18.77657) < 1e-5,
  abs(women$age_difference - (-4.684559)) < 1e-5,
  identical(men$match_date, as.Date("2001-09-10")),
  identical(men$opponent, "Guillermo Platel"),
  abs(men$opponent_age - 22.264202601) < 1e-8,
  abs(men$age_difference - (-6.992157)) < 1e-5
)

cat("Offline career match tests passed\n")
