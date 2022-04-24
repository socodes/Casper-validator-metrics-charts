use_github_actions()

use_github_actions_badge(name = "R-CMD-check", repo_spec = NULL)

use_github_action(
  name,
  url = NULL,
  save_as = NULL,
  readme = NULL,
  ignore = TRUE,
  open = FALSE
)

use_github_action_check_release(
  save_as = "R-CMD-check.yaml",
  ignore = TRUE,
  open = FALSE
)

use_github_action_check_standard(
  save_as = "R-CMD-check.yaml",
  ignore = TRUE,
  open = FALSE
)

use_github_action_pr_commands(
  save_as = "pr-commands.yaml",
  ignore = TRUE,
  open = FALSE
)