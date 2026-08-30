# Injectify Documentation Site (Hugo + Docsy)

This directory contains the official documentation website for **Injectify**, built with **Hugo Extended** and the **Google Docsy Theme**.\n\n---\n\n## Running the Documentation Locally

### 1. Prerequisites

- **Hugo Extended** (`v0.160+`):
  ```bash
  brew install hugo
  ```
- **Node.js** (`v18+`) & **npm**:
  ```bash
  cd docs
  npm install
  ```

### 2. Start the Local Server

```bash
cd docs
npm run serve
# or directly:
hugo server --disableFastRender
```

Navigate to `http://localhost:1313/` in your browser. Live reloading is enabled by default.

### 3. Build Static HTML

```bash
cd docs
npm run build
# or:
hugo --minify
```

The compiled static site will be output to `docs/public/`.

---\n\n## Site Architecture & Directory Structure

```
docs/
├── hugo.toml                 # Hugo & Docsy configuration
├── package.json              # Docsy asset dependencies (Bootstrap 5, FontAwesome, PostCSS)
├── go.mod                    # Hugo module definition (Docsy theme)
├── assets/
│   └── scss/
│       ├── _variables_project.scss # Typography, color palette, and Bootstrap overrides
│       └── _styles_project.scss    # Custom layout, responsive sidebar, and theme rules
└── content/
    ├── _index.md             # Landing page with hero banner & feature cards
    ├── blog/                 # Blog: news, release notes, deep dives
    │   ├── _index.md         # Blog landing page (year-grouped post list, RSS)
    │   └── 2026/             # Posts grouped by year in the URL (e.g. /blog/2026/<post>/)
    └── docs/
        ├── _index.md         # Main documentation map
        ├── getting-started/  # Installation, Quickstart, Monorepos
        ├── concepts/         # Architecture, Scopes, Micro-Packages, Environments
        ├── tasks/            # How-to step-by-step recipes
        ├── tutorials/        # End-to-end full walkthroughs
        └── reference/        # Annotations, Configuration, APIs, Glossary
```
