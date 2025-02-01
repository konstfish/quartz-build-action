# quartz-build-action

GitHub Action to build [Quartz](https://quartz.jzhao.xyz/) documentation sites directly from your content, without requiring the need to fork the main Quartz repository.

## Usage

Assuming you have a repository with Markdown files located at `docs`, a basic GitHub Pages deployment without any custom config using the `quartz-build-action` looks like this:

```yaml
name: Build Quartz Site
on:
  push:
    branches: ["main"]
permissions:
  contents: read
  pages: write
  id-token: write
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Setup Pages
        uses: actions/configure-pages@v5
      - name: Build
        uses: konstfish/quartz-build-action@v3
        with:
          # specify source folder
          source: docs
          # page title to be displayed in the browser
          page_title: "Quartz"
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v4
  deploy:
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
```

Custom configuration & layout files can be included like this:

```yaml
- name: Build
  uses: konstfish/quartz-build-action@v3
  with:
    # markdown source folder
    source: docs
    # quartz config files, I like keeping them in my .github folder to reduce clutter
    # see https://quartz.jzhao.xyz/configuration & https://quartz.jzhao.xyz/layout respectively
    quartz_config: .github/quartz/quartz.config.ts
    quartz_layout: .github/quartz/quartz.layout.ts
    # quartz static content
    quartz_icon:   .github/quartz/favicon.png
    quartz_banner: .github/quartz/og_image.png
```

A productive example of a workflow using this action can be found [here](https://github.com/konstfish/shoal/blob/main/.github/workflows/publish_blog.yaml).

### Action inputs

| Input           | Default   | Description                             |
| --------------- | --------- | --------------------------------------- |
| `source`        | `./`      | The directory to build from             |
| `destination`   | `./_site` | The directory to write output into      |
| `page_title`    | `Quartz`  | Title of resulting Quartz Page          |
| `quartz_config` | ``        | Path to custom Quartz config file       |
| `quartz_layout` | ``        | Path to custom Quartz layout file       |
| `quartz_icon`   | ``        | Path to custom Quartz Page icon (png)   |
| `quartz_banner` | ``        | Path to custom Quartz Page banner (png) |
