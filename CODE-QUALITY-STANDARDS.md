# Code Quality Standards

## Applies when

Writing any code, reviewing code, or refactoring.

## Rules

### Minimal

- No dead code, unused variables, or speculative features
- Only what's needed to pass tests (YAGNI)
- No premature optimization
- No "might need this later" code

### Efficient

- No O(n²) where O(n) is possible
- No unnecessary allocations
- No blocking operations where async is appropriate
- Proper algorithm selection

### Clear

- Simplest solution that works
- Clear, descriptive names
- Intent obvious from reading
- Follows existing codebase patterns

### Well-structured

- No duplication (DRY)
- Appropriate abstraction (not over/under-engineered)
- Single responsibility per function/class
- Clear separation of concerns

### Tested

- Test-driven development (tests first)
- Readable tests that document behavior
- Edge cases covered
- No untested code paths

## Checklist

- [ ] No dead code or unused variables
- [ ] No speculative features
- [ ] Simplest solution chosen
- [ ] Names clear and descriptive
- [ ] Follows codebase patterns
- [ ] No duplication
- [ ] Single responsibility per function
- [ ] Tests written first (TDD)
- [ ] Edge cases tested
- [ ] No commented-out code
- [ ] No console.log/debug statements
- [ ] No TODO without ticket reference
- [ ] Max 3 levels of nesting
- [ ] Max 3 parameters per function
- [ ] No magic numbers (use named constants)

## Anti-patterns

- Commented-out code → delete (git has history)
- console.log in code → remove before commit
- TODO without ticket → add ticket reference or remove
- God objects/functions → split by responsibility
- Magic numbers → named constants
- Deep nesting (>3 levels) → extract functions
- Long parameter lists (>3) → use options object
- Boolean parameters → split into two functions
