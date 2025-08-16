Generate a conventional commit message following https://www.conventionalcommits.org/en/v1.0.0/ specification and create the commit automatically.

Steps:

Analyze the current git changes using git status and git diff --staged
Determine the appropriate commit type (feat, fix, docs, style, refactor, test, chore, etc.)
Identify the scope if applicable (component, module, or area affected)
Write a concise description in imperative mood (50 chars or less)
Add a detailed body if the change is complex (wrap at 72 chars)
Include breaking change footer if applicable
Format as: type(scope): description
Create the commit with the generated message
Example formats:

feat(auth): add OAuth2 login support
fix(api): resolve null pointer in user endpoint
docs: update installation instructions
chore(deps): bump lodash to 4.17.21
Generate the most appropriate commit message based on the changes and commit automatically.
