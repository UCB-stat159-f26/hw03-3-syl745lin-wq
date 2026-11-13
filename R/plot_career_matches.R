#' Plot career matches by age
#' @param matches a data frame returned by `get_career_matches()`.
#' @return output is a scatter plot.
#' @importFrom rlang .data
#' @export
plot_career_matches <- function(matches) {
  ggplot2::ggplot(matches, ggplot2::aes(
    x = .data[["player_age"]],
    y = .data[["age_difference"]],
    colour = .data[["result"]]
  )) +
    ggplot2::geom_hline(yintercept = 0, colour = "grey70") +
    ggplot2::geom_point(alpha = 0.7, na.rm = TRUE) +
    ggplot2::scale_colour_manual(
      values = c(W = "#0072B2", L = "#D55E00"),
      labels = c(W = "Win", L = "Loss")
    ) +
    ggplot2::labs(
      x = "Player age (years)",
      y = "Player age minus opponent age (years)",
      colour = "Result"
    ) +
    ggplot2::theme_minimal()
}
