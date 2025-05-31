# TJ-RPG
TJ styled RPG game developed by students at YGDA.

---
## Linting and Formatting
Uses [godot-gdscript-toolkit](https://github.com/Scony/godot-gdscript-toolkit) for linting and formatting.
Tested working on `python 3.8.5`, but should work on any version `>= 3.7`.

### How to lint and format
1. Install the requirements: 
    ```bash
    pip install -r requirements.txt
    ```
2. Stage your changes:
    ```bash
    git add .
    ```
3. Lint and format your changes
    ```bash
    pre-commit run
    ```
4. Make changes according to output
    ```
    misc/MarkovianPCG.gd:96: Error: Function argument name "aOrigin" is not valid (function-argument-name)
    misc/MarkovianPCG.gd:96: Error: Function argument name "aPos" is not valid (function-argument-name)
    ``` 
---

## Contributing
To contribute, fork this repo and create a PR with your changes. Please summarize your changes concisely in the PR for review. Follow instructions for linting and formating to make sure your code looks pretty.
