# CRUSH.md - Vim Configuration Repository

## Build/Lint/Test Commands
- No specific build system detected (vimrc configuration files)
- For linting Vim script: `vim -c 'set nomore' -c 'scriptnames' -c 'q'`
- For testing: No test framework detected (manual testing recommended)

## Code Style Guidelines
1. **Imports**:
   - Use `runtime` or `source` for loading other Vim scripts
   - Group related imports together with comments

2. **Formatting**:
   - Use 2-space indentation
   - Align related Vim commands vertically
   - Use snake_case for variable and function names

3. **Types**:
   - No strict typing (Vimscript is dynamically typed)
   - Prefix boolean variables with `is_` or `has_`

4. **Naming Conventions**:
   - Prefix script-local variables with `s:`
   - Prefix buffer-local variables with `b:`
   - Prefix global functions with plugin name

5. **Error Handling**:
   - Use `try`/`catch` blocks for critical operations
   - Check `v:errmsg` after commands that might fail
   - Use `:silent!` to suppress error messages when appropriate

6. **Documentation**:
   - Use Vim's help format for plugin documentation
   - Include usage examples in comments

7. **Plugin Management**:
   - Use vim-plug for plugin management (see `plug.vim`)
   - Group related plugins together with comments

## Git Ignore
- Added `.crush` directory to `.gitignore`