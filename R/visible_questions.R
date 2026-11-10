#' Determine Visible Questionnaire Items
#'
#' @param answers Named list of coded questionnaire responses.
#' @return Character vector of visible question IDs.
#' @export

visible_questions <- function(answers = list()) {

  answers <- as.list(answers)

  ids <- questionnaire$question_id
  rules <- questionnaire_conditions

  visible <- setdiff(ids, unique(rules$question_id))

  repeat {

    remaining <- ids[!ids %in% visible]

    eligible <- vapply(remaining, function(id) {

      r <- rules[rules$question_id == id, ]

      any(vapply(seq_len(nrow(r)), function(i) {

        parent <- r$parent_id[i]
        response <- answers[[parent]]

        parent %in% visible &&
          !is.null(response) &&
          response %in% strsplit(
            r$allowed_values[i], "|", fixed = TRUE
          )[[1]]

      }, logical(1)))

    }, logical(1))

    new_visible <- c(visible, names(eligible)[eligible])

    if (length(new_visible) == length(visible)) break

    visible <- new_visible
  }

  ids[ids %in% visible]
}
