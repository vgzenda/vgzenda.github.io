# Local Website + Blog Workflow

## 1) Edit and preview locally

### Option A (recommended): Docker

```bash
docker compose pull
docker compose up
```

Open [http://localhost:8080](http://localhost:8080).

### Option B: local Ruby setup

```bash
bundle install
pip install jupyter
bundle exec jekyll serve
```

Open [http://localhost:4000](http://localhost:4000).

## 2) Write a new post

1. Generate a new post file with:

```bash
./_scripts/new-post.sh "Your Post Title"
```

Or copy `_drafts/latex-blog-template.md` to `_posts/YYYY-MM-DD-your-title.md`.
2. Update front matter fields (`title`, `date`, `description`, `tags`, `categories`).
3. Paste sections from your LaTeX notes.
4. Use your preamble shortcuts directly in math blocks.

Example shortcuts now supported globally:

- `\mbR`, `\mcL`, `\mse`
- `\pp{f}{x}`, `\dd{f}{t}`, `\CovDeriv{\Gamma}{t}{\mcV}`
- `\bq`, `\bxi`, `\wh{\mcE}`

## 3) Bibliography for blog posts

Your BibTeX file is available at:

- `_bibliography/2025-06-09-cosserat.bib`

Add citation/render blocks in posts with Jekyll Scholar if you want bibliography sections.

## 4) Push to the live website

From the repository root:

```bash
git remote -v
```

If no `origin` is listed, add it once:

```bash
git remote add origin git@github.com:<your-username>/<your-repo>.git
```

Then push:

```bash
git add .
git commit -m "Add/update blog post"
git push origin main
```

The GitHub Actions workflow in `.github/workflows/deploy.yml` builds and publishes your site automatically.

## 5) Where macro shortcuts live

- Global macros: `assets/js/mathjax-macros.js`
- MathJax setup: `assets/js/mathjax-setup.js`
- Optional per-post overrides: front matter key `mathjax_macros`
