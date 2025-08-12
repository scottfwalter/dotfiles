name: code-review
description: Perform a comprehensive code review with suggestions for improvements
prompt: |

Please perform a thorough code review of the provided code. Focus on:

## Code Quality & Best Practices

- Code structure, organization, and readability
- Adherence to language-specific conventions and best practices
- Proper naming conventions for variables, functions, and classes
- Code complexity and potential simplifications

## Performance & Efficiency

- Performance bottlenecks or inefficient algorithms
- Memory usage optimization opportunities
- Database query efficiency (if applicable)

## Security & Safety

- Security vulnerabilities or potential attack vectors
- Input validation and sanitization
- Error handling and edge cases
- Data exposure risks

## Maintainability

- Code reusability and modularity
- Documentation and comments
- Testing coverage gaps
- Dependency management

## Bug Detection

- Logic errors or potential bugs
- Race conditions or concurrency issues
- Boundary conditions and edge cases

For each issue found, please provide:

1. **Severity**: Critical/High/Medium/Low
2. **Category**: Which area above it falls into
3. **Description**: Clear explanation of the issue
4. **Suggestion**: Specific improvement recommendation with code examples when helpful
5. **Rationale**: Why this change would be beneficial

Also highlight any particularly well-written sections of code and explain what makes them good.

Please be constructive and educational in your feedback, focusing on helping improve code quality while maintaining a collaborative tone.
