#' Statistical Method References and Published Applications
#'
#' Bibliographic source for all 73 methods in the analysis_catalogue dataset.
#' Distinguishes methodological background from actual published applications.
#' Not every method yet has a validated, distinct applied example: blank applied
#' fields and `pending_applied_study` are deliberate and must not be displayed as
#' proof of efficacy. Several historical references are textbooks or reviews,
#' rather than the original discovery paper. No inference about validity of an
#' analysis can be made solely from its use in a published study.
#'
#' @format A data frame with 73 rows and 10 columns:
#' \describe{
#'   \item{method_id}{Stable identifier AA01 through AA73.}
#'   \item{method_name}{Method display name.}
#'   \item{methodological_citation}{Foundational or authoritative bibliographic citation.}
#'   \item{methodological_url}{DOI, publisher, or stable institutional source URL.}
#'   \item{methodological_reference_type}{Type of background source.}
#'   \item{applied_citation}{Published applied example, if researched; otherwise empty.}
#'   \item{applied_url}{Stable applied-study link, if available; otherwise empty.}
#'   \item{applied_context}{Brief explanation of the published use-case.}
#'   \item{applied_status}{Whether the applied example was reviewed or remains pending.}
#'   \item{review_note}{Important bibliographic or methodological caveats.}
#' }
"method_references"
